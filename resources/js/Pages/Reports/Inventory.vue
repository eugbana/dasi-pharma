<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Inventory Report</h1>
            <p class="mt-1 text-sm text-gray-500">
                Monitor stock levels, expiry, and valuation
            </p>
        </div>

        <!-- Filters and Export -->
        <div class="bg-white rounded-lg shadow p-4 mb-6">
            <div class="grid grid-cols-1 md:grid-cols-5 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Period</label>
                    <select
                        v-model="localFilters.period"
                        @change="handlePeriodChange"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    >
                        <option value="today">Today</option>
                        <option value="week">This Week</option>
                        <option value="month">This Month</option>
                        <option value="year">This Year</option>
                        <option value="custom">Custom Range</option>
                    </select>
                </div>

                <div v-if="localFilters.period === 'custom'">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Start Date</label>
                    <input
                        v-model="localFilters.start_date"
                        type="date"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    />
                </div>

                <div v-if="localFilters.period === 'custom'">
                    <label class="block text-sm font-medium text-gray-700 mb-1">End Date</label>
                    <input
                        v-model="localFilters.end_date"
                        type="date"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    />
                </div>

                <div class="flex items-end" v-if="localFilters.period === 'custom'">
                    <Button @click="applyFilters" class="w-full">
                        Apply Filter
                    </Button>
                </div>

                <div class="flex items-end">
                    <Button @click="exportReport" variant="outline" class="w-full">
                        <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                        </svg>
                        Export CSV
                    </Button>
                </div>
            </div>
        </div>

        <!-- Summary Cards -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-primary-100 rounded-md p-3">
                        <svg class="h-6 w-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-500">Total Stock Items</p>
                        <p class="text-2xl font-semibold text-gray-900">{{ stockValue?.total_items || 0 }}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-green-100 rounded-md p-3">
                        <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-500">Total Value</p>
                        <p class="text-2xl font-semibold text-gray-900">₦{{ formatNumber(stockValue?.selling_value || 0) }}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-yellow-100 rounded-md p-3">
                        <svg class="h-6 w-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-500">Low Stock</p>
                        <p class="text-2xl font-semibold text-gray-900">{{ stockStatus?.low_stock || 0 }}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-red-100 rounded-md p-3">
                        <svg class="h-6 w-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-500">Expiring Soon</p>
                        <p class="text-2xl font-semibold text-gray-900">{{ stockStatus?.expiring_soon || 0 }}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Low Stock Items -->
        <div class="bg-white rounded-lg shadow mb-6">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-lg font-semibold text-gray-900">Low Stock Items</h2>
            </div>
            <div class="p-6">
                <div v-if="!lowStockItems || lowStockItems.length === 0" class="text-center py-8 text-gray-500">
                    No low stock items
                </div>
                <div v-else class="space-y-3">
                    <div
                        v-for="item in lowStockItems"
                        :key="item.id"
                        class="flex items-center justify-between p-3 border border-gray-200 rounded-lg"
                    >
                        <div>
                            <p class="text-sm font-medium text-gray-900">{{ item.drug_name }}</p>
                            <p class="text-xs text-gray-500">{{ item.strength }} - {{ item.dosage_form }}</p>
                            <p class="text-xs text-gray-500">Batch: {{ item.batch_number }}</p>
                        </div>
                        <div class="text-right">
                            <p class="text-sm font-semibold text-yellow-600">{{ item.quantity_available }}</p>
                            <p class="text-xs text-gray-500">Min: {{ item.minimum_stock_level }}</p>
                            <p class="text-xs text-gray-500">Reorder: {{ item.reorder_point }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Stock Movements Summary -->
        <div class="bg-white rounded-lg shadow">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-lg font-semibold text-gray-900">Stock Movements (Last 30 Days)</h2>
            </div>
            <div class="p-6">
                <div v-if="!movementsSummary || movementsSummary.length === 0" class="text-center py-8 text-gray-500">
                    No recent movements
                </div>
                <div v-else class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div
                        v-for="movement in movementsSummary"
                        :key="movement.movement_type"
                        class="border border-gray-200 rounded-lg p-4"
                    >
                        <p class="text-sm text-gray-500 capitalize">{{ movement.movement_type }}</p>
                        <p class="text-xl font-semibold text-gray-900">{{ movement.total_quantity }}</p>
                        <p class="text-xs text-gray-500">{{ movement.count }} transactions</p>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { reactive } from 'vue';
import { router } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';

const props = defineProps({
    stockValue: Object,
    stockStatus: Object,
    movementsSummary: Array,
    lowStockItems: Array,
    filters: {
        type: Object,
        default: () => ({
            period: 'month',
            start_date: null,
            end_date: null,
        }),
    },
});

const localFilters = reactive({
    period: props.filters?.period || 'month',
    start_date: props.filters?.start_date || null,
    end_date: props.filters?.end_date || null,
});

const formatNumber = (value) => {
    return parseFloat(value).toLocaleString('en-NG', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    });
};

const handlePeriodChange = () => {
    if (localFilters.period !== 'custom') {
        applyFilters();
    }
};

const applyFilters = () => {
    router.get(route('reports.inventory'), localFilters, {
        preserveState: true,
        preserveScroll: true,
    });
};

const exportReport = () => {
    const params = {
        period: localFilters.period,
    };

    if (localFilters.period === 'custom') {
        if (localFilters.start_date) {
            params.start_date = localFilters.start_date;
        }
        if (localFilters.end_date) {
            params.end_date = localFilters.end_date;
        }
    }

    window.location.href = route('reports.inventory.export', params);
};
</script>

