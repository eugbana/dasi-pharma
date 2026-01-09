<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-2xl font-bold text-gray-900">Dashboard</h1>
            <p class="mt-1 text-sm text-gray-500">
                Welcome back, {{ $page.props.auth.user?.name }}
            </p>
        </div>

        <!-- Metrics Grid -->
        <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4 mb-8">
            <!-- Today's Sales -->
            <MetricCard
                title="Today's Sales"
                :value="formatCurrency(metrics.today_sales)"
                :subtitle="`${metrics.today_transactions} transactions`"
                icon-color="bg-primary-500"
            >
                <template #icon>
                    <svg class="h-6 w-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </template>
            </MetricCard>

            <!-- Low Stock Items -->
            <MetricCard
                title="Low Stock Items"
                :value="metrics.low_stock_items"
                subtitle="Below reorder point"
                icon-color="bg-warning-500"
            >
                <template #icon>
                    <svg class="h-6 w-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                    </svg>
                </template>
            </MetricCard>

            <!-- Pending POs -->
            <MetricCard
                title="Pending POs"
                :value="metrics.pending_pos"
                subtitle="Awaiting approval"
                icon-color="bg-indigo-500"
            >
                <template #icon>
                    <svg class="h-6 w-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                </template>
            </MetricCard>

            <!-- Expiring Soon -->
            <MetricCard
                title="Expiring Soon"
                :value="metrics.expiring_soon"
                subtitle="Within 30 days"
                icon-color="bg-accent-500"
            >
                <template #icon>
                    <svg class="h-6 w-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </template>
            </MetricCard>
        </div>

        <!-- Charts Row -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- Sales Trend Chart -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                <h2 class="text-lg font-semibold text-gray-900 mb-4">Sales Trend (Last 7 Days)</h2>
                <div class="h-64">
                    <LineChart :data="salesChartData" />
                </div>
            </div>

            <!-- Top Selling Drugs Chart -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                <h2 class="text-lg font-semibold text-gray-900 mb-4">Top Selling Drugs (Last 30 Days)</h2>
                <div class="h-64">
                    <BarChart :data="topDrugsChartData" />
                </div>
            </div>
        </div>

        <!-- Content Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Recent Sales -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h2 class="text-lg font-semibold text-gray-900">Recent Sales</h2>
                </div>
                <div class="p-6">
                    <div v-if="recentSales.length > 0" class="space-y-4">
                        <div
                            v-for="sale in recentSales"
                            :key="sale.id"
                            class="flex items-center justify-between py-3 border-b border-gray-100 last:border-0"
                        >
                            <div class="flex-1">
                                <p class="text-sm font-medium text-gray-900">
                                    {{ sale.sale_number }}
                                </p>
                                <p class="text-xs text-gray-500">
                                    {{ sale.customer_name || 'Walk-in Customer' }} • {{ sale.items_count }} items
                                </p>
                                <p class="text-xs text-gray-400 mt-1">
                                    {{ sale.sale_date }} • {{ sale.user }}
                                </p>
                            </div>
                            <div class="text-right">
                                <p class="text-sm font-semibold text-gray-900">
                                    {{ formatCurrency(sale.total_amount) }}
                                </p>
                            </div>
                        </div>
                    </div>
                    <div v-else class="text-center py-8 text-gray-500">
                        <p>No recent sales</p>
                    </div>
                </div>
            </div>

            <!-- Expiring Items -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h2 class="text-lg font-semibold text-gray-900">Expiring Items</h2>
                </div>
                <div class="p-6">
                    <div v-if="expiringItems.length > 0" class="space-y-4">
                        <div
                            v-for="item in expiringItems"
                            :key="item.id"
                            class="flex items-center justify-between py-3 border-b border-gray-100 last:border-0"
                        >
                            <div class="flex-1">
                                <p class="text-sm font-medium text-gray-900">
                                    {{ item.drug_name }}
                                </p>
                                <p class="text-xs text-gray-500">
                                    {{ item.strength }} • {{ item.dosage_form }}
                                </p>
                                <p class="text-xs text-gray-400 mt-1">
                                    Batch: {{ item.batch_number }} • Qty: {{ item.quantity_available }}
                                </p>
                            </div>
                            <div class="text-right">
                                <span
                                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                                    :class="getExpiryBadgeClass(item.days_until_expiry)"
                                >
                                    {{ item.days_until_expiry }} days
                                </span>
                                <p class="text-xs text-gray-500 mt-1">
                                    {{ item.expiry_date }}
                                </p>
                            </div>
                        </div>
                    </div>
                    <div v-else class="text-center py-8 text-gray-500">
                        <p>No expiring items</p>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { computed } from 'vue';
import AppLayout from '@/Layouts/AppLayout.vue';
import MetricCard from '@/Components/MetricCard.vue';
import LineChart from '@/Components/LineChart.vue';
import BarChart from '@/Components/BarChart.vue';

const props = defineProps({
    metrics: Object,
    recentSales: Array,
    expiringItems: Array,
    salesTrend: Array,
    topDrugs: Array,
});

const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-NG', {
        style: 'currency',
        currency: 'NGN',
    }).format(amount);
};

const getExpiryBadgeClass = (days) => {
    if (days <= 0) return 'bg-danger-100 text-danger-800';
    if (days <= 7) return 'bg-danger-100 text-danger-800';
    if (days <= 30) return 'bg-warning-100 text-warning-800';
    return 'bg-accent-100 text-accent-800';
};

// Sales trend chart data
const salesChartData = computed(() => {
    const labels = props.salesTrend?.map(item => {
        const date = new Date(item.date);
        return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
    }) || [];

    const data = props.salesTrend?.map(item => item.total) || [];

    return {
        labels,
        datasets: [
            {
                label: 'Sales (₦)',
                data,
                borderColor: 'rgb(59, 130, 246)',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                tension: 0.4,
                fill: true,
            },
        ],
    };
});

// Top drugs chart data
const topDrugsChartData = computed(() => {
    const labels = props.topDrugs?.map(item => item.brand_name) || [];
    const data = props.topDrugs?.map(item => item.total_quantity) || [];

    return {
        labels,
        datasets: [
            {
                label: 'Quantity Sold',
                data,
                backgroundColor: [
                    'rgba(59, 130, 246, 0.8)',
                    'rgba(16, 185, 129, 0.8)',
                    'rgba(245, 158, 11, 0.8)',
                    'rgba(239, 68, 68, 0.8)',
                    'rgba(139, 92, 246, 0.8)',
                ],
            },
        ],
    };
});
</script>

