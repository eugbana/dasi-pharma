<template>
    <AppLayout title="Product Details">
        <template #header>
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <Link :href="route('products.index')" class="text-gray-500 hover:text-gray-700 mr-4">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                        </svg>
                    </Link>
                    <h2 class="text-xl font-semibold text-gray-800">{{ product.brand_name }}</h2>
                </div>
                <Link :href="route('products.edit', product.id)" class="btn btn-primary">Edit Product</Link>
            </div>
        </template>

        <div class="py-6">
            <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Product Details Card -->
                <div class="bg-white rounded-lg shadow p-6 mb-6">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">Product Information</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Brand Name</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ product.brand_name }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Generic Name</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ product.generic_name || '-' }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Category</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ product.category?.name || '-' }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Subcategory</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ product.subcategory?.name || '-' }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Strength</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ product.strength || '-' }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Dosage Form</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ product.dosage_form || '-' }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Barcode</dt>
                            <dd class="mt-1 text-sm text-gray-900 font-mono">{{ product.barcode || '-' }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Manufacturer</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ product.manufacturer || '-' }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Prescription Only</dt>
                            <dd class="mt-1">
                                <span v-if="product.is_prescription_only" class="px-2 py-1 text-xs font-medium bg-red-100 text-red-800 rounded-full">Yes (Rx)</span>
                                <span v-else class="px-2 py-1 text-xs font-medium bg-green-100 text-green-800 rounded-full">No (OTC)</span>
                            </dd>
                        </div>
                    </div>
                    <div v-if="product.description" class="mt-4">
                        <dt class="text-sm font-medium text-gray-500">Description</dt>
                        <dd class="mt-1 text-sm text-gray-900">{{ product.description }}</dd>
                    </div>
                </div>

                <!-- Stock Items -->
                <div class="bg-white rounded-lg shadow p-6">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">Available Stock ({{ product.stock_items?.length || 0 }})</h3>
                    <table v-if="product.stock_items?.length" class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Branch</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Batch</th>
                                <th class="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase">Qty</th>
                                <th class="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase">Price</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Expiry</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <tr v-for="item in product.stock_items" :key="item.id">
                                <td class="px-4 py-3 text-sm text-gray-900">{{ item.branch?.name || '-' }}</td>
                                <td class="px-4 py-3 text-sm text-gray-500 font-mono">{{ item.batch_number }}</td>
                                <td class="px-4 py-3 text-sm text-gray-900 text-right">{{ item.quantity_available }}</td>
                                <td class="px-4 py-3 text-sm text-gray-900 text-right">₦{{ formatNumber(item.selling_price) }}</td>
                                <td class="px-4 py-3 text-sm" :class="isExpiringSoon(item.expiry_date) ? 'text-red-600' : 'text-gray-500'">
                                    {{ formatDate(item.expiry_date) }}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <p v-else class="text-gray-500 text-center py-8">No stock available for this product.</p>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';

defineProps({ product: Object });

const formatNumber = (value) => parseFloat(value || 0).toLocaleString('en-NG', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
const formatDate = (date) => date ? new Date(date).toLocaleDateString('en-NG', { year: 'numeric', month: 'short', day: 'numeric' }) : '-';
const isExpiringSoon = (date) => {
    if (!date) return false;
    const expiry = new Date(date);
    const thirtyDays = new Date();
    thirtyDays.setDate(thirtyDays.getDate() + 30);
    return expiry <= thirtyDays;
};
</script>

