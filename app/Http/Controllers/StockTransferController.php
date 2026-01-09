<?php

namespace App\Http\Controllers;

use App\Models\StockTransfer;
use App\Models\StockTransferItem;
use App\Models\StockItem;
use App\Models\StockMovement;
use App\Models\Branch;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\DB;

class StockTransferController extends Controller
{
    /**
     * Display a listing of stock transfers.
     */
    public function index(Request $request): Response
    {
        $branchId = $request->user()->branch_id;
        
        $query = StockTransfer::with(['fromBranch', 'toBranch', 'requester', 'approver'])
            ->where(function ($q) use ($branchId) {
                $q->where('from_branch_id', $branchId)
                    ->orWhere('to_branch_id', $branchId);
            });

        // Filter by status
        if ($request->filled('status')) {
            $query->byStatus($request->status);
        }

        // Filter by direction
        if ($request->filled('direction')) {
            if ($request->direction === 'outgoing') {
                $query->where('from_branch_id', $branchId);
            } elseif ($request->direction === 'incoming') {
                $query->where('to_branch_id', $branchId);
            }
        }

        $transfers = $query->orderBy('transfer_date', 'desc')
            ->orderBy('created_at', 'desc')
            ->paginate(20)
            ->withQueryString();

        return Inertia::render('Inventory/StockTransfers/Index', [
            'transfers' => $transfers,
            'filters' => $request->only(['status', 'direction']),
            'statuses' => [
                StockTransfer::STATUS_PENDING => 'Pending',
                StockTransfer::STATUS_APPROVED => 'Approved',
                StockTransfer::STATUS_IN_TRANSIT => 'In Transit',
                StockTransfer::STATUS_RECEIVED => 'Received',
                StockTransfer::STATUS_CANCELLED => 'Cancelled',
            ],
        ]);
    }

    /**
     * Show the form for creating a new stock transfer.
     */
    public function create(): Response
    {
        $currentBranchId = auth()->user()->branch_id;
        
        $branches = Branch::active()
            ->where('id', '!=', $currentBranchId)
            ->orderBy('name')
            ->get(['id', 'name', 'code']);

        $stockItems = StockItem::with('drug')
            ->where('branch_id', $currentBranchId)
            ->available()
            ->FEFO()
            ->get()
            ->map(function ($item) {
                return [
                    'id' => $item->id,
                    'drug_id' => $item->drug_id,
                    'drug_name' => $item->drug->name,
                    'batch_number' => $item->batch_number,
                    'expiry_date' => $item->expiry_date->format('Y-m-d'),
                    'quantity_available' => $item->quantity_available,
                    'label' => "{$item->drug->name} - Batch: {$item->batch_number} (Qty: {$item->quantity_available})",
                ];
            });

        return Inertia::render('Inventory/StockTransfers/Create', [
            'branches' => $branches,
            'stockItems' => $stockItems,
        ]);
    }

    /**
     * Store a newly created stock transfer.
     */
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'to_branch_id' => 'required|exists:branches,id',
            'transfer_date' => 'required|date',
            'notes' => 'nullable|string|max:1000',
            'items' => 'required|array|min:1',
            'items.*.stock_item_id' => 'required|exists:stock_items,id',
            'items.*.quantity' => 'required|integer|min:1',
        ]);

        DB::beginTransaction();
        try {
            // Generate transfer number
            $transferNumber = 'TRF-' . now()->format('Ymd') . '-' . str_pad(StockTransfer::count() + 1, 4, '0', STR_PAD_LEFT);

            // Create transfer
            $transfer = StockTransfer::create([
                'transfer_number' => $transferNumber,
                'from_branch_id' => $request->user()->branch_id,
                'to_branch_id' => $validated['to_branch_id'],
                'requested_by' => $request->user()->id,
                'transfer_date' => $validated['transfer_date'],
                'status' => StockTransfer::STATUS_PENDING,
                'notes' => $validated['notes'] ?? null,
            ]);

            // Create transfer items
            foreach ($validated['items'] as $item) {
                $stockItem = StockItem::findOrFail($item['stock_item_id']);
                
                // Validate quantity
                if ($item['quantity'] > $stockItem->quantity_available) {
                    throw new \Exception("Insufficient quantity for {$stockItem->drug->name}");
                }

                StockTransferItem::create([
                    'stock_transfer_id' => $transfer->id,
                    'stock_item_id' => $item['stock_item_id'],
                    'drug_id' => $stockItem->drug_id,
                    'batch_number' => $stockItem->batch_number,
                    'quantity' => $item['quantity'],
                ]);
            }

            DB::commit();

            return redirect()->route('stock-transfers.index')
                ->with('success', 'Stock transfer created successfully.');
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors(['error' => 'Failed to create transfer: ' . $e->getMessage()]);
        }
    }

    /**
     * Display the specified stock transfer.
     */
    public function show(StockTransfer $stockTransfer): Response
    {
        $stockTransfer->load([
            'fromBranch',
            'toBranch',
            'requester',
            'approver',
            'items.stockItem.drug',
        ]);

        return Inertia::render('Inventory/StockTransfers/Show', [
            'transfer' => $stockTransfer,
        ]);
    }
}

