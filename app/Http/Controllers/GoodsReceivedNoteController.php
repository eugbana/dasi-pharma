<?php

namespace App\Http\Controllers;

use App\Models\GoodsReceivedNote;
use App\Models\GoodsReceivedItem;
use App\Models\PurchaseOrder;
use App\Models\StockItem;
use App\Models\StockMovement;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\DB;

/**
 * GoodsReceivedNoteController
 * 
 * Manages goods receipt with quality control and stock item creation.
 */
class GoodsReceivedNoteController extends Controller
{
    /**
     * Display a listing of GRNs.
     */
    public function index(Request $request): Response
    {
        $branchId = $request->user()->branch_id;

        $query = GoodsReceivedNote::with(['purchaseOrder.supplier', 'branch', 'receiver'])
            ->where('branch_id', $branchId);

        // Search filter
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('grn_number', 'like', "%{$search}%")
                    ->orWhereHas('purchaseOrder', function ($pq) use ($search) {
                        $pq->where('order_number', 'like', "%{$search}%")
                            ->orWhereHas('supplier', function ($sq) use ($search) {
                                $sq->where('name', 'like', "%{$search}%");
                            });
                    });
            });
        }

        // Status filter
        if ($request->filled('status')) {
            $query->byStatus($request->status);
        }

        $grns = $query->orderBy('received_date', 'desc')
            ->orderBy('created_at', 'desc')
            ->paginate(20)
            ->withQueryString();

        return Inertia::render('Procurement/GoodsReceivedNotes/Index', [
            'grns' => $grns,
            'filters' => $request->only(['search', 'status']),
            'statuses' => [
                GoodsReceivedNote::STATUS_PENDING_QUALITY_CHECK => 'Pending Quality Check',
                GoodsReceivedNote::STATUS_APPROVED => 'Approved',
                GoodsReceivedNote::STATUS_REJECTED => 'Rejected',
            ],
        ]);
    }

    /**
     * Show the form for creating a new GRN.
     */
    public function create(Request $request): Response
    {
        $branchId = $request->user()->branch_id;

        // Get approved purchase orders that are not fully received
        $purchaseOrders = PurchaseOrder::with(['supplier', 'items.drug'])
            ->where('branch_id', $branchId)
            ->whereIn('status', [
                PurchaseOrder::STATUS_APPROVED,
                PurchaseOrder::STATUS_PARTIALLY_RECEIVED,
            ])
            ->orderBy('order_date', 'desc')
            ->get();

        return Inertia::render('Procurement/GoodsReceivedNotes/Create', [
            'purchaseOrders' => $purchaseOrders,
        ]);
    }

    /**
     * Store a newly created GRN.
     */
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'purchase_order_id' => 'required|exists:purchase_orders,id',
            'received_date' => 'required|date',
            'notes' => 'nullable|string|max:1000',
            'items' => 'required|array|min:1',
            'items.*.drug_id' => 'required|exists:drugs,id',
            'items.*.batch_number' => 'required|string|max:100',
            'items.*.manufacturing_date' => 'nullable|date|before:today',
            'items.*.expiry_date' => 'required|date|after:today',
            'items.*.quantity_received' => 'required|integer|min:1',
            'items.*.unit_price' => 'required|numeric|min:0',
        ]);

        DB::beginTransaction();
        try {
            // Generate GRN number
            $grnNumber = $this->generateGrnNumber();

            // Create GRN
            $grn = GoodsReceivedNote::create([
                'grn_number' => $grnNumber,
                'purchase_order_id' => $validated['purchase_order_id'],
                'branch_id' => $request->user()->branch_id,
                'received_by' => $request->user()->id,
                'received_date' => $validated['received_date'],
                'status' => GoodsReceivedNote::STATUS_PENDING_QUALITY_CHECK,
                'notes' => $validated['notes'] ?? null,
            ]);

            // Create GRN items
            foreach ($validated['items'] as $item) {
                GoodsReceivedItem::create([
                    'grn_id' => $grn->id,
                    'drug_id' => $item['drug_id'],
                    'batch_number' => $item['batch_number'],
                    'manufacturing_date' => $item['manufacturing_date'] ?? null,
                    'expiry_date' => $item['expiry_date'],
                    'quantity_received' => $item['quantity_received'],
                    'unit_price' => $item['unit_price'],
                    'quality_check_passed' => false,
                ]);
            }

            // Update PO status to partially received
            $purchaseOrder = PurchaseOrder::find($validated['purchase_order_id']);
            if ($purchaseOrder->status === PurchaseOrder::STATUS_APPROVED) {
                $purchaseOrder->update(['status' => PurchaseOrder::STATUS_PARTIALLY_RECEIVED]);
            }

            DB::commit();

            return redirect()->route('goods-received-notes.show', $grn->id)
                ->with('success', 'Goods received note created successfully. Proceed with quality check.');
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors(['error' => 'Failed to create GRN: ' . $e->getMessage()])->withInput();
        }
    }

    /**
     * Display the specified GRN.
     */
    public function show(GoodsReceivedNote $goodsReceivedNote): Response
    {
        $goodsReceivedNote->load([
            'purchaseOrder.supplier',
            'branch',
            'receiver',
            'items.drug',
        ]);

        return Inertia::render('Procurement/GoodsReceivedNotes/Show', [
            'grn' => $goodsReceivedNote,
        ]);
    }

    /**
     * Approve GRN after quality check and create stock items.
     */
    public function approveQualityCheck(Request $request, GoodsReceivedNote $goodsReceivedNote): RedirectResponse
    {
        if ($goodsReceivedNote->status !== GoodsReceivedNote::STATUS_PENDING_QUALITY_CHECK) {
            return back()->withErrors(['error' => 'Only pending GRNs can be approved.']);
        }

        $validated = $request->validate([
            'items' => 'required|array',
            'items.*.id' => 'required|exists:goods_received_items,id',
            'items.*.quality_check_passed' => 'required|boolean',
            'items.*.quality_notes' => 'nullable|string|max:500',
            'items.*.selling_price' => 'required_if:items.*.quality_check_passed,true|numeric|min:0',
        ]);

        DB::beginTransaction();
        try {
            $hasApprovedItems = false;

            foreach ($validated['items'] as $itemData) {
                $grnItem = GoodsReceivedItem::find($itemData['id']);

                // Update quality check status
                $grnItem->update([
                    'quality_check_passed' => $itemData['quality_check_passed'],
                    'quality_notes' => $itemData['quality_notes'] ?? null,
                ]);

                // Create stock item if quality check passed
                if ($itemData['quality_check_passed']) {
                    $hasApprovedItems = true;

                    // Create stock item
                    $stockItem = StockItem::create([
                        'drug_id' => $grnItem->drug_id,
                        'branch_id' => $goodsReceivedNote->branch_id,
                        'batch_number' => $grnItem->batch_number,
                        'manufacturing_date' => $grnItem->manufacturing_date,
                        'expiry_date' => $grnItem->expiry_date,
                        'purchase_price' => $grnItem->unit_price,
                        'selling_price' => $itemData['selling_price'],
                        'quantity_available' => $grnItem->quantity_received,
                        'minimum_stock_level' => 10, // Default value
                        'reorder_point' => 20, // Default value
                    ]);

                    // Create stock movement for audit trail
                    StockMovement::create([
                        'stock_item_id' => $stockItem->id,
                        'movement_type' => 'purchase',
                        'quantity' => $grnItem->quantity_received,
                        'reference_type' => GoodsReceivedNote::class,
                        'reference_id' => $goodsReceivedNote->id,
                        'user_id' => auth()->id(),
                        'reason' => "GRN: {$goodsReceivedNote->grn_number}",
                    ]);
                }
            }

            // Update GRN status
            $grnStatus = $hasApprovedItems
                ? GoodsReceivedNote::STATUS_APPROVED
                : GoodsReceivedNote::STATUS_REJECTED;

            $goodsReceivedNote->update(['status' => $grnStatus]);

            // Check if all items from PO have been received
            $this->updatePurchaseOrderStatus($goodsReceivedNote->purchase_order_id);

            DB::commit();

            $message = $hasApprovedItems
                ? 'Quality check completed. Stock items created successfully.'
                : 'Quality check completed. All items rejected.';

            return back()->with('success', $message);
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors(['error' => 'Failed to approve quality check: ' . $e->getMessage()]);
        }
    }

    /**
     * Update purchase order status based on received quantities.
     */
    private function updatePurchaseOrderStatus(int $purchaseOrderId): void
    {
        $purchaseOrder = PurchaseOrder::with(['items', 'goodsReceivedNotes.items'])
            ->find($purchaseOrderId);

        // Calculate total ordered vs received for each drug
        $allItemsReceived = true;
        foreach ($purchaseOrder->items as $poItem) {
            $totalReceived = $purchaseOrder->goodsReceivedNotes
                ->where('status', GoodsReceivedNote::STATUS_APPROVED)
                ->flatMap->items
                ->where('drug_id', $poItem->drug_id)
                ->where('quality_check_passed', true)
                ->sum('quantity_received');

            if ($totalReceived < $poItem->quantity_ordered) {
                $allItemsReceived = false;
                break;
            }
        }

        if ($allItemsReceived) {
            $purchaseOrder->update(['status' => PurchaseOrder::STATUS_COMPLETED]);
        }
    }

    /**
     * Generate unique GRN number.
     */
    private function generateGrnNumber(): string
    {
        $prefix = 'GRN';
        $date = now()->format('Ym');
        $count = GoodsReceivedNote::whereYear('created_at', now()->year)
            ->whereMonth('created_at', now()->month)
            ->count() + 1;

        return sprintf('%s-%s-%06d', $prefix, $date, $count);
    }
}
