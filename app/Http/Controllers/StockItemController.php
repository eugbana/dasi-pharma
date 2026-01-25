<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Traits\BranchAware;
use App\Models\StockItem;
use App\Models\Drug;
use App\Models\Branch;
use App\Models\Category;
use App\Models\Subcategory;
use Illuminate\Http\Request;
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
        $query = StockItem::with(['drug', 'branch']);

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
     */
    public function create(): Response
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

        return Inertia::render('Inventory/StockItems/Create', [
            'drugs' => $drugs,
            'categories' => $categories,
        ]);
    }

    /**
     * Store a newly created stock item.
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

        $validated['branch_id'] = $request->user()->branch_id;
        $validated['vat_applicable'] = $request->boolean('vat_applicable');
        $validated['minimum_stock_level'] = $validated['minimum_stock_level'] ?? 0;
        $validated['reorder_point'] = $validated['reorder_point'] ?? 0;

        $stockItem = StockItem::create($validated);

        return redirect()->route('stock-items.index')
            ->with('success', 'Stock item added successfully.');
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
            'selling_price' => 'required|numeric|min:0',
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

