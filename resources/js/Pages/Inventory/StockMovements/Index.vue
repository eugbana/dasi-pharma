<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Stock Movements</h1>
                <p class="mt-1 text-sm text-gray-500">
                    Complete audit trail of all inventory changes
                </p>
            </div>
            <div class="flex-shrink-0">
                <Button @click="$inertia.visit(route('stock-movements.create'))">
                    <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Record Adjustment
                </Button>
            </div>
        </div>

        <!-- Filters -->
        <div class="mb-6 bg-white rounded-lg shadow p-4">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <!-- Movement Type -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Movement Type</label>
                    <select
                        v-model="filters.movement_type"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @change="applyFilters"
                    >
                        <option value="">All Types</option>
                        <option v-for="(label, value) in movementTypes" :key="value" :value="value">
                            {{ label }}
                        </option>
                    </select>
                </div>

                <!-- Date From -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Date From</label>
                    <input
                        v-model="filters.date_from"
                        type="date"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @change="applyFilters"
                    />
                </div>

                <!-- Date To -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Date To</label>
                    <input
                        v-model="filters.date_to"
                        type="date"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @change="applyFilters"
                    />
                </div>

                <!-- Clear Filters -->
                <div class="flex items-end">
                    <Button variant="outline" @click="clearFilters" class="w-full">
                        Clear Filters
                    </Button>
                </div>
            </div>
        </div>

        <!-- Movements Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <Table>
                <template #header>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Date
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Drug / Batch
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Type
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Quantity
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        User
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Reason
                    </th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Actions
                    </th>
                </template>

                <template #body>
                    <tr v-for="movement in movements.data" :key="movement.id" class="hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            {{ formatDate(movement.movement_date) }}
                        </td>
                        <td class="px-6 py-4">
                            <div class="text-sm font-medium text-gray-900">{{ movement.stock_item?.drug?.brand_name }}</div>
                            <div class="text-sm text-gray-500">Batch: {{ movement.stock_item?.batch_number }}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <Badge :variant="getMovementTypeVariant(movement.movement_type)">
                                {{ movementTypes[movement.movement_type] }}
                            </Badge>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <span
                                class="text-sm font-medium"
                                :class="movement.quantity > 0 ? 'text-success-600' : 'text-danger-600'"
                            >
                                {{ movement.quantity > 0 ? '+' : '' }}{{ movement.quantity }}
                            </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            {{ movement.user.name }}
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-500">
                            {{ movement.reason || '-' }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                            <button
                                @click="viewMovement(movement.id)"
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
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                        </svg>
                        <h3 class="mt-2 text-sm font-medium text-gray-900">No stock movements</h3>
                        <p class="mt-1 text-sm text-gray-500">No movements recorded yet.</p>
                    </div>
                </template>
            </Table>

            <!-- Pagination -->
            <div v-if="movements.data.length > 0" class="px-6 py-4 border-t border-gray-200">
                <div class="text-sm text-gray-700">
                    Showing {{ movements.from }} to {{ movements.to }} of {{ movements.total }} results
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
    movements: Object,
    filters: Object,
    movementTypes: Object,
});

const filters = reactive({
    movement_type: props.filters?.movement_type || '',
    date_from: props.filters?.date_from || '',
    date_to: props.filters?.date_to || '',
});

const applyFilters = () => {
    router.get(route('stock-movements.index'), filters, {
        preserveState: true,
        preserveScroll: true,
    });
};

const clearFilters = () => {
    filters.movement_type = '';
    filters.date_from = '';
    filters.date_to = '';
    applyFilters();
};

const viewMovement = (id) => {
    router.visit(route('stock-movements.show', id));
};

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-NG', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
    });
};

const getMovementTypeVariant = (type) => {
    const variants = {
        'purchase': 'success',
        'sale': 'primary',
        'transfer_in': 'success',
        'transfer_out': 'warning',
        'adjustment': 'secondary',
        'expiry': 'danger',
        'return': 'warning',
    };
    return variants[type] || 'secondary';
};
</script>


