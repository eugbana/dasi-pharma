<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Stock Transfers</h1>
                <p class="mt-1 text-sm text-gray-500">
                    Manage inter-branch stock transfers
                </p>
            </div>
            <div class="flex-shrink-0">
                <Button @click="$inertia.visit(route('stock-transfers.create'))">
                    <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4" />
                    </svg>
                    New Transfer
                </Button>
            </div>
        </div>

        <!-- Filters -->
        <div class="mb-6 bg-white rounded-lg shadow p-4">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <!-- Status Filter -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select
                        v-model="filters.status"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @change="applyFilters"
                    >
                        <option value="">All Statuses</option>
                        <option v-for="(label, value) in statuses" :key="value" :value="value">
                            {{ label }}
                        </option>
                    </select>
                </div>

                <!-- Direction Filter -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Direction</label>
                    <select
                        v-model="filters.direction"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @change="applyFilters"
                    >
                        <option value="">All Transfers</option>
                        <option value="outgoing">Outgoing</option>
                        <option value="incoming">Incoming</option>
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

        <!-- Transfers Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <Table>
                <template #header>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Transfer #
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        From / To
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Date
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Status
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Requested By
                    </th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Actions
                    </th>
                </template>

                <template #body>
                    <tr v-for="transfer in transfers.data" :key="transfer.id" class="hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm font-medium text-gray-900">{{ transfer.transfer_number }}</div>
                        </td>
                        <td class="px-6 py-4">
                            <div class="text-sm">
                                <div class="font-medium text-gray-900">From: {{ transfer.from_branch.name }}</div>
                                <div class="text-gray-500">To: {{ transfer.to_branch.name }}</div>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            {{ formatDate(transfer.transfer_date) }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <Badge :variant="getStatusVariant(transfer.status)">
                                {{ statuses[transfer.status] }}
                            </Badge>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            {{ transfer.requester.name }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                            <button
                                @click="viewTransfer(transfer.id)"
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
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4" />
                        </svg>
                        <h3 class="mt-2 text-sm font-medium text-gray-900">No stock transfers</h3>
                        <p class="mt-1 text-sm text-gray-500">Get started by creating a new transfer.</p>
                    </div>
                </template>
            </Table>

            <!-- Pagination -->
            <div v-if="transfers.data.length > 0" class="px-6 py-4 border-t border-gray-200">
                <div class="text-sm text-gray-700">
                    Showing {{ transfers.from }} to {{ transfers.to }} of {{ transfers.total }} results
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
    transfers: Object,
    filters: Object,
    statuses: Object,
});

const filters = reactive({
    status: props.filters?.status || '',
    direction: props.filters?.direction || '',
});

const applyFilters = () => {
    router.get(route('stock-transfers.index'), filters, {
        preserveState: true,
        preserveScroll: true,
    });
};

const clearFilters = () => {
    filters.status = '';
    filters.direction = '';
    applyFilters();
};

const viewTransfer = (id) => {
    router.visit(route('stock-transfers.show', id));
};

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-NG', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
    });
};

const getStatusVariant = (status) => {
    const variants = {
        'pending': 'warning',
        'approved': 'secondary',
        'in_transit': 'primary',
        'received': 'success',
        'cancelled': 'danger',
    };
    return variants[status] || 'secondary';
};
</script>

