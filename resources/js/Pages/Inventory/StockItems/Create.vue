<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Add Stock Item</h1>
            <p class="mt-1 text-sm text-gray-500">
                Add a new batch of product to inventory
            </p>
        </div>

        <!-- Form -->
        <div class="bg-white rounded-lg shadow p-6 max-w-3xl">
            <form @submit.prevent="submit">
                <div class="space-y-6">
                    <!-- Barcode Scanner Input -->
                    <div class="p-4 bg-blue-50 rounded-lg border border-blue-200">
                        <label class="block text-sm font-medium text-blue-900 mb-2">
                            <svg class="inline w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z"/>
                            </svg>
                            Barcode (Scan or Enter)
                        </label>
                        <div class="flex gap-2">
                            <input
                                ref="barcodeInput"
                                v-model="barcodeSearch"
                                type="text"
                                class="flex-1 rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                placeholder="Scan barcode or enter manually..."
                                @keydown.enter.prevent="lookupBarcode"
                            />
                            <button
                                type="button"
                                @click="lookupBarcode"
                                class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
                                :disabled="!barcodeSearch || barcodeLoading"
                            >
                                <span v-if="barcodeLoading" class="flex items-center">
                                    <svg class="animate-spin h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24">
                                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path>
                                    </svg>
                                </span>
                                <span v-else>Lookup</span>
                            </button>
                        </div>
                        <p v-if="barcodeError" class="mt-2 text-sm text-red-600">{{ barcodeError }}</p>
                        <p v-if="barcodeSuccess" class="mt-2 text-sm text-green-600">{{ barcodeSuccess }}</p>
                    </div>

                    <!-- Category Filters -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 p-4 bg-gray-50 rounded-lg">
                        <div>
                            <div class="flex items-center justify-between mb-1">
                                <label class="block text-sm font-medium text-gray-700">
                                    Filter by Category
                                </label>
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
                        <div>
                            <div class="flex items-center justify-between mb-1">
                                <label class="block text-sm font-medium text-gray-700">
                                    Filter by Subcategory
                                </label>
                                <button
                                    type="button"
                                    @click="showNewSubcategoryModal = true"
                                    class="text-xs text-primary-600 hover:text-primary-700 font-medium flex items-center"
                                    :disabled="!selectedCategory"
                                    :class="{ 'opacity-50 cursor-not-allowed': !selectedCategory }"
                                >
                                    <svg class="w-3 h-3 mr-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                    </svg>
                                    New
                                </button>
                            </div>
                            <select
                                v-model="selectedSubcategory"
                                class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                :disabled="!selectedCategory"
                            >
                                <option value="">All Subcategories</option>
                                <option v-for="subcategory in filteredSubcategories" :key="subcategory.id" :value="subcategory.id">
                                    {{ subcategory.name }}
                                </option>
                            </select>
                        </div>
                    </div>

                    <!-- Drug Selection with Autocomplete -->
                    <div>
                        <div class="flex items-center justify-between mb-2">
                            <label class="block text-sm font-medium text-gray-700">
                                Product/Drug <span class="text-danger-500">*</span>
                            </label>
                            <button
                                type="button"
                                @click="showNewDrugModal = true"
                                class="text-sm text-primary-600 hover:text-primary-700 font-medium flex items-center"
                            >
                                <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                </svg>
                                Create New Product
                            </button>
                        </div>
                        <ProductAutocomplete
                            v-model="productSearch"
                            placeholder="Search by product name, category, or barcode..."
                            @select="handleProductSelect"
                        />
                        <p v-if="selectedProduct" class="mt-2 text-sm text-gray-600">
                            Selected: <strong>{{ selectedProduct.brand_name }}</strong>
                            <span v-if="selectedProduct.category"> - {{ selectedProduct.category }}</span>
                            <span v-if="selectedProduct.subcategory"> › {{ selectedProduct.subcategory }}</span>
                            <button type="button" @click="clearSelectedProduct" class="ml-2 text-red-600 hover:text-red-700">
                                <svg class="inline w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                                </svg>
                            </button>
                        </p>
                        <p v-if="form.errors.drug_id" class="mt-1 text-sm text-danger-600">
                            {{ form.errors.drug_id }}
                        </p>
                    </div>

                    <!-- Batch Number -->
                    <Input
                        v-model="form.batch_number"
                        label="Batch Number"
                        type="text"
                        required
                        :error="form.errors.batch_number"
                        placeholder="e.g., BATCH-2024-001"
                    />

                    <!-- Dates -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <Input
                            v-model="form.manufacturing_date"
                            label="Manufacturing Date"
                            type="date"
                            :error="form.errors.manufacturing_date"
                        />

                        <Input
                            v-model="form.expiry_date"
                            label="Expiry Date"
                            type="date"
                            required
                            :error="form.errors.expiry_date"
                        />
                    </div>

                    <!-- Pricing with Markup Calculator -->
                    <div class="p-4 bg-green-50 rounded-lg border border-green-200">
                        <h3 class="text-sm font-medium text-green-900 mb-4">Pricing & Markup</h3>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">
                                    Purchase Price (₦) <span class="text-danger-500">*</span>
                                </label>
                                <input
                                    v-model="form.purchase_price"
                                    type="number"
                                    step="0.01"
                                    min="0"
                                    required
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                    :class="{ 'border-red-500': form.errors.purchase_price }"
                                    placeholder="0.00"
                                    @input="calculateSellingPrice"
                                />
                                <p v-if="form.errors.purchase_price" class="mt-1 text-xs text-danger-600">
                                    {{ form.errors.purchase_price }}
                                </p>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">
                                    Markup %
                                    <span class="text-xs text-gray-500">(calculates selling price)</span>
                                </label>
                                <input
                                    v-model="markupInput"
                                    type="number"
                                    step="0.1"
                                    min="0"
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                    placeholder="e.g., 25"
                                    @input="calculateSellingPrice"
                                />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">
                                    Selling Price (₦) <span class="text-danger-500">*</span>
                                </label>
                                <input
                                    v-model="form.selling_price"
                                    type="number"
                                    step="0.01"
                                    min="0"
                                    required
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                    :class="{ 'border-red-500': form.errors.selling_price }"
                                    placeholder="0.00"
                                    @input="updateMarkupFromPrice"
                                />
                                <p v-if="form.errors.selling_price" class="mt-1 text-xs text-danger-600">
                                    {{ form.errors.selling_price }}
                                </p>
                            </div>
                        </div>

                        <!-- Markup Summary -->
                        <div v-if="form.purchase_price && form.selling_price" class="mt-4 pt-3 border-t border-green-200">
                            <div class="flex items-center justify-between text-sm">
                                <span class="text-gray-700">Calculated Markup:</span>
                                <span :class="markupClass" class="font-bold text-lg">
                                    {{ calculatedMarkup }}%
                                </span>
                            </div>
                            <div class="flex items-center justify-between text-sm mt-1">
                                <span class="text-gray-700">Profit per unit:</span>
                                <span class="font-medium text-green-700">
                                    ₦{{ profitPerUnit }}
                                </span>
                            </div>
                        </div>

                        <!-- VAT Applicable Checkbox -->
                        <div class="mt-4 pt-3 border-t border-green-200">
                            <label class="flex items-center">
                                <input
                                    v-model="form.vat_applicable"
                                    type="checkbox"
                                    class="rounded border-gray-300 text-primary-600 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                />
                                <span class="ml-2 text-sm text-gray-700">VAT Applicable</span>
                            </label>
                            <p class="mt-1 text-xs text-gray-500">Check if VAT should be applied to this item at point of sale</p>
                        </div>
                    </div>

                    <!-- Quantities -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <Input
                            v-model="form.quantity_available"
                            label="Initial Quantity"
                            type="number"
                            min="1"
                            required
                            :error="form.errors.quantity_available"
                            placeholder="0"
                        />

                        <Input
                            v-model="form.minimum_stock_level"
                            label="Minimum Stock Level"
                            type="number"
                            min="0"
                            :error="form.errors.minimum_stock_level"
                            placeholder="0"
                        />

                        <Input
                            v-model="form.reorder_point"
                            label="Reorder Point"
                            type="number"
                            min="0"
                            :error="form.errors.reorder_point"
                            placeholder="0"
                        />
                    </div>

                    <!-- Form Actions -->
                    <div class="flex items-center justify-end space-x-3 pt-6 border-t">
                        <Button
                            type="button"
                            variant="outline"
                            @click="$inertia.visit(route('stock-items.index'))"
                            :disabled="form.processing"
                        >
                            Cancel
                        </Button>
                        <Button
                            type="submit"
                            :disabled="form.processing"
                        >
                            <span v-if="!form.processing">Add Stock Item</span>
                            <span v-else class="flex items-center">
                                <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                </svg>
                                Adding...
                            </span>
                        </Button>
                    </div>
                </div>
            </form>
        </div>

        <!-- New Drug Modal -->
        <div v-if="showNewDrugModal" class="fixed inset-0 z-50 overflow-y-auto">
            <div class="flex items-center justify-center min-h-screen px-4">
                <div class="fixed inset-0 bg-gray-500 bg-opacity-75" @click="showNewDrugModal = false"></div>
                <div class="relative bg-white rounded-lg shadow-xl max-w-2xl w-full p-6">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-gray-900">Create New Product</h3>
                        <button type="button" @click="showNewDrugModal = false" class="text-gray-400 hover:text-gray-500">
                            <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                            </svg>
                        </button>
                    </div>

                    <form @submit.prevent="submitNewDrug" class="space-y-4">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Brand Name *</label>
                                <input v-model="newDrug.brand_name" type="text" required class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"/>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Generic Name</label>
                                <input v-model="newDrug.generic_name" type="text" class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"/>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Category *</label>
                                <select v-model="newDrug.category_id" required class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500" @change="onNewDrugCategoryChange">
                                    <option value="">Select Category</option>
                                    <option v-for="cat in localCategories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Subcategory</label>
                                <select v-model="newDrug.subcategory_id" class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500" :disabled="!newDrug.category_id">
                                    <option value="">Select Subcategory</option>
                                    <option v-for="sub in newDrugSubcategories" :key="sub.id" :value="sub.id">{{ sub.name }}</option>
                                </select>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Strength</label>
                                <input v-model="newDrug.strength" type="text" placeholder="e.g., 500mg" class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"/>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Dosage Form</label>
                                <select v-model="newDrug.dosage_form" class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500">
                                    <option value="">Select Form</option>
                                    <option value="tablet">Tablet</option>
                                    <option value="capsule">Capsule</option>
                                    <option value="syrup">Syrup</option>
                                    <option value="injection">Injection</option>
                                    <option value="cream">Cream</option>
                                    <option value="ointment">Ointment</option>
                                    <option value="drops">Drops</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Barcode</label>
                                <input v-model="newDrug.barcode" type="text" placeholder="Enter or scan barcode" class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"/>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Manufacturer</label>
                                <input v-model="newDrug.manufacturer" type="text" class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"/>
                            </div>
                            <div class="flex items-center pt-6">
                                <input v-model="newDrug.is_prescription_only" type="checkbox" id="prescription_only" class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"/>
                                <label for="prescription_only" class="ml-2 text-sm text-gray-700">Prescription Only</label>
                            </div>
                        </div>

                        <p v-if="newDrugError" class="text-sm text-red-600">{{ newDrugError }}</p>

                        <div class="flex justify-end gap-3 pt-4 border-t">
                            <button type="button" @click="showNewDrugModal = false" class="px-4 py-2 text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200">Cancel</button>
                            <button type="submit" :disabled="newDrugLoading" class="px-4 py-2 bg-primary-600 text-white rounded-md hover:bg-primary-700 disabled:opacity-50">
                                <span v-if="newDrugLoading">Creating...</span>
                                <span v-else>Create Product</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- New Category Modal -->
        <div v-if="showNewCategoryModal" class="fixed inset-0 z-50 overflow-y-auto">
            <div class="flex items-center justify-center min-h-screen px-4">
                <div class="fixed inset-0 bg-gray-500 bg-opacity-75" @click="showNewCategoryModal = false"></div>
                <div class="relative bg-white rounded-lg shadow-xl max-w-md w-full p-6">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-gray-900">Create New Category</h3>
                        <button type="button" @click="showNewCategoryModal = false" class="text-gray-400 hover:text-gray-500">
                            <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                            </svg>
                        </button>
                    </div>

                    <form @submit.prevent="submitNewCategory" class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Category Name *</label>
                            <input v-model="newCategory.name" type="text" required class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500" placeholder="e.g., Pharmaceuticals"/>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                            <textarea v-model="newCategory.description" rows="2" class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500" placeholder="Optional description"></textarea>
                        </div>

                        <p v-if="newCategoryError" class="text-sm text-red-600">{{ newCategoryError }}</p>

                        <div class="flex justify-end gap-3 pt-4 border-t">
                            <button type="button" @click="showNewCategoryModal = false" class="px-4 py-2 text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200">Cancel</button>
                            <button type="submit" :disabled="newCategoryLoading" class="px-4 py-2 bg-primary-600 text-white rounded-md hover:bg-primary-700 disabled:opacity-50">
                                <span v-if="newCategoryLoading">Creating...</span>
                                <span v-else>Create Category</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- New Subcategory Modal -->
        <div v-if="showNewSubcategoryModal" class="fixed inset-0 z-50 overflow-y-auto">
            <div class="flex items-center justify-center min-h-screen px-4">
                <div class="fixed inset-0 bg-gray-500 bg-opacity-75" @click="showNewSubcategoryModal = false"></div>
                <div class="relative bg-white rounded-lg shadow-xl max-w-md w-full p-6">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-gray-900">Create New Subcategory</h3>
                        <button type="button" @click="showNewSubcategoryModal = false" class="text-gray-400 hover:text-gray-500">
                            <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                            </svg>
                        </button>
                    </div>

                    <form @submit.prevent="submitNewSubcategory" class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Parent Category</label>
                            <input type="text" :value="selectedCategoryName" disabled class="w-full rounded-md border-gray-300 bg-gray-100 shadow-sm"/>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Subcategory Name *</label>
                            <input v-model="newSubcategory.name" type="text" required class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500" placeholder="e.g., Antibiotics"/>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                            <textarea v-model="newSubcategory.description" rows="2" class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500" placeholder="Optional description"></textarea>
                        </div>

                        <p v-if="newSubcategoryError" class="text-sm text-red-600">{{ newSubcategoryError }}</p>

                        <div class="flex justify-end gap-3 pt-4 border-t">
                            <button type="button" @click="showNewSubcategoryModal = false" class="px-4 py-2 text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200">Cancel</button>
                            <button type="submit" :disabled="newSubcategoryLoading" class="px-4 py-2 bg-primary-600 text-white rounded-md hover:bg-primary-700 disabled:opacity-50">
                                <span v-if="newSubcategoryLoading">Creating...</span>
                                <span v-else>Create Subcategory</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useForm, router } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';
import Input from '@/Components/Input.vue';
import ProductAutocomplete from '@/Components/ProductAutocomplete.vue';

const props = defineProps({
    drugs: Array,
    categories: Array,
});

// Refs
const barcodeInput = ref(null);
const productSearch = ref('');
const selectedProduct = ref(null);
const selectedCategory = ref('');
const selectedSubcategory = ref('');
const barcodeSearch = ref('');
const barcodeLoading = ref(false);
const barcodeError = ref('');
const barcodeSuccess = ref('');
const markupInput = ref('');
const showNewDrugModal = ref(false);
const newDrugLoading = ref(false);
const newDrugError = ref('');

// Category/Subcategory creation refs
const localCategories = ref([]);
const showNewCategoryModal = ref(false);
const newCategoryLoading = ref(false);
const newCategoryError = ref('');
const newCategory = ref({ name: '', description: '' });

const showNewSubcategoryModal = ref(false);
const newSubcategoryLoading = ref(false);
const newSubcategoryError = ref('');
const newSubcategory = ref({ name: '', description: '' });

const newDrug = ref({
    brand_name: '',
    generic_name: '',
    category_id: '',
    subcategory_id: '',
    strength: '',
    dosage_form: '',
    barcode: '',
    manufacturer: '',
    is_prescription_only: false,
});

const form = useForm({
    drug_id: '',
    batch_number: '',
    manufacturing_date: '',
    expiry_date: '',
    purchase_price: '',
    selling_price: '',
    vat_applicable: false,
    quantity_available: '',
    minimum_stock_level: '',
    reorder_point: '',
});

// Initialize local categories and focus barcode input on mount
onMounted(() => {
    localCategories.value = [...(props.categories || [])];
    if (barcodeInput.value) {
        barcodeInput.value.focus();
    }
});

// Computed
const filteredSubcategories = computed(() => {
    if (!selectedCategory.value || !localCategories.value) return [];
    const category = localCategories.value.find(c => c.id === selectedCategory.value);
    return category ? category.subcategories : [];
});

const newDrugSubcategories = computed(() => {
    if (!newDrug.value.category_id || !localCategories.value) return [];
    const category = localCategories.value.find(c => c.id === parseInt(newDrug.value.category_id));
    return category ? category.subcategories : [];
});

const selectedCategoryName = computed(() => {
    if (!selectedCategory.value || !localCategories.value) return '';
    const category = localCategories.value.find(c => c.id === selectedCategory.value);
    return category ? category.name : '';
});

const calculatedMarkup = computed(() => {
    if (!form.purchase_price || !form.selling_price) return '0.00';
    const purchase = parseFloat(form.purchase_price);
    const selling = parseFloat(form.selling_price);
    if (purchase === 0) return '0.00';
    return (((selling - purchase) / purchase) * 100).toFixed(2);
});

const profitPerUnit = computed(() => {
    if (!form.purchase_price || !form.selling_price) return '0.00';
    const purchase = parseFloat(form.purchase_price);
    const selling = parseFloat(form.selling_price);
    return (selling - purchase).toFixed(2);
});

const markupClass = computed(() => {
    const markup = parseFloat(calculatedMarkup.value);
    if (markup < 0) return 'text-danger-600';
    if (markup < 10) return 'text-warning-600';
    return 'text-success-600';
});

// Methods
const handleCategoryChange = () => {
    selectedSubcategory.value = '';
};

const onNewDrugCategoryChange = () => {
    newDrug.value.subcategory_id = '';
};

const lookupBarcode = async () => {
    if (!barcodeSearch.value) return;

    barcodeLoading.value = true;
    barcodeError.value = '';
    barcodeSuccess.value = '';

    try {
        const response = await fetch(`/api/barcode/lookup?barcode=${encodeURIComponent(barcodeSearch.value)}`);
        const data = await response.json();

        if (data.found && data.drug) {
            handleProductSelect(data.drug);
            barcodeSuccess.value = `Found: ${data.drug.brand_name}`;
            barcodeSearch.value = '';
        } else {
            barcodeError.value = 'Product not found. You can create a new product with this barcode.';
            newDrug.value.barcode = barcodeSearch.value;
        }
    } catch (error) {
        barcodeError.value = 'Error looking up barcode. Please try again.';
    } finally {
        barcodeLoading.value = false;
    }
};

const calculateSellingPrice = () => {
    if (form.purchase_price && markupInput.value) {
        const purchase = parseFloat(form.purchase_price);
        const markup = parseFloat(markupInput.value);
        form.selling_price = (purchase * (1 + markup / 100)).toFixed(2);
    }
};

const updateMarkupFromPrice = () => {
    if (form.purchase_price && form.selling_price) {
        const purchase = parseFloat(form.purchase_price);
        const selling = parseFloat(form.selling_price);
        if (purchase > 0) {
            markupInput.value = (((selling - purchase) / purchase) * 100).toFixed(1);
        }
    }
};

const handleProductSelect = (product) => {
    selectedProduct.value = product;
    form.drug_id = product.id;
    productSearch.value = '';

    if (product.selling_price) {
        form.selling_price = product.selling_price;
    }
};

const clearSelectedProduct = () => {
    selectedProduct.value = null;
    form.drug_id = '';
};

const submitNewDrug = async () => {
    newDrugLoading.value = true;
    newDrugError.value = '';

    try {
        const response = await fetch('/api/drugs', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '',
            },
            body: JSON.stringify(newDrug.value),
        });

        const data = await response.json();

        if (response.ok && data.drug) {
            handleProductSelect(data.drug);
            showNewDrugModal.value = false;
            resetNewDrugForm();
        } else {
            newDrugError.value = data.message || 'Failed to create product';
        }
    } catch (error) {
        newDrugError.value = 'An error occurred. Please try again.';
    } finally {
        newDrugLoading.value = false;
    }
};

const resetNewDrugForm = () => {
    newDrug.value = {
        brand_name: '',
        generic_name: '',
        category_id: '',
        subcategory_id: '',
        strength: '',
        dosage_form: '',
        barcode: '',
        manufacturer: '',
        is_prescription_only: false,
    };
};

const submitNewCategory = async () => {
    newCategoryLoading.value = true;
    newCategoryError.value = '';

    try {
        const response = await fetch('/api/categories', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '',
            },
            body: JSON.stringify(newCategory.value),
        });

        const data = await response.json();

        if (response.ok && data.category) {
            // Add to local categories
            localCategories.value.push(data.category);
            // Select the new category
            selectedCategory.value = data.category.id;
            selectedSubcategory.value = '';
            // Close modal and reset form
            showNewCategoryModal.value = false;
            newCategory.value = { name: '', description: '' };
        } else {
            newCategoryError.value = data.message || 'Failed to create category';
        }
    } catch (error) {
        newCategoryError.value = 'An error occurred. Please try again.';
    } finally {
        newCategoryLoading.value = false;
    }
};

const submitNewSubcategory = async () => {
    if (!selectedCategory.value) {
        newSubcategoryError.value = 'Please select a category first';
        return;
    }

    newSubcategoryLoading.value = true;
    newSubcategoryError.value = '';

    try {
        const response = await fetch('/api/subcategories', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '',
            },
            body: JSON.stringify({
                ...newSubcategory.value,
                category_id: selectedCategory.value,
            }),
        });

        const data = await response.json();

        if (response.ok && data.subcategory) {
            // Add to local categories' subcategories
            const categoryIndex = localCategories.value.findIndex(c => c.id === selectedCategory.value);
            if (categoryIndex !== -1) {
                if (!localCategories.value[categoryIndex].subcategories) {
                    localCategories.value[categoryIndex].subcategories = [];
                }
                localCategories.value[categoryIndex].subcategories.push(data.subcategory);
            }
            // Select the new subcategory
            selectedSubcategory.value = data.subcategory.id;
            // Close modal and reset form
            showNewSubcategoryModal.value = false;
            newSubcategory.value = { name: '', description: '' };
        } else {
            newSubcategoryError.value = data.message || 'Failed to create subcategory';
        }
    } catch (error) {
        newSubcategoryError.value = 'An error occurred. Please try again.';
    } finally {
        newSubcategoryLoading.value = false;
    }
};

const submit = () => {
    form.post(route('stock-items.store'), {
        onSuccess: () => {
            // Redirect handled by controller
        },
    });
};
</script>


