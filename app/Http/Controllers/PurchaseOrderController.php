<?php

namespace App\Http\Controllers;

use App\Models\PurchaseOrder;
use App\Models\PurchaseOrderItem;
use App\Models\Supplier;
use App\Models\Drug;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\DB;

/**
 * PurchaseOrderController
 * 
 * Manages purchase orders with approval workflow and status tracking.
 */
class PurchaseOrderController extends Controller
{
    /**
     * Display a listing of purchase orders.
     */
    public function index(Request $request): Response
    {
        $branchId = $request->user()->branch_id;

        $query = PurchaseOrder::with(['supplier', 'branch', 'creator', 'approver'])
            ->where('branch_id', $branchId);

        // Search filter
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('order_number', 'like', "%{$search}%")
                    ->orWhereHas('supplier', function ($sq) use ($search) {
                        $sq->where('name', 'like', "%{$search}%");
                    });
            });
        }

        // Status filter
        if ($request->filled('status')) {
            $query->byStatus($request->status);
        }

        // Date range filter
        if ($request->filled('date_from')) {
            $query->where('order_date', '>=', $request->date_from);
        }
        if ($request->filled('date_to')) {
            $query->where('order_date', '<=', $request->date_to);
        }

        $purchaseOrders = $query->orderBy('order_date', 'desc')
            ->orderBy('created_at', 'desc')
            ->paginate(20)
            ->withQueryString();

        return Inertia::render('Procurement/PurchaseOrders/Index', [
            'purchaseOrders' => $purchaseOrders,
            'filters' => $request->only(['search', 'status', 'date_from', 'date_to']),
            'statuses' => [
                PurchaseOrder::STATUS_DRAFT => 'Draft',
                PurchaseOrder::STATUS_PENDING_APPROVAL => 'Pending Approval',
                PurchaseOrder::STATUS_APPROVED => 'Approved',
                PurchaseOrder::STATUS_PARTIALLY_RECEIVED => 'Partially Received',
                PurchaseOrder::STATUS_COMPLETED => 'Completed',
                PurchaseOrder::STATUS_CANCELLED => 'Cancelled',
            ],
        ]);
    }

    /**
     * Show the form for creating a new purchase order.
     */
    public function create(): Response
    {
        $suppliers = Supplier::active()->orderBy('name')->get(['id', 'name', 'payment_terms', 'delivery_days']);
        $drugs = Drug::active()->orderBy('brand_name')->get(['id', 'brand_name', 'generic_name', 'strength', 'dosage_form']);

        return Inertia::render('Procurement/PurchaseOrders/Create', [
            'suppliers' => $suppliers,
            'drugs' => $drugs,
        ]);
    }

    /**
     * Store a newly created purchase order.
     */
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'supplier_id' => 'required|exists:suppliers,id',
            'order_date' => 'required|date',
            'expected_delivery_date' => 'nullable|date|after:order_date',
            'notes' => 'nullable|string|max:1000',
            'items' => 'required|array|min:1',
            'items.*.drug_id' => 'required|exists:drugs,id',
            'items.*.quantity_ordered' => 'required|integer|min:1',
            'items.*.unit_price' => 'required|numeric|min:0',
        ]);

        DB::beginTransaction();
        try {
            // Generate PO number
            $orderNumber = $this->generateOrderNumber();

            // Calculate total
            $totalAmount = collect($validated['items'])->sum(function ($item) {
                return $item['quantity_ordered'] * $item['unit_price'];
            });

            // Create purchase order
            $purchaseOrder = PurchaseOrder::create([
                'order_number' => $orderNumber,
                'supplier_id' => $validated['supplier_id'],
                'branch_id' => $request->user()->branch_id,
                'created_by' => $request->user()->id,
                'order_date' => $validated['order_date'],
                'expected_delivery_date' => $validated['expected_delivery_date'] ?? null,
                'status' => PurchaseOrder::STATUS_DRAFT,
                'total_amount' => $totalAmount,
                'notes' => $validated['notes'] ?? null,
            ]);

            // Create line items
            foreach ($validated['items'] as $item) {
                PurchaseOrderItem::create([
                    'purchase_order_id' => $purchaseOrder->id,
                    'drug_id' => $item['drug_id'],
                    'quantity_ordered' => $item['quantity_ordered'],
                    'unit_price' => $item['unit_price'],
                    'subtotal' => $item['quantity_ordered'] * $item['unit_price'],
                ]);
            }

            DB::commit();

            return redirect()->route('purchase-orders.show', $purchaseOrder->id)
                ->with('success', 'Purchase order created successfully.');
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors(['error' => 'Failed to create purchase order: ' . $e->getMessage()])->withInput();
        }
    }

    /**
     * Display the specified purchase order.
     */
    public function show(PurchaseOrder $purchaseOrder): Response
    {
        $purchaseOrder->load([
            'supplier',
            'branch',
            'creator',
            'approver',
            'items.drug',
            'goodsReceivedNotes.receiver',
        ]);

        return Inertia::render('Procurement/PurchaseOrders/Show', [
            'purchaseOrder' => $purchaseOrder,
        ]);
    }

    /**
     * Submit purchase order for approval.
     */
    public function submitForApproval(PurchaseOrder $purchaseOrder): RedirectResponse
    {
        if ($purchaseOrder->status !== PurchaseOrder::STATUS_DRAFT) {
            return back()->withErrors(['error' => 'Only draft purchase orders can be submitted for approval.']);
        }

        $purchaseOrder->update([
            'status' => PurchaseOrder::STATUS_PENDING_APPROVAL,
        ]);

        return back()->with('success', 'Purchase order submitted for approval.');
    }

    /**
     * Approve purchase order.
     */
    public function approve(PurchaseOrder $purchaseOrder): RedirectResponse
    {
        if ($purchaseOrder->status !== PurchaseOrder::STATUS_PENDING_APPROVAL) {
            return back()->withErrors(['error' => 'Only pending purchase orders can be approved.']);
        }

        $purchaseOrder->update([
            'status' => PurchaseOrder::STATUS_APPROVED,
            'approved_by' => auth()->id(),
            'approved_at' => now(),
        ]);

        return back()->with('success', 'Purchase order approved successfully.');
    }

    /**
     * Cancel purchase order.
     */
    public function cancel(PurchaseOrder $purchaseOrder): RedirectResponse
    {
        if (in_array($purchaseOrder->status, [PurchaseOrder::STATUS_COMPLETED, PurchaseOrder::STATUS_CANCELLED])) {
            return back()->withErrors(['error' => 'Cannot cancel completed or already cancelled purchase orders.']);
        }

        $purchaseOrder->update([
            'status' => PurchaseOrder::STATUS_CANCELLED,
        ]);

        return back()->with('success', 'Purchase order cancelled successfully.');
    }

    /**
     * Generate unique purchase order number.
     */
    private function generateOrderNumber(): string
    {
        $prefix = 'PO';
        $date = now()->format('Ym');
        $count = PurchaseOrder::whereYear('created_at', now()->year)
            ->whereMonth('created_at', now()->month)
            ->count() + 1;

        return sprintf('%s-%s-%06d', $prefix, $date, $count);
    }
}
