<?php

namespace App\Http\Controllers;

use App\Models\Drug;
use App\Models\Category;
use App\Models\Subcategory;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class DrugController extends Controller
{
    /**
     * Display a listing of products/drugs.
     */
    public function index(Request $request): Response
    {
        $query = Drug::with(['category', 'subcategory'])
            ->withCount('stockItems');

        // Search filter
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('brand_name', 'like', "%{$search}%")
                  ->orWhere('generic_name', 'like', "%{$search}%")
                  ->orWhere('barcode', 'like', "%{$search}%")
                  ->orWhere('manufacturer', 'like', "%{$search}%");
            });
        }

        // Category filter
        if ($request->filled('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        // Subcategory filter
        if ($request->filled('subcategory_id')) {
            $query->where('subcategory_id', $request->subcategory_id);
        }

        // Prescription only filter
        if ($request->filled('prescription_only')) {
            $query->where('is_prescription_only', $request->prescription_only === 'yes');
        }

        $drugs = $query->orderBy('brand_name')->paginate(20)->withQueryString();

        $categories = Category::active()->ordered()->get(['id', 'name']);

        return Inertia::render('Products/Index', [
            'drugs' => $drugs,
            'categories' => $categories,
            'filters' => $request->only(['search', 'category_id', 'subcategory_id', 'prescription_only']),
        ]);
    }

    /**
     * Show the form for creating a new product/drug.
     */
    public function create(): Response
    {
        $categories = Category::active()
            ->ordered()
            ->with(['subcategories' => function ($query) {
                $query->active()->ordered();
            }])
            ->get();

        return Inertia::render('Products/Create', [
            'categories' => $categories,
        ]);
    }

    /**
     * Store a newly created product/drug.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'brand_name' => 'required|string|max:255',
            'generic_name' => 'nullable|string|max:255',
            'category_id' => 'required|exists:categories,id',
            'subcategory_id' => 'nullable|exists:subcategories,id',
            'strength' => 'nullable|string|max:100',
            'dosage_form' => 'nullable|string|max:100',
            'barcode' => 'nullable|string|max:50|unique:drugs,barcode',
            'manufacturer' => 'nullable|string|max:255',
            'description' => 'nullable|string|max:1000',
            'is_prescription_only' => 'boolean',
            'controlled_substance_class' => 'nullable|string|max:50',
        ]);

        $validated['is_prescription_only'] = $validated['is_prescription_only'] ?? false;

        $drug = Drug::create($validated);

        return redirect()->route('products.index')
            ->with('success', 'Product created successfully.');
    }

    /**
     * Display the specified product/drug.
     */
    public function show(Drug $product): Response
    {
        $product->load(['category', 'subcategory', 'stockItems' => function ($query) {
            $query->with('branch:id,name')
                  ->where('quantity_available', '>', 0)
                  ->orderBy('expiry_date');
        }]);

        return Inertia::render('Products/Show', [
            'product' => $product,
        ]);
    }

    /**
     * Show the form for editing the specified product/drug.
     */
    public function edit(Drug $product): Response
    {
        $product->load([
            'category',
            'subcategory',
            'stockItems' => function ($query) {
                $query->with('branch:id,name')
                      ->orderBy('expiry_date');
            }
        ]);

        $categories = Category::active()
            ->ordered()
            ->with(['subcategories' => function ($query) {
                $query->active()->ordered();
            }])
            ->get();

        return Inertia::render('Products/Edit', [
            'product' => $product,
            'categories' => $categories,
        ]);
    }

    /**
     * Update the specified product/drug.
     */
    public function update(Request $request, Drug $product)
    {
        $validated = $request->validate([
            'brand_name' => 'required|string|max:255',
            'generic_name' => 'nullable|string|max:255',
            'category_id' => 'required|exists:categories,id',
            'subcategory_id' => 'nullable|exists:subcategories,id',
            'strength' => 'nullable|string|max:100',
            'dosage_form' => 'nullable|string|max:100',
            'barcode' => 'nullable|string|max:50|unique:drugs,barcode,' . $product->id,
            'manufacturer' => 'nullable|string|max:255',
            'description' => 'nullable|string|max:1000',
            'is_prescription_only' => 'boolean',
            'controlled_substance_class' => 'nullable|string|max:50',
            'stock_items' => 'nullable|array',
            'stock_items.*.id' => 'nullable|exists:stock_items,id',
            'stock_items.*.batch_number' => 'required|string|max:100',
            'stock_items.*.expiry_date' => 'required|date|after:today',
            'stock_items.*.quantity_available' => 'required|integer|min:0',
        ]);

        $validated['is_prescription_only'] = $validated['is_prescription_only'] ?? false;

        // Update product details
        $product->update(collect($validated)->except('stock_items')->toArray());

        // Update stock items if provided
        if (isset($validated['stock_items'])) {
            foreach ($validated['stock_items'] as $stockItemData) {
                if (isset($stockItemData['id'])) {
                    // Update existing stock item
                    $stockItem = $product->stockItems()->findOrFail($stockItemData['id']);

                    // Check for batch number uniqueness (excluding current item)
                    $duplicateBatch = $product->stockItems()
                        ->where('branch_id', $stockItem->branch_id)
                        ->where('batch_number', $stockItemData['batch_number'])
                        ->where('id', '!=', $stockItem->id)
                        ->exists();

                    if ($duplicateBatch) {
                        return back()->withErrors([
                            'stock_items' => "Batch number {$stockItemData['batch_number']} already exists for this product at this branch."
                        ]);
                    }

                    $stockItem->update([
                        'batch_number' => $stockItemData['batch_number'],
                        'expiry_date' => $stockItemData['expiry_date'],
                        'quantity_available' => $stockItemData['quantity_available'],
                    ]);
                }
            }
        }

        return redirect()->route('products.index')
            ->with('success', 'Product updated successfully.');
    }

    /**
     * Remove the specified product/drug (soft delete).
     */
    public function destroy(Drug $product)
    {
        // Check if product has active stock
        $hasStock = $product->stockItems()->where('quantity_available', '>', 0)->exists();

        if ($hasStock) {
            return back()->with('error', 'Cannot delete product with active stock. Please dispose of stock first.');
        }

        $product->delete();

        return redirect()->route('products.index')
            ->with('success', 'Product deleted successfully.');
    }
}
