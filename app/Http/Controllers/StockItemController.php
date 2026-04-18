<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Traits\BranchAware;
use App\Models\StockItem;
use App\Models\StockMovement;
use App\Models\Drug;
use App\Models\Branch;
use App\Models\Category;
use App\Models\Subcategory;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Http\RedirectResponse;

class StockItemController extends Controller
{
    use BranchAware;

    /**
     * Display a listing of stock items.
     */
    public function index(Request $request): Response
    {
        $query = StockItem::with(['drug', 'branch'])
            ->whereHas('drug'); // Only include stock items with active (non-deleted) drugs

        // Apply branch filter (Super Admin sees all or selected branch, others see their branch)
        $this->applyBranchFilter($query, $request);

        // Search filter
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->whereHas('drug', function ($drugQuery) use ($search) {
                    $drugQuery->where('brand_name', 'like', "%{$search}%")
                        ->orWhere('generic_name', 'like', "%{$search}%");
                })->orWhere('batch_number', 'like', "%{$search}%");
            });
        }

        // Expiry status filter
        if ($request->filled('expiry_status')) {
            switch ($request->expiry_status) {
                case 'expired':
                    $query->expired();
                    break;
                case 'expiring_soon':
                    $query->expiringSoon(30);
                    break;
                case 'valid':
                    $query->where('expiry_date', '>', now()->addDays(30));
                    break;
            }
        }

        // Stock status filter
        if ($request->filled('stock_status')) {
            switch ($request->stock_status) {
                case 'low':
                    $query->lowStock();
                    break;
                case 'out':
                    $query->where('quantity_available', '<=', 0);
                    break;
                case 'available':
                    $query->available();
                    break;
            }
        }

        // Sort by FEFO by default
        $sortBy = $request->get('sort_by', 'fefo');
        if ($sortBy === 'fefo') {
            $query->FEFO();
        } else {
            $query->orderBy($sortBy, $request->get('sort_order', 'asc'));
        }

        $stockItems = $query->paginate(20)->withQueryString();

        // Get branches for Super Admin filter dropdown
        $branches = $request->user()->isSuperAdmin()
            ? Branch::active()->orderBy('name')->get(['id', 'name', 'code'])
            : collect([]);

        return Inertia::render('Inventory/StockItems/Index', [
            'stockItems' => $stockItems,
            'filters' => $request->only(['search', 'expiry_status', 'stock_status', 'sort_by', 'sort_order', 'branch_id']),
            'branches' => $branches,
            'branchFilter' => $this->getBranchFilterInfo($request),
        ]);
    }

    /**
     * Show the form for creating a new stock item.
     *
     * Accepts optional 'drug_id' query parameter for Quick Add Batch feature.
     */
    public function create(Request $request): Response
    {
        $drugs = Drug::with(['category', 'subcategory'])
            ->active()
            ->orderBy('brand_name')
            ->get(['id', 'brand_name', 'generic_name', 'strength', 'barcode', 'category_id', 'subcategory_id']);

        $categories = Category::active()
            ->ordered()
            ->with(['subcategories' => function ($query) {
                $query->active()->ordered();
            }])
            ->get();

        // Get pre-selected drug if drug_id is provided (Quick Add Batch)
        $preselectedDrug = null;
        if ($request->filled('drug_id')) {
            $preselectedDrug = Drug::with(['category', 'subcategory'])
                ->find($request->drug_id);
        }

        return Inertia::render('Inventory/StockItems/Create', [
            'drugs' => $drugs,
            'categories' => $categories,
            'preselectedDrug' => $preselectedDrug,
        ]);
    }

    /**
     * Store a newly created stock item.
     *
     * Quick Add Batch Feature:
     * - If a batch with same (drug_id, branch_id, batch_number) exists:
     *   Updates quantity_available and expiry_date, creates StockMovement
     * - If batch does not exist: Creates new StockItem record
     */
    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'drug_id' => 'required|exists:drugs,id',
            'batch_number' => 'required|string|max:100',
            'manufacturing_date' => 'nullable|date|before:today',
            'expiry_date' => 'required|date|after:today',
            'purchase_price' => 'required|numeric|min:0',
            'selling_price' => 'required|numeric|min:0|gte:purchase_price',
            'vat_applicable' => 'nullable|boolean',
            'quantity_available' => 'required|integer|min:1',
            'minimum_stock_level' => 'nullable|integer|min:0',
            'reorder_point' => 'nullable|integer|min:0',
        ]);

        $branchId = $request->user()->branch_id;
        $validated['branch_id'] = $branchId;
        $validated['vat_applicable'] = $request->boolean('vat_applicable');
        $validated['minimum_stock_level'] = $validated['minimum_stock_level'] ?? 0;
        $validated['reorder_point'] = $validated['reorder_point'] ?? 0;

        DB::beginTransaction();
        try {
            // Check if batch already exists for this drug at this branch
            $existingStockItem = StockItem::where('drug_id', $validated['drug_id'])
                ->where('branch_id', $branchId)
                ->where('batch_number', $validated['batch_number'])
                ->first();

            if ($existingStockItem) {
                // Batch exists - update quantity and expiry date
                $quantityToAdd = $validated['quantity_available'];

                // Update the existing stock item
                $existingStockItem->update([
                    'expiry_date' => $validated['expiry_date'],
                    'purchase_price' => $validated['purchase_price'],
                    'selling_price' => $validated['selling_price'],
                ]);

                // Increment quantity
                $existingStockItem->increment('quantity_available', $quantityToAdd);

                // Create stock movement for audit trail
                StockMovement::create([
                    'stock_item_id' => $existingStockItem->id,
                    'user_id' => $request->user()->id,
                    'movement_type' => StockMovement::TYPE_PURCHASE,
                    'quantity' => $quantityToAdd,
                    'unit_cost' => $validated['purchase_price'],
                    'movement_date' => now()->toDateString(),
                    'reason' => "Quick Add Batch: Added {$quantityToAdd} units to existing batch {$validated['batch_number']}",
                ]);

                DB::commit();

                return redirect()->route('stock-items.index')
                    ->with('success', "Batch updated successfully. Added {$quantityToAdd} units to existing batch.");
            } else {
                // Batch does not exist - create new stock item
                $stockItem = StockItem::create($validated);

                // Create stock movement for initial stock
                StockMovement::create([
                    'stock_item_id' => $stockItem->id,
                    'user_id' => $request->user()->id,
                    'movement_type' => StockMovement::TYPE_PURCHASE,
                    'quantity' => $validated['quantity_available'],
                    'unit_cost' => $validated['purchase_price'],
                    'movement_date' => now()->toDateString(),
                    'reason' => "Initial stock: New batch {$validated['batch_number']}",
                ]);

                DB::commit();

                return redirect()->route('stock-items.index')
                    ->with('success', 'Stock item added successfully.');
            }
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors(['error' => 'Failed to add stock item: ' . $e->getMessage()])->withInput();
        }
    }

    /**
     * Display the specified stock item.
     */
    public function show(StockItem $stockItem): Response
    {
        $stockItem->load(['drug', 'branch', 'stockMovements.user']);

        return Inertia::render('Inventory/StockItems/Show', [
            'stockItem' => $stockItem,
        ]);
    }

    /**
     * Show the form for editing the specified stock item.
     */
    public function edit(StockItem $stockItem): Response
    {
        $stockItem->load(['drug.category', 'drug.subcategory']);

        $drugs = Drug::with(['category', 'subcategory'])
            ->active()
            ->orderBy('brand_name')
            ->get(['id', 'brand_name', 'generic_name', 'strength', 'barcode', 'category_id', 'subcategory_id']);

        $categories = Category::active()
            ->ordered()
            ->with(['subcategories' => function ($query) {
                $query->active()->ordered();
            }])
            ->get();

        return Inertia::render('Inventory/StockItems/Edit', [
            'stockItem' => $stockItem,
            'drugs' => $drugs,
            'categories' => $categories,
        ]);
    }

    /**
     * Update the specified stock item.
     */
    public function update(Request $request, StockItem $stockItem): RedirectResponse
    {
        $validated = $request->validate([
            'purchase_price' => 'required|numeric|min:0',
            'selling_price' => 'required|numeric|min:0|gte:purchase_price',
            'vat_applicable' => 'nullable|boolean',
            'minimum_stock_level' => 'nullable|integer|min:0',
            'reorder_point' => 'nullable|integer|min:0',
        ]);

        $validated['vat_applicable'] = $request->boolean('vat_applicable');

        $stockItem->update($validated);

        return redirect()->route('stock-items.index')
            ->with('success', 'Stock item updated successfully.');
    }
}

