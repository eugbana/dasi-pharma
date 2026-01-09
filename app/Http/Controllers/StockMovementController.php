<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Traits\BranchAware;
use App\Models\Branch;
use App\Models\StockMovement;
use App\Models\StockItem;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\DB;

class StockMovementController extends Controller
{
    use BranchAware;

    /**
     * Display a listing of stock movements.
     */
    public function index(Request $request): Response
    {
        $query = StockMovement::with(['stockItem.drug', 'stockItem.branch', 'user']);

        // Apply branch filter via stockItem relationship
        $this->applyBranchFilterViaRelation($query, $request, 'stockItem');

        // Filter by movement type
        if ($request->filled('movement_type')) {
            $query->byType($request->movement_type);
        }

        // Filter by date range
        if ($request->filled('date_from') && $request->filled('date_to')) {
            $query->dateRange($request->date_from, $request->date_to);
        }

        // Filter by user
        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        $movements = $query->orderBy('movement_date', 'desc')
            ->orderBy('created_at', 'desc')
            ->paginate(20)
            ->withQueryString();

        // Get branches for Super Admin filter dropdown
        $branches = $request->user()->isSuperAdmin()
            ? Branch::active()->orderBy('name')->get(['id', 'name', 'code'])
            : collect([]);

        return Inertia::render('Inventory/StockMovements/Index', [
            'movements' => $movements,
            'filters' => $request->only(['movement_type', 'date_from', 'date_to', 'user_id', 'branch_id']),
            'movementTypes' => [
                StockMovement::TYPE_PURCHASE => 'Purchase',
                StockMovement::TYPE_SALE => 'Sale',
                StockMovement::TYPE_TRANSFER_IN => 'Transfer In',
                StockMovement::TYPE_TRANSFER_OUT => 'Transfer Out',
                StockMovement::TYPE_ADJUSTMENT => 'Adjustment',
                StockMovement::TYPE_EXPIRY => 'Expiry',
                StockMovement::TYPE_RETURN => 'Return',
            ],
            'branches' => $branches,
            'branchFilter' => $this->getBranchFilterInfo($request),
        ]);
    }

    /**
     * Show the form for creating a new stock movement (adjustment).
     */
    public function create(Request $request): Response
    {
        $user = $request->user();

        // For Super Admin, get stock items from all branches or selected branch
        $query = StockItem::with(['drug', 'branch'])->available();

        if (!$user->isSuperAdmin()) {
            $query->where('branch_id', $user->branch_id);
        } elseif ($request->filled('branch_id')) {
            $query->where('branch_id', $request->branch_id);
        }

        $stockItems = $query->get()->map(function ($item) {
            return [
                'id' => $item->id,
                'label' => "{$item->drug->brand_name} - Batch: {$item->batch_number} (Qty: {$item->quantity_available})" . ($item->branch ? " [{$item->branch->code}]" : ''),
                'drug_name' => $item->drug->brand_name,
                'batch_number' => $item->batch_number,
                'current_quantity' => $item->quantity_available,
                'branch_id' => $item->branch_id,
                'branch_name' => $item->branch?->name,
            ];
        });

        // Get branches for Super Admin
        $branches = $user->isSuperAdmin()
            ? Branch::active()->orderBy('name')->get(['id', 'name', 'code'])
            : collect([]);

        return Inertia::render('Inventory/StockMovements/Create', [
            'stockItems' => $stockItems,
            'branches' => $branches,
            'branchFilter' => $this->getBranchFilterInfo($request),
        ]);
    }

    /**
     * Store a newly created stock movement (adjustment).
     */
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'stock_item_id' => 'required|exists:stock_items,id',
            'movement_type' => 'required|in:adjustment,expiry,return',
            'quantity' => 'required|integer|not_in:0',
            'reason' => 'required|string|max:500',
            'movement_date' => 'required|date|before_or_equal:today',
        ]);

        DB::beginTransaction();
        try {
            $stockItem = StockItem::findOrFail($validated['stock_item_id']);

            // Create the movement
            $movement = StockMovement::create([
                'stock_item_id' => $validated['stock_item_id'],
                'user_id' => $request->user()->id,
                'movement_type' => $validated['movement_type'],
                'quantity' => $validated['quantity'],
                'unit_cost' => $stockItem->purchase_price,
                'reason' => $validated['reason'],
                'movement_date' => $validated['movement_date'],
            ]);

            // Update stock quantity
            $stockItem->increment('quantity_available', $validated['quantity']);

            DB::commit();

            return redirect()->route('stock-movements.index')
                ->with('success', 'Stock movement recorded successfully.');
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors(['error' => 'Failed to record stock movement: ' . $e->getMessage()]);
        }
    }

    /**
     * Display the specified stock movement.
     */
    public function show(StockMovement $stockMovement): Response
    {
        $stockMovement->load(['stockItem.drug', 'stockItem.branch', 'user', 'reference']);

        return Inertia::render('Inventory/StockMovements/Show', [
            'movement' => $stockMovement,
        ]);
    }
}

