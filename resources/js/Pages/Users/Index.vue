<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">User Management</h1>
                <p class="mt-1 text-sm text-gray-500">
                    Manage system users and access control
                </p>
            </div>
            <div class="flex-shrink-0">
                <Button @click="$inertia.visit(route('users.create'))">
                    <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Add User
                </Button>
            </div>
        </div>

        <!-- Filters -->
        <div class="mb-6 bg-white rounded-lg shadow p-4">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
                    <input
                        v-model="filters.search"
                        type="text"
                        placeholder="Name or email..."
                        @input="applyFilters"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    />
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Role</label>
                    <select
                        v-model="filters.role"
                        @change="applyFilters"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    >
                        <option value="">All Roles</option>
                        <option v-for="role in roles" :key="role.id" :value="role.name">
                            {{ role.name }}
                        </option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Branch</label>
                    <select
                        v-model="filters.branch_id"
                        @change="applyFilters"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    >
                        <option value="">All Branches</option>
                        <option v-for="branch in branches" :key="branch.id" :value="branch.id">
                            {{ branch.name }}
                        </option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select
                        v-model="filters.status"
                        @change="applyFilters"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    >
                        <option value="">All Status</option>
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Users Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <Table>
                <template #header>
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Name</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Role</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Branch</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                        <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Actions</th>
                    </tr>
                </template>
                <template #body>
                    <tr v-for="user in users.data" :key="user.id" class="hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                            {{ user.name }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            {{ user.email }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            <Badge :variant="getRoleBadgeVariant(user.role?.name)">
                                {{ user.role?.name || 'N/A' }}
                            </Badge>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            {{ user.branch?.name || 'N/A' }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <Badge :variant="user.is_active ? 'success' : 'danger'">
                                {{ user.is_active ? 'Active' : 'Inactive' }}
                            </Badge>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                            <button
                                @click="$inertia.visit(route('users.edit', user.id))"
                                class="text-primary-600 hover:text-primary-900"
                            >
                                Edit
                            </button>
                            <button
                                @click="toggleStatus(user)"
                                class="text-yellow-600 hover:text-yellow-900"
                            >
                                {{ user.is_active ? 'Deactivate' : 'Activate' }}
                            </button>
                            <button
                                @click="deleteUser(user)"
                                class="text-red-600 hover:text-red-900"
                            >
                                Delete
                            </button>
                        </td>
                    </tr>
                </template>
            </Table>

            <!-- Pagination -->
            <div class="px-6 py-4 border-t border-gray-200">
                <div class="flex items-center justify-between">
                    <div class="text-sm text-gray-700">
                        Showing {{ users.from || 0 }} to {{ users.to || 0 }} of {{ users.total }} users
                    </div>
                    <div class="flex gap-2">
                        <Button
                            v-for="link in users.links"
                            :key="link.label"
                            @click="link.url && $inertia.visit(link.url)"
                            :variant="link.active ? 'primary' : 'outline'"
                            :disabled="!link.url"
                            size="sm"
                            v-html="link.label"
                        />
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { ref } from 'vue';
import { router } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';
import Badge from '@/Components/Badge.vue';
import Table from '@/Components/Table.vue';

const props = defineProps({
    users: Object,
    filters: Object,
    roles: Array,
    branches: Array,
});

const filters = ref({
    search: props.filters?.search || '',
    role: props.filters?.role || '',
    branch_id: props.filters?.branch_id || '',
    status: props.filters?.status || '',
});

const applyFilters = () => {
    router.get(route('users.index'), filters.value, {
        preserveState: true,
        replace: true,
    });
};

const getRoleBadgeVariant = (roleName) => {
    const variants = {
        'Super Admin': 'danger',
        'Pharmacist': 'success',
        'Store Manager': 'info',
        'Sales Staff': 'secondary',
    };
    return variants[roleName] || 'secondary';
};

const toggleStatus = (user) => {
    const action = user.is_active ? 'deactivate' : 'activate';
    if (confirm(`Are you sure you want to ${action} ${user.name}?`)) {
        router.post(route('users.toggle-status', user.id));
    }
};

const deleteUser = (user) => {
    if (confirm(`Are you sure you want to delete ${user.name}? This action cannot be undone.`)) {
        router.delete(route('users.destroy', user.id));
    }
};
</script>


