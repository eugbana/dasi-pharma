<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Stock Items</h1>
                <p class="mt-1 text-sm text-gray-500">
                    Manage inventory batches with FEFO tracking
                </p>
            </div>
            <div class="flex-shrink-0">
                <Button @click="$inertia.visit(route('stock-items.create'))">
                    <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Add Stock Item
                </Button>
            </div>
        </div>

        <!-- Filters -->
        <div class="mb-6 bg-white rounded-lg shadow p-4">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <!-- Search -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
                    <input
                        v-model="filters.search"
                        type="text"
                        placeholder="Drug name or batch..."
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @input="applyFilters"
                    />
                </div>

                <!-- Expiry Status -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Expiry Status</label>
                    <select
                        v-model="filters.expiry_status"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @change="applyFilters"
                    >
                        <option value="">All</option>
                        <option value="expired">Expired</option>
                        <option value="expiring_soon">Expiring Soon (30 days)</option>
                        <option value="valid">Valid (>30 days)</option>
                    </select>
                </div>

                <!-- Stock Status -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Stock Status</label>
                    <select
                        v-model="filters.stock_status"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @change="applyFilters"
                    >
                        <option value="">All</option>
                        <option value="low">Low Stock</option>
                        <option value="out">Out of Stock</option>
                        <option value="available">Available</option>
                    </select>
                </div>

                <!-- Clear Filters -->
                <div class="flex items-end">
                    <Button variant="outline" @click="clearFilters" class="w-full">
                        Clear Filters
                    </Button>
                </div>
            </div>
        </div>

        <!-- Stock Items Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <Table>
                <template #header>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Drug Name
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Batch Number
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Expiry Date
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Quantity
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Price
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Status
                    </th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Actions
                    </th>
                </template>

                <template #body>
                    <tr v-for="item in stockItems.data" :key="item.id" class="hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm font-medium text-gray-900">{{ item.drug.brand_name }}</div>
                            <div class="text-sm text-gray-500">{{ item.drug.generic_name }} {{ item.drug.strength }}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            {{ item.batch_number }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900">{{ formatDate(item.expiry_date) }}</div>
                            <div class="text-xs" :class="getExpiryColorClass(item.expiry_date)">
                                {{ getDaysUntilExpiry(item.expiry_date) }}
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900">{{ item.quantity_available }}</div>
                            <div v-if="item.reorder_point" class="text-xs text-gray-500">
                                Reorder: {{ item.reorder_point }}
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900">₦{{ formatNumber(item.selling_price) }}</div>
                            <div class="text-xs text-gray-500">Cost: ₦{{ formatNumber(item.purchase_price) }}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <Badge :variant="getStockStatusVariant(item)">
                                {{ getStockStatusLabel(item) }}
                            </Badge>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                            <div class="flex items-center justify-end gap-2">
                                <BarcodeLabelPrint :stock-item-id="item.id" />
                                <button
                                    @click="viewItem(item.id)"
                                    class="text-primary-600 hover:text-primary-900"
                                >
                                    View
                                </button>
                                <button
                                    @click="editItem(item.id)"
                                    class="text-secondary-600 hover:text-secondary-900"
                                >
                                    Edit
                                </button>
                            </div>
                        </td>
                    </tr>
                </template>

                <template #empty>
                    <div class="text-center py-12">
                        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                        </svg>
                        <h3 class="mt-2 text-sm font-medium text-gray-900">No stock items</h3>
                        <p class="mt-1 text-sm text-gray-500">Get started by adding a new stock item.</p>
                    </div>
                </template>
            </Table>

            <!-- Pagination -->
            <div v-if="stockItems.data.length > 0" class="px-6 py-4 border-t border-gray-200">
                <div class="flex items-center justify-between">
                    <div class="text-sm text-gray-700">
                        Showing {{ stockItems.from }} to {{ stockItems.to }} of {{ stockItems.total }} results
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { ref, reactive } from 'vue';
import { router } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';
import Table from '@/Components/Table.vue';
import Badge from '@/Components/Badge.vue';
import BarcodeLabelPrint from '@/Components/BarcodeLabelPrint.vue';

const props = defineProps({
    stockItems: Object,
    filters: Object,
});

const filters = reactive({
    search: props.filters?.search || '',
    expiry_status: props.filters?.expiry_status || '',
    stock_status: props.filters?.stock_status || '',
});

const applyFilters = () => {
    router.get(route('stock-items.index'), filters, {
        preserveState: true,
        preserveScroll: true,
    });
};

const clearFilters = () => {
    filters.search = '';
    filters.expiry_status = '';
    filters.stock_status = '';
    applyFilters();
};

const viewItem = (id) => {
    router.visit(route('stock-items.show', id));
};

const editItem = (id) => {
    router.visit(route('stock-items.edit', id));
};

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-NG', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
    });
};

const formatNumber = (number) => {
    return new Intl.NumberFormat('en-NG', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    }).format(number);
};

const getDaysUntilExpiry = (expiryDate) => {
    const today = new Date();
    const expiry = new Date(expiryDate);
    const diffTime = expiry - today;
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    if (diffDays < 0) {
        return `Expired ${Math.abs(diffDays)} days ago`;
    } else if (diffDays === 0) {
        return 'Expires today';
    } else if (diffDays === 1) {
        return 'Expires tomorrow';
    } else {
        return `${diffDays} days remaining`;
    }
};

const getExpiryColorClass = (expiryDate) => {
    const today = new Date();
    const expiry = new Date(expiryDate);
    const diffTime = expiry - today;
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    if (diffDays < 0) return 'text-danger-600 font-medium';
    if (diffDays <= 7) return 'text-danger-600';
    if (diffDays <= 30) return 'text-warning-600';
    return 'text-gray-500';
};

const getStockStatusVariant = (item) => {
    if (item.quantity_available <= 0) return 'danger';
    if (item.quantity_available <= item.reorder_point) return 'warning';
    return 'success';
};

const getStockStatusLabel = (item) => {
    if (item.quantity_available <= 0) return 'Out of Stock';
    if (item.quantity_available <= item.reorder_point) return 'Low Stock';
    return 'In Stock';
};
</script>


