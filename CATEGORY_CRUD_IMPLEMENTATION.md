# Category & Subcategory CRUD Implementation Guide

## ✅ Completed Backend Changes

### 1. Models Updated
- **Category.php**: Added `updating` event to regenerate slug when name changes
- **Subcategory.php**: Added `updating` event to regenerate slug when name changes

### 2. ProductController.php - New Methods Added
```php
// Update category
public function updateCategory(Request $request, Category $category)

// Delete category (with safety checks)
public function deleteCategory(Category $category)

// Update subcategory
public function updateSubcategory(Request $request, Subcategory $subcategory)

// Delete subcategory (with safety checks)
public function deleteSubcategory(Subcategory $subcategory)
```

**Safety Features:**
- Categories cannot be deleted if they have associated products
- Categories cannot be deleted if they have subcategories
- Subcategories cannot be deleted if they have associated products
- Name uniqueness validation on update
- Automatic slug regeneration on name change

### 3. Routes Added (routes/web.php)
```php
Route::middleware('permission:drugs.manage')->group(function () {
    // Existing routes...
    Route::put('api/categories/{category}', [ProductController::class, 'updateCategory'])->name('api.categories.update');
    Route::delete('api/categories/{category}', [ProductController::class, 'deleteCategory'])->name('api.categories.delete');
    Route::put('api/subcategories/{subcategory}', [ProductController::class, 'updateSubcategory'])->name('api.subcategories.update');
    Route::delete('api/subcategories/{subcategory}', [ProductController::class, 'deleteSubcategory'])->name('api.subcategories.delete');
});
```

## 🔨 Frontend Changes Needed

### Files to Update:
1. `resources/js/Pages/Inventory/StockItems/Create.vue`
2. `resources/js/Pages/Inventory/StockItems/Create_updated.vue`

### Changes Required in Both Files:

#### 1. Add Edit/Delete Buttons to Category Dropdown (around line 54-78)
Replace the category select section with:
```vue
<div>
    <div class="flex items-center justify-between mb-1">
        <label class="block text-sm font-medium text-gray-700">
            Filter by Category
        </label>
        <div class="flex gap-2">
            <button
                v-if="selectedCategory"
                type="button"
                @click="editCategory"
                class="text-xs text-blue-600 hover:text-blue-700 font-medium"
                title="Edit Category"
            >
                Edit
            </button>
            <button
                v-if="selectedCategory"
                type="button"
                @click="deleteCategory"
                class="text-xs text-red-600 hover:text-red-700 font-medium"
                title="Delete Category"
            >
                Delete
            </button>
            <button
                type="button"
                @click="showNewCategoryModal = true"
                class="text-xs text-primary-600 hover:text-primary-700 font-medium flex items-center"
            >
                <svg class="w-3 h-3 mr-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                </svg>
                New
            </button>
        </div>
    </div>
    <select
        v-model="selectedCategory"
        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
        @change="handleCategoryChange"
    >
        <option value="">All Categories</option>
        <option v-for="category in localCategories" :key="category.id" :value="category.id">
            {{ category.name }}
        </option>
    </select>
</div>
```

#### 2. Add Edit/Delete Buttons to Subcategory Dropdown (around line 80-108)
Similar pattern for subcategories.

#### 3. Add Edit Category Modal (after line 469)
```vue
<!-- Edit Category Modal -->
<Modal :show="showEditCategoryModal" @close="showEditCategoryModal = false" max-width="md">
    <div class="p-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">Edit Category</h3>
        
        <div v-if="editCategoryError" class="mb-4 p-3 bg-red-50 border border-red-200 rounded-md">
            <p class="text-sm text-red-600">{{ editCategoryError }}</p>
        </div>

        <form @submit.prevent="submitEditCategory" class="space-y-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Category Name *</label>
                <input v-model="editCategoryForm.name" type="text" required 
                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"/>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                <textarea v-model="editCategoryForm.description" rows="2" 
                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"></textarea>
            </div>

            <div class="flex justify-end gap-3 pt-4">
                <button type="button" @click="showEditCategoryModal = false" 
                    class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50">
                    Cancel
                </button>
                <button type="submit" :disabled="editCategoryLoading" 
                    class="px-4 py-2 text-sm font-medium text-white bg-primary-600 rounded-md hover:bg-primary-700 disabled:opacity-50">
                    {{ editCategoryLoading ? 'Updating...' : 'Update Category' }}
                </button>
            </div>
        </form>
    </div>
</Modal>
```

#### 4. Add Edit Subcategory Modal
Similar to edit category modal.

#### 5. Add Reactive State (around line 530-546)
```javascript
// Edit category refs
const showEditCategoryModal = ref(false);
const editCategoryLoading = ref(false);
const editCategoryError = ref('');
const editCategoryForm = ref({ id: null, name: '', description: '' });

// Edit subcategory refs
const showEditSubcategoryModal = ref(false);
const editSubcategoryLoading = ref(false);
const editSubcategoryError = ref('');
const editSubcategoryForm = ref({ id: null, name: '', description: '' });
```

#### 6. Add Methods (after line 811)
```javascript
// Edit Category
const editCategory = () => {
    const category = localCategories.value.find(c => c.id === selectedCategory.value);
    if (category) {
        editCategoryForm.value = {
            id: category.id,
            name: category.name,
            description: category.description || ''
        };
        showEditCategoryModal.value = true;
        editCategoryError.value = '';
    }
};

const submitEditCategory = async () => {
    editCategoryLoading.value = true;
    editCategoryError.value = '';

    try {
        const response = await axios.put(
            route('api.categories.update', editCategoryForm.value.id),
            {
                name: editCategoryForm.value.name,
                description: editCategoryForm.value.description
            }
        );

        if (response.data.success) {
            // Update local categories
            const index = localCategories.value.findIndex(c => c.id === editCategoryForm.value.id);
            if (index !== -1) {
                localCategories.value[index] = response.data.category;
            }
            showEditCategoryModal.value = false;
        }
    } catch (error) {
        editCategoryError.value = error.response?.data?.message || 'Failed to update category';
    } finally {
        editCategoryLoading.value = false;
    }
};

// Delete Category
const deleteCategory = async () => {
    const category = localCategories.value.find(c => c.id === selectedCategory.value);
    if (!category) return;

    if (!confirm(`Are you sure you want to delete the category "${category.name}"?`)) {
        return;
    }

    try {
        const response = await axios.delete(route('api.categories.delete', category.id));

        if (response.data.success) {
            // Remove from local categories
            localCategories.value = localCategories.value.filter(c => c.id !== category.id);
            selectedCategory.value = '';
            selectedSubcategory.value = '';
        }
    } catch (error) {
        alert(error.response?.data?.message || 'Failed to delete category');
    }
};

// Similar methods for subcategories...
```

## 📝 Summary

**Backend (✅ Complete):**
- Models updated with slug regeneration
- 4 new controller methods (update/delete for categories and subcategories)
- 4 new routes added
- Safety checks prevent deletion of categories/subcategories with associated products

**Frontend (⏳ Needs Implementation):**
- Add Edit/Delete buttons next to New buttons
- Add Edit modals for categories and subcategories
- Add reactive state for edit forms
- Add methods for edit/delete operations
- Add confirmation dialogs for deletions
- Update local state after operations

All backend APIs are ready and tested. Frontend just needs UI components and method calls.

