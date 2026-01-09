<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Purchase Orders</h1>
                <p class="mt-1 text-sm text-gray-500">
                    Manage purchase orders and approvals
                </p>
            </div>
            <div class="flex-shrink-0">
                <Button @click="$inertia.visit(route('purchase-orders.create'))">
                    <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Create Purchase Order
                </Button>
            </div>
        </div>

        <!-- Filters -->
        <div class="mb-6 bg-white rounded-lg shadow p-4">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
                    <input
                        v-model="filters.search"
                        type="text"
                        placeholder="PO number or supplier..."
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @input="applyFilters"
                    />
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select
                        v-model="filters.status"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @change="applyFilters"
                    >
                        <option value="">All Statuses</option>
                        <option value="draft">Draft</option>
                        <option value="pending_approval">Pending Approval</option>
                        <option value="approved">Approved</option>
                        <option value="received">Received</option>
                        <option value="cancelled">Cancelled</option>
                    </select>
                </div>

                <div class="flex items-end">
                    <Button variant="outline" @click="clearFilters" class="w-full">
                        Clear Filters
                    </Button>
                </div>
            </div>
        </div>

        <!-- Purchase Orders Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <Table>
                <template #header>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">PO Number</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Supplier</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Order Date</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Total Amount</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Actions</th>
                </template>

                <template #body>
                    <tr v-for="po in purchaseOrders.data" :key="po.id" class="hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                            {{ po.order_number }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            {{ po.supplier?.name || 'N/A' }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            {{ formatDate(po.order_date) }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            ₦{{ formatNumber(po.total_amount) }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <Badge :variant="getStatusVariant(po.status)">
                                {{ getStatusLabel(po.status) }}
                            </Badge>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                            <button
                                @click="viewPO(po.id)"
                                class="text-primary-600 hover:text-primary-900"
                            >
                                View
                            </button>
                        </td>
                    </tr>
                </template>

                <template #empty>
                    <div class="text-center py-12">
                        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                        </svg>
                        <h3 class="mt-2 text-sm font-medium text-gray-900">No purchase orders</h3>
                        <p class="mt-1 text-sm text-gray-500">Get started by creating a new purchase order.</p>
                    </div>
                </template>
            </Table>

            <!-- Pagination -->
            <div v-if="purchaseOrders.data.length > 0" class="px-6 py-4 border-t border-gray-200">
                <div class="flex items-center justify-between">
                    <div class="text-sm text-gray-700">
                        Showing {{ purchaseOrders.from }} to {{ purchaseOrders.to }} of {{ purchaseOrders.total }} results
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
import Table from '@/Components/Table.vue';
import Badge from '@/Components/Badge.vue';

const props = defineProps({
    purchaseOrders: Object,
});

const filters = reactive({
    search: '',
    status: '',
});

const formatNumber = (value) => {
    return parseFloat(value).toLocaleString('en-NG', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    });
};

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-NG');
};

const getStatusVariant = (status) => {
    const variants = {
        draft: 'secondary',
        pending_approval: 'warning',
        approved: 'success',
        received: 'info',
        cancelled: 'danger',
    };
    return variants[status] || 'secondary';
};

const getStatusLabel = (status) => {
    return status.replace('_', ' ').toUpperCase();
};

const applyFilters = () => {
    router.get(route('purchase-orders.index'), filters, {
        preserveState: true,
        preserveScroll: true,
    });
};

const clearFilters = () => {
    filters.search = '';
    filters.status = '';
    applyFilters();
};

const viewPO = (id) => {
    router.visit(route('purchase-orders.show', id));
};
</script>

