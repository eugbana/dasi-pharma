<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Sales Report</h1>
            <p class="mt-1 text-sm text-gray-500">
                Analyze sales performance and trends ({{ filters.start_date }} to {{ filters.end_date }})
            </p>
        </div>

        <!-- Filters -->
        <div class="mb-6 bg-white rounded-lg shadow p-4">
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

        <!-- Summary Cards Row 1 -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-primary-100 rounded-md p-3">
                        <svg class="h-6 w-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-500">Gross Sales</p>
                        <p class="text-2xl font-semibold text-gray-900">₦{{ formatNumber(summary.total_sales || 0) }}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-red-100 rounded-md p-3">
                        <svg class="h-6 w-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 15v-1a4 4 0 00-4-4H8m0 0l3 3m-3-3l3-3m9 14V5a2 2 0 00-2-2H6a2 2 0 00-2 2v16l4-2 4 2 4-2 4 2z" />
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-500">Returns ({{ summary.total_returns || 0 }})</p>
                        <p class="text-2xl font-semibold text-red-600">-₦{{ formatNumber(summary.total_refunded || 0) }}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-green-100 rounded-md p-3">
                        <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-500">Net Sales</p>
                        <p class="text-2xl font-semibold text-green-600">₦{{ formatNumber(summary.net_sales || 0) }}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-blue-100 rounded-md p-3">
                        <svg class="h-6 w-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-500">Transactions</p>
                        <p class="text-2xl font-semibold text-gray-900">{{ summary.total_transactions || 0 }}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Summary Cards Row 2 -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-yellow-100 rounded-md p-3">
                        <svg class="h-6 w-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-500">Items Sold</p>
                        <p class="text-2xl font-semibold text-gray-900">{{ summary.total_items_sold || 0 }}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-indigo-100 rounded-md p-3">
                        <svg class="h-6 w-6 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                        </svg>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm font-medium text-gray-500">Avg. Sale</p>
                        <p class="text-2xl font-semibold text-gray-900">₦{{ formatNumber(summary.average_transaction || 0) }}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Payment Methods Breakdown -->
        <div class="bg-white rounded-lg shadow p-6 mb-6">
            <h2 class="text-lg font-semibold text-gray-900 mb-4">Payment Methods</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div class="border border-gray-200 rounded-lg p-4">
                    <p class="text-sm text-gray-500">Cash</p>
                    <p class="text-xl font-semibold text-gray-900">₦{{ formatNumber(summary.cash_sales || 0) }}</p>
                </div>
                <div class="border border-gray-200 rounded-lg p-4">
                    <p class="text-sm text-gray-500">Card</p>
                    <p class="text-xl font-semibold text-gray-900">₦{{ formatNumber(summary.card_sales || 0) }}</p>
                </div>
                <div class="border border-gray-200 rounded-lg p-4">
                    <p class="text-sm text-gray-500">Transfer</p>
                    <p class="text-xl font-semibold text-gray-900">₦{{ formatNumber(summary.transfer_sales || 0) }}</p>
                </div>
            </div>
        </div>

        <!-- Sales Transactions Table -->
        <div class="bg-white rounded-lg shadow mb-6">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-lg font-semibold text-gray-900">Sales Transactions</h2>
                <p class="text-sm text-gray-500">Recent transactions with return details</p>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Sale #</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Items</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Amount</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Returns</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr v-for="sale in sales" :key="sale.id" :class="{ 'bg-red-50': sale.is_full_return, 'bg-yellow-50': sale.is_partial_return }">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                {{ sale.sale_number }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {{ sale.sale_date }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {{ sale.customer_name }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {{ sale.items_count }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                <div>₦{{ formatNumber(sale.total_amount) }}</div>
                                <div v-if="sale.has_returns" class="text-xs text-red-600">
                                    Net: ₦{{ formatNumber(sale.net_amount) }}
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span :class="getStatusClass(sale.status)" class="px-2 py-1 text-xs font-medium rounded-full">
                                    {{ formatStatus(sale.status) }}
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                <div v-if="sale.has_returns">
                                    <span class="text-red-600 font-medium">
                                        -₦{{ formatNumber(sale.total_returned) }}
                                    </span>
                                    <div class="text-xs text-gray-500">
                                        {{ sale.returns.length }} return(s)
                                    </div>
                                </div>
                                <span v-else class="text-gray-400">—</span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                <button
                                    v-if="sale.has_returns"
                                    @click="showReturnDetails(sale)"
                                    class="text-primary-600 hover:text-primary-900"
                                >
                                    View Returns
                                </button>
                            </td>
                        </tr>
                        <tr v-if="sales.length === 0">
                            <td colspan="8" class="px-6 py-12 text-center text-gray-500">
                                No sales found for the selected period.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Top Selling Drugs -->
        <div v-if="topDrugs.length > 0" class="bg-white rounded-lg shadow mb-6">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-lg font-semibold text-gray-900">Top Selling Products</h2>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">#</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Product</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Qty Sold</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Revenue</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr v-for="(drug, index) in topDrugs" :key="drug.id">
                            <td class="px-6 py-4 text-sm text-gray-500">{{ index + 1 }}</td>
                            <td class="px-6 py-4">
                                <div class="text-sm font-medium text-gray-900">{{ drug.brand_name }}</div>
                                <div class="text-xs text-gray-500">{{ drug.strength }} - {{ drug.dosage_form }}</div>
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-900">{{ drug.total_quantity }}</td>
                            <td class="px-6 py-4 text-sm font-medium text-gray-900">₦{{ formatNumber(drug.total_revenue) }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Return Details Modal -->
        <div v-if="showReturnModal" class="fixed inset-0 z-50 overflow-y-auto">
            <div class="flex items-center justify-center min-h-screen px-4">
                <div class="fixed inset-0 bg-gray-500 bg-opacity-75" @click="closeReturnModal"></div>
                <div class="relative bg-white rounded-lg shadow-xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
                    <div class="p-6 border-b border-gray-200">
                        <div class="flex justify-between items-center">
                            <h3 class="text-lg font-semibold text-gray-900">
                                Return Details - {{ selectedSale?.sale_number }}
                            </h3>
                            <button @click="closeReturnModal" class="text-gray-400 hover:text-gray-600">
                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                                </svg>
                            </button>
                        </div>
                    </div>
                    <div class="p-6">
                        <div v-for="ret in selectedSale?.returns" :key="ret.id" class="mb-6 border border-gray-200 rounded-lg p-4">
                            <div class="flex justify-between items-start mb-4">
                                <div>
                                    <p class="font-medium text-gray-900">{{ ret.return_number }}</p>
                                    <p class="text-sm text-gray-500">{{ ret.return_date }}</p>
                                </div>
                                <div class="text-right">
                                    <p class="text-lg font-semibold text-red-600">-₦{{ formatNumber(ret.refund_amount) }}</p>
                                    <p class="text-sm text-gray-500">{{ ret.refund_method }}</p>
                                </div>
                            </div>
                            <div class="grid grid-cols-2 gap-4 mb-4 text-sm">
                                <div>
                                    <span class="text-gray-500">Reason:</span>
                                    <span class="ml-2 text-gray-900">{{ ret.reason }}</span>
                                </div>
                                <div>
                                    <span class="text-gray-500">Processed by:</span>
                                    <span class="ml-2 text-gray-900">{{ ret.processed_by }}</span>
                                </div>
                                <div>
                                    <span class="text-gray-500">Authorized by:</span>
                                    <span class="ml-2 text-gray-900">{{ ret.authorized_by }}</span>
                                </div>
                            </div>
                            <div class="border-t pt-4">
                                <p class="text-sm font-medium text-gray-700 mb-2">Returned Items:</p>
                                <table class="min-w-full text-sm">
                                    <thead>
                                        <tr class="text-left text-gray-500">
                                            <th class="pb-2">Product</th>
                                            <th class="pb-2">Qty</th>
                                            <th class="pb-2">Unit Price</th>
                                            <th class="pb-2">Refund</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="(item, idx) in ret.items" :key="idx">
                                            <td class="py-1">{{ item.drug_name }} {{ item.drug_strength }}</td>
                                            <td class="py-1">{{ item.quantity }}</td>
                                            <td class="py-1">₦{{ formatNumber(item.unit_price) }}</td>
                                            <td class="py-1 text-red-600">₦{{ formatNumber(item.refund_amount) }}</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="mt-4 pt-4 border-t flex justify-end">
                                <Button @click="printReturnReceipt(ret.id)" variant="outline" size="sm">
                                    <svg class="h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" />
                                    </svg>
                                    Print Receipt
                                </Button>
                            </div>
                        </div>
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

const props = defineProps({
    summary: Object,
    dailySales: Array,
    topDrugs: Array,
    sales: Array,
    filters: Object,
});

const localFilters = reactive({
    period: props.filters?.period || 'month',
    start_date: props.filters?.start_date || null,
    end_date: props.filters?.end_date || null,
});

const showReturnModal = ref(false);
const selectedSale = ref(null);

const formatNumber = (value) => {
    return parseFloat(value || 0).toLocaleString('en-NG', {
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
    router.get(route('reports.sales'), localFilters, {
        preserveState: true,
        preserveScroll: true,
    });
};

const exportReport = () => {
    window.location.href = route('reports.sales.export', {
        start_date: props.filters.start_date,
        end_date: props.filters.end_date,
    });
};

const getStatusClass = (status) => {
    const classes = {
        'completed': 'bg-green-100 text-green-800',
        'partially_returned': 'bg-yellow-100 text-yellow-800',
        'returned': 'bg-red-100 text-red-800',
    };
    return classes[status] || 'bg-gray-100 text-gray-800';
};

const formatStatus = (status) => {
    const labels = {
        'completed': 'Completed',
        'partially_returned': 'Partial Return',
        'returned': 'Full Return',
    };
    return labels[status] || status;
};

const showReturnDetails = (sale) => {
    selectedSale.value = sale;
    showReturnModal.value = true;
};

const closeReturnModal = () => {
    showReturnModal.value = false;
    selectedSale.value = null;
};

const printReturnReceipt = (returnId) => {
    window.open(route('reports.return-receipt', returnId), '_blank');
};
</script>

