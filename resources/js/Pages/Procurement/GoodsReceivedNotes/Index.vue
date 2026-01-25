<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Goods Received Notes</h1>
                <p class="mt-1 text-sm text-gray-500">
                    Track received goods and quality control
                </p>
            </div>
            <div class="flex-shrink-0">
                <Button @click="$inertia.visit(route('goods-received-notes.create'))">
                    <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Create GRN
                </Button>
            </div>
        </div>

        <!-- Filters -->
        <div class="mb-6 bg-white rounded-lg shadow p-4">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
                    <input
                        v-model="localFilters.search"
                        type="text"
                        placeholder="GRN number or PO number..."
                        class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @input="applyFilters"
                    />
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select
                        v-model="localFilters.status"
                        class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @change="applyFilters"
                    >
                        <option value="">All Statuses</option>
                        <option value="pending_quality_check">Pending Quality Check</option>
                        <option value="approved">Approved</option>
                        <option value="rejected">Rejected</option>
                    </select>
                </div>

                <div class="flex items-end">
                    <Button variant="outline" @click="clearFilters" class="w-full">
                        Clear Filters
                    </Button>
                </div>
            </div>
        </div>

        <!-- GRN Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <Table>
                <template #header>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">GRN Number</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">PO Number</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Supplier</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Received Date</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Actions</th>
                </template>

                <template #body>
                    <tr v-for="grn in grns.data" :key="grn.id" class="hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                            {{ grn.grn_number }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            {{ grn.purchase_order?.order_number || 'N/A' }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            {{ grn.purchase_order?.supplier?.name || 'N/A' }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            {{ formatDate(grn.received_date) }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <Badge :variant="getStatusVariant(grn.status)">
                                {{ getStatusLabel(grn.status) }}
                            </Badge>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                            <button
                                @click="viewGRN(grn.id)"
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
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
                        </svg>
                        <h3 class="mt-2 text-sm font-medium text-gray-900">No goods received notes</h3>
                        <p class="mt-1 text-sm text-gray-500">Get started by creating a new GRN.</p>
                    </div>
                </template>
            </Table>

            <!-- Pagination -->
            <div v-if="grns.data && grns.data.length > 0" class="px-6 py-4 border-t border-gray-200">
                <div class="flex items-center justify-between">
                    <div class="text-sm text-gray-700">
                        Showing {{ grns.from }} to {{ grns.to }} of {{ grns.total }} results
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
    grns: Object,
    filters: Object,
    statuses: Object,
});

const localFilters = reactive({
    search: props.filters?.search || '',
    status: props.filters?.status || '',
});

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-NG');
};

const getStatusVariant = (status) => {
    const variants = {
        pending_quality_check: 'warning',
        approved: 'success',
        rejected: 'danger',
    };
    return variants[status] || 'secondary';
};

const getStatusLabel = (status) => {
    return status.replace('_', ' ').toUpperCase();
};

const applyFilters = () => {
    router.get(route('goods-received-notes.index'), localFilters, {
        preserveState: true,
        preserveScroll: true,
    });
};

const clearFilters = () => {
    localFilters.search = '';
    localFilters.status = '';
    applyFilters();
};

const viewGRN = (id) => {
    router.visit(route('goods-received-notes.show', id));
};
</script>

