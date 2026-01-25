<?php

namespace App\Http\Controllers;

use App\Models\Drug;
use App\Models\StockItem;
use App\Models\Category;
use App\Models\Subcategory;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    /**
     * Autocomplete search for products.
     * Searches across brand name, generic name, and category.
     */
    public function autocomplete(Request $request)
    {
        $validated = $request->validate([
            'query' => 'required|string|min:2',
            'branch_id' => 'nullable|exists:branches,id',
            'limit' => 'nullable|integer|min:1|max:50',
        ]);

        $query = $validated['query'];
        $branchId = $validated['branch_id'] ?? $request->user()->branch_id;
        $limit = $validated['limit'] ?? 10;

        // Search drugs
        $drugs = Drug::with(['category', 'subcategory'])
            ->where(function ($q) use ($query) {
                $q->where('brand_name', 'like', "%{$query}%")
                  ->orWhere('generic_name', 'like', "%{$query}%")
                  ->orWhereHas('category', function ($cat) use ($query) {
                      $cat->where('name', 'like', "%{$query}%");
                  })
                  ->orWhereHas('subcategory', function ($sub) use ($query) {
                      $sub->where('name', 'like', "%{$query}%");
                  });
            })
            ->limit($limit)
            ->get()
            ->map(function ($drug) use ($branchId) {
                // Get available stock for this drug at the branch
                $stockItem = StockItem::where('drug_id', $drug->id)
                    ->where('branch_id', $branchId)
                    ->inStock()
                    ->notExpired()
                    ->orderBy('expiry_date')
                    ->first();

                return [
                    'id' => $drug->id,
                    'brand_name' => $drug->brand_name,
                    'generic_name' => $drug->generic_name,
                    'full_name' => $drug->full_name,
                    'strength' => $drug->strength,
                    'dosage_form' => $drug->dosage_form,
                    'barcode' => $drug->barcode,
                    'category' => $drug->category?->name,
                    'subcategory' => $drug->subcategory?->name,
                    'is_prescription_only' => $drug->is_prescription_only,
                    'requires_prescription' => $drug->is_prescription_only,
                    'stock_available' => $stockItem ? $stockItem->quantity_available : 0,
                    'selling_price' => $stockItem ? $stockItem->selling_price : null,
                    'in_stock' => $stockItem !== null,
                    'stock_item' => $stockItem ? [
                        'id' => $stockItem->id,
                        'batch_number' => $stockItem->batch_number,
                        'quantity_available' => $stockItem->quantity_available,
                        'selling_price' => $stockItem->selling_price,
                        'expiry_date' => $stockItem->expiry_date,
                    ] : null,
                ];
            });

        return response()->json([
            'success' => true,
            'products' => $drugs,
        ]);
    }

    /**
     * Get product details by barcode.
     */
    public function getByBarcode(Request $request)
    {
        $validated = $request->validate([
            'barcode' => 'required|string',
            'branch_id' => 'nullable|exists:branches,id',
        ]);

        $branchId = $validated['branch_id'] ?? $request->user()->branch_id;

        // Find drug by barcode
        $drug = Drug::with(['category', 'subcategory'])
            ->where('barcode', $validated['barcode'])
            ->first();

        if (!$drug) {
            return response()->json([
                'success' => false,
                'message' => 'Product not found',
            ], 404);
        }

        // Get available stock
        $stockItem = StockItem::where('drug_id', $drug->id)
            ->where('branch_id', $branchId)
            ->inStock()
            ->notExpired()
            ->orderBy('expiry_date')
            ->first();

        return response()->json([
            'success' => true,
            'product' => [
                'id' => $drug->id,
                'brand_name' => $drug->brand_name,
                'generic_name' => $drug->generic_name,
                'full_name' => $drug->full_name,
                'strength' => $drug->strength,
                'dosage_form' => $drug->dosage_form,
                'barcode' => $drug->barcode,
                'category' => $drug->category?->name,
                'subcategory' => $drug->subcategory?->name,
                'is_prescription_only' => $drug->is_prescription_only,
                'requires_prescription' => $drug->is_prescription_only,
                'stock_available' => $stockItem ? $stockItem->quantity_available : 0,
                'selling_price' => $stockItem ? $stockItem->selling_price : null,
                'in_stock' => $stockItem !== null,
                'stock_item' => $stockItem ? [
                    'id' => $stockItem->id,
                    'batch_number' => $stockItem->batch_number,
                    'quantity_available' => $stockItem->quantity_available,
                    'selling_price' => $stockItem->selling_price,
                    'expiry_date' => $stockItem->expiry_date,
                ] : null,
            ],
        ]);
    }

    /**
     * Get categories for dropdown.
     */
    public function getCategories()
    {
        $categories = Category::active()
            ->ordered()
            ->with(['subcategories' => function ($query) {
                $query->active()->ordered();
            }])
            ->get();

        return response()->json([
            'success' => true,
            'categories' => $categories,
        ]);
    }

    /**
     * Get subcategories for a category.
     */
    public function getSubcategories(Request $request, $categoryId)
    {
        $subcategories = Subcategory::active()
            ->ordered()
            ->forCategory($categoryId)
            ->get();

        return response()->json([
            'success' => true,
            'subcategories' => $subcategories,
        ]);
    }

    /**
     * Store a new drug/product (API endpoint for inline creation).
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
            'is_prescription_only' => 'boolean',
        ]);

        // Set defaults
        $validated['is_prescription_only'] = $validated['is_prescription_only'] ?? false;

        $drug = Drug::create($validated);

        // Load relationships
        $drug->load(['category', 'subcategory']);

        return response()->json([
            'success' => true,
            'message' => 'Product created successfully',
            'drug' => [
                'id' => $drug->id,
                'brand_name' => $drug->brand_name,
                'generic_name' => $drug->generic_name,
                'full_name' => $drug->full_name,
                'strength' => $drug->strength,
                'dosage_form' => $drug->dosage_form,
                'barcode' => $drug->barcode,
                'category' => $drug->category?->name,
                'subcategory' => $drug->subcategory?->name,
                'is_prescription_only' => $drug->is_prescription_only,
            ],
        ]);
    }

    /**
     * Barcode lookup (alternative endpoint).
     */
    public function lookupBarcode(Request $request)
    {
        $validated = $request->validate([
            'barcode' => 'required|string',
        ]);

        $drug = Drug::with(['category', 'subcategory'])
            ->where('barcode', $validated['barcode'])
            ->first();

        if (!$drug) {
            return response()->json([
                'found' => false,
                'message' => 'Product not found with this barcode',
            ]);
        }

        return response()->json([
            'found' => true,
            'drug' => [
                'id' => $drug->id,
                'brand_name' => $drug->brand_name,
                'generic_name' => $drug->generic_name,
                'full_name' => $drug->full_name,
                'strength' => $drug->strength,
                'dosage_form' => $drug->dosage_form,
                'barcode' => $drug->barcode,
                'category' => $drug->category?->name,
                'subcategory' => $drug->subcategory?->name,
                'is_prescription_only' => $drug->is_prescription_only,
            ],
        ]);
    }

    /**
     * Store a new category (API endpoint for inline creation).
     */
    public function storeCategory(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:categories,name',
            'description' => 'nullable|string|max:500',
        ]);

        $validated['is_active'] = true;
        $validated['sort_order'] = Category::max('sort_order') + 1;

        $category = Category::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Category created successfully',
            'category' => [
                'id' => $category->id,
                'name' => $category->name,
                'slug' => $category->slug,
                'subcategories' => [],
            ],
        ]);
    }

    /**
     * Store a new subcategory (API endpoint for inline creation).
     */
    public function storeSubcategory(Request $request)
    {
        $validated = $request->validate([
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
            'description' => 'nullable|string|max:500',
        ]);

        // Check for duplicate within category
        $exists = Subcategory::where('category_id', $validated['category_id'])
            ->where('name', $validated['name'])
            ->exists();

        if ($exists) {
            return response()->json([
                'success' => false,
                'message' => 'A subcategory with this name already exists in this category',
            ], 422);
        }

        $validated['is_active'] = true;
        $validated['sort_order'] = Subcategory::where('category_id', $validated['category_id'])->max('sort_order') + 1;

        $subcategory = Subcategory::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Subcategory created successfully',
            'subcategory' => [
                'id' => $subcategory->id,
                'name' => $subcategory->name,
                'slug' => $subcategory->slug,
                'category_id' => $subcategory->category_id,
            ],
        ]);
    }

    /**
     * Update an existing category.
     */
    public function updateCategory(Request $request, Category $category)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:categories,name,' . $category->id,
            'description' => 'nullable|string|max:500',
        ]);

        $category->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Category updated successfully',
            'category' => [
                'id' => $category->id,
                'name' => $category->name,
                'slug' => $category->slug,
                'description' => $category->description,
                'subcategories' => $category->subcategories()->active()->ordered()->get(),
            ],
        ]);
    }

    /**
     * Delete a category.
     */
    public function deleteCategory(Category $category)
    {
        // Check if category has associated drugs
        $drugCount = $category->drugs()->count();

        if ($drugCount > 0) {
            return response()->json([
                'success' => false,
                'message' => "Cannot delete category. It has {$drugCount} associated product(s). Please reassign or delete the products first.",
            ], 422);
        }

        // Check if category has subcategories
        $subcategoryCount = $category->subcategories()->count();

        if ($subcategoryCount > 0) {
            return response()->json([
                'success' => false,
                'message' => "Cannot delete category. It has {$subcategoryCount} subcategory(ies). Please delete the subcategories first.",
            ], 422);
        }

        $category->delete();

        return response()->json([
            'success' => true,
            'message' => 'Category deleted successfully',
        ]);
    }

    /**
     * Update an existing subcategory.
     */
    public function updateSubcategory(Request $request, Subcategory $subcategory)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string|max:500',
        ]);

        // Check for duplicate within category (excluding current subcategory)
        $exists = Subcategory::where('category_id', $subcategory->category_id)
            ->where('name', $validated['name'])
            ->where('id', '!=', $subcategory->id)
            ->exists();

        if ($exists) {
            return response()->json([
                'success' => false,
                'message' => 'A subcategory with this name already exists in this category',
            ], 422);
        }

        $subcategory->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Subcategory updated successfully',
            'subcategory' => [
                'id' => $subcategory->id,
                'name' => $subcategory->name,
                'slug' => $subcategory->slug,
                'description' => $subcategory->description,
                'category_id' => $subcategory->category_id,
            ],
        ]);
    }

    /**
     * Delete a subcategory.
     */
    public function deleteSubcategory(Subcategory $subcategory)
    {
        // Check if subcategory has associated drugs
        $drugCount = $subcategory->drugs()->count();

        if ($drugCount > 0) {
            return response()->json([
                'success' => false,
                'message' => "Cannot delete subcategory. It has {$drugCount} associated product(s). Please reassign or delete the products first.",
            ], 422);
        }

        $subcategory->delete();

        return response()->json([
            'success' => true,
            'message' => 'Subcategory deleted successfully',
        ]);
    }
}
