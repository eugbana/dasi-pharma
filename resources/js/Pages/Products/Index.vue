<template>
    <AppLayout title="Products">
        <template #header>
            <div class="flex items-center justify-between">
                <h2 class="text-xl font-semibold text-gray-800">Products / Drugs</h2>
                <Link :href="route('products.create')" class="btn btn-primary">
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    Add Product
                </Link>
            </div>
        </template>

        <div class="py-6">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Flash Messages -->
                <div v-if="$page.props.flash?.success" class="mb-4 p-4 bg-green-100 border border-green-400 text-green-700 rounded">
                    {{ $page.props.flash.success }}
                </div>
                <div v-if="$page.props.flash?.error" class="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded">
                    {{ $page.props.flash.error }}
                </div>

                <!-- Filters -->
                <div class="bg-white rounded-lg shadow p-4 mb-6">
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
                            <input v-model="filters.search" type="text" placeholder="Search products..."
                                class="w-full rounded-lg border-gray-400 focus:border-primary-500 focus:ring-primary-500"
                                @input="debouncedSearch" />
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                            <select v-model="filters.category_id" @change="applyFilters"
                                class="w-full rounded-lg border-gray-400 focus:border-primary-500 focus:ring-primary-500">
                                <option value="">All Categories</option>
                                <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Prescription Type</label>
                            <select v-model="filters.prescription_only" @change="applyFilters"
                                class="w-full rounded-lg border-gray-400 focus:border-primary-500 focus:ring-primary-500">
                                <option value="">All Products</option>
                                <option value="yes">Prescription Only</option>
                                <option value="no">Over the Counter</option>
                            </select>
                        </div>
                        <div class="flex items-end">
                            <button @click="clearFilters" class="btn btn-secondary w-full">Clear Filters</button>
                        </div>
                    </div>
                </div>

                <!-- Products Table -->
                <div class="bg-white rounded-lg shadow overflow-hidden">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Product</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Category</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Barcode</th>
                                <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">Stock Items</th>
                                <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">Rx Only</th>
                                <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <tr v-for="drug in drugs.data" :key="drug.id" class="hover:bg-gray-50">
                                <td class="px-6 py-4">
                                    <div class="font-medium text-gray-900">{{ drug.brand_name }}</div>
                                    <div class="text-sm text-gray-500">{{ drug.generic_name }}</div>
                                    <div class="text-xs text-gray-400">{{ drug.strength }} {{ drug.dosage_form }}</div>
                                </td>
                                <td class="px-6 py-4 text-sm text-gray-500">
                                    {{ drug.category?.name || '-' }}
                                    <span v-if="drug.subcategory" class="text-xs block">{{ drug.subcategory.name }}</span>
                                </td>
                                <td class="px-6 py-4 text-sm text-gray-500 font-mono">{{ drug.barcode || '-' }}</td>
                                <td class="px-6 py-4 text-center">
                                    <span class="px-2 py-1 text-xs font-medium rounded-full"
                                        :class="drug.stock_items_count > 0 ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-600'">
                                        {{ drug.stock_items_count }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <span v-if="drug.is_prescription_only" class="px-2 py-1 text-xs font-medium bg-red-100 text-red-800 rounded-full">Rx</span>
                                    <span v-else class="text-gray-400">-</span>
                                </td>
                                <td class="px-6 py-4 text-right space-x-2">
                                    <Link :href="route('products.show', drug.id)" class="text-primary-600 hover:text-primary-900">View</Link>
                                    <Link :href="route('products.edit', drug.id)" class="text-yellow-600 hover:text-yellow-900">Edit</Link>
                                    <button @click="confirmDelete(drug)" class="text-red-600 hover:text-red-900">Delete</button>
                                </td>
                            </tr>
                            <tr v-if="drugs.data.length === 0">
                                <td colspan="6" class="px-6 py-12 text-center text-gray-500">No products found.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <Pagination :links="drugs.links" class="mt-6" />
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <Modal :show="showDeleteModal" @close="showDeleteModal = false">
            <div class="p-6">
                <h3 class="text-lg font-medium text-gray-900">Delete Product</h3>
                <p class="mt-2 text-sm text-gray-500">Are you sure you want to delete "{{ productToDelete?.brand_name }}"? This action cannot be undone.</p>
                <div class="mt-6 flex justify-end space-x-3">
                    <button @click="showDeleteModal = false" class="btn btn-secondary">Cancel</button>
                    <button @click="deleteProduct" class="btn btn-danger">Delete</button>
                </div>
            </div>
        </Modal>
    </AppLayout>
</template>

<script setup>
import { ref, reactive } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Pagination from '@/Components/Pagination.vue';
import Modal from '@/Components/Modal.vue';
import debounce from 'lodash/debounce';

const props = defineProps({
    drugs: Object,
    categories: Array,
    filters: Object,
});

const filters = reactive({ ...props.filters });
const showDeleteModal = ref(false);
const productToDelete = ref(null);

const applyFilters = () => {
    router.get(route('products.index'), filters, { preserveState: true, replace: true });
};

const debouncedSearch = debounce(applyFilters, 300);

const clearFilters = () => {
    Object.keys(filters).forEach(key => filters[key] = '');
    applyFilters();
};

const confirmDelete = (product) => {
    productToDelete.value = product;
    showDeleteModal.value = true;
};

const deleteProduct = () => {
    router.delete(route('products.destroy', productToDelete.value.id), {
        onSuccess: () => { showDeleteModal.value = false; productToDelete.value = null; }
    });
};
</script>

