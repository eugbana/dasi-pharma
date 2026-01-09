<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <div class="flex items-center gap-2 text-sm text-gray-500 mb-2">
                    <button @click="$inertia.visit(route('admin.branches.index'))" class="hover:text-primary-600">Branches</button>
                    <span>/</span>
                    <span>{{ branch.name }}</span>
                </div>
                <div class="flex items-center gap-3">
                    <h1 class="text-2xl font-bold text-gray-900">{{ branch.name }}</h1>
                    <span :class="branch.is_active ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" class="px-2 py-1 text-xs font-medium rounded-full">
                        {{ branch.is_active ? 'Active' : 'Inactive' }}
                    </span>
                </div>
            </div>
            <Button @click="$inertia.visit(route('admin.branches.edit', branch.id))">
                Edit Branch
            </Button>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Branch Details -->
            <div class="lg:col-span-1 space-y-6">
                <div class="bg-white rounded-lg shadow p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Branch Details</h2>
                    <dl class="space-y-4">
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Code</dt>
                            <dd class="mt-1 text-sm text-gray-900 font-mono">{{ branch.code }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Address</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ branch.address }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Phone</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ branch.phone || '-' }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Email</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ branch.email || '-' }}</dd>
                        </div>
                    </dl>
                </div>

                <!-- Stock Summary -->
                <div class="bg-white rounded-lg shadow p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Stock Summary</h2>
                    <dl class="space-y-4">
                        <div class="flex justify-between">
                            <dt class="text-sm text-gray-500">Total Items</dt>
                            <dd class="text-sm font-medium text-gray-900">{{ stockSummary?.total_items || 0 }}</dd>
                        </div>
                        <div class="flex justify-between">
                            <dt class="text-sm text-gray-500">Total Quantity</dt>
                            <dd class="text-sm font-medium text-gray-900">{{ stockSummary?.total_quantity || 0 }}</dd>
                        </div>
                        <div class="flex justify-between">
                            <dt class="text-sm text-gray-500">Stock Value</dt>
                            <dd class="text-sm font-medium text-gray-900">₦{{ formatNumber(stockSummary?.stock_value || 0) }}</dd>
                        </div>
                        <div class="flex justify-between">
                            <dt class="text-sm text-gray-500">Low Stock Items</dt>
                            <dd class="text-sm font-medium" :class="stockSummary?.low_stock_count > 0 ? 'text-amber-600' : 'text-gray-900'">
                                {{ stockSummary?.low_stock_count || 0 }}
                            </dd>
                        </div>
                        <div class="flex justify-between">
                            <dt class="text-sm text-gray-500">Expiring Soon</dt>
                            <dd class="text-sm font-medium" :class="stockSummary?.expiring_soon > 0 ? 'text-red-600' : 'text-gray-900'">
                                {{ stockSummary?.expiring_soon || 0 }}
                            </dd>
                        </div>
                    </dl>
                </div>
            </div>

            <!-- Users and Sales -->
            <div class="lg:col-span-2 space-y-6">
                <!-- Assigned Users -->
                <div class="bg-white rounded-lg shadow">
                    <div class="p-6 border-b border-gray-200">
                        <h2 class="text-lg font-semibold text-gray-900">Assigned Users ({{ branch.users?.length || 0 }})</h2>
                    </div>
                    <div class="divide-y divide-gray-200">
                        <div v-for="user in branch.users" :key="user.id" class="p-4 flex items-center justify-between">
                            <div>
                                <div class="text-sm font-medium text-gray-900">{{ user.name }}</div>
                                <div class="text-sm text-gray-500">{{ user.email }}</div>
                            </div>
                            <span class="px-2 py-1 text-xs font-medium bg-gray-100 text-gray-800 rounded-full">
                                {{ user.role?.name || 'No Role' }}
                            </span>
                        </div>
                        <div v-if="!branch.users?.length" class="p-6 text-center text-gray-500">
                            No users assigned to this branch
                        </div>
                    </div>
                </div>

                <!-- Recent Sales -->
                <div class="bg-white rounded-lg shadow">
                    <div class="p-6 border-b border-gray-200">
                        <h2 class="text-lg font-semibold text-gray-900">Recent Sales</h2>
                    </div>
                    <div class="divide-y divide-gray-200">
                        <div v-for="sale in recentSales" :key="sale.id" class="p-4 flex items-center justify-between">
                            <div>
                                <div class="text-sm font-medium text-gray-900">{{ sale.sale_number }}</div>
                                <div class="text-sm text-gray-500">{{ formatDate(sale.sale_date) }} by {{ sale.user?.name }}</div>
                            </div>
                            <div class="text-right">
                                <div class="text-sm font-medium text-gray-900">₦{{ formatNumber(sale.total_amount) }}</div>
                                <span :class="sale.status === 'completed' ? 'text-green-600' : 'text-amber-600'" class="text-xs">
                                    {{ sale.status }}
                                </span>
                            </div>
                        </div>
                        <div v-if="!recentSales?.length" class="p-6 text-center text-gray-500">
                            No sales recorded for this branch
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';

defineProps({
    branch: Object,
    stockSummary: Object,
    recentSales: Array,
});

const formatNumber = (num) => {
    return new Intl.NumberFormat('en-NG', { minimumFractionDigits: 2 }).format(num);
};

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-NG', { year: 'numeric', month: 'short', day: 'numeric' });
};
</script>

