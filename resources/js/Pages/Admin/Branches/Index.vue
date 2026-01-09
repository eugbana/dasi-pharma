<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Branches</h1>
                <p class="mt-1 text-sm text-gray-500">Manage pharmacy branch locations</p>
            </div>
            <Button @click="$inertia.visit(route('admin.branches.create'))">
                <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                </svg>
                Add Branch
            </Button>
        </div>

        <!-- Filters -->
        <div class="mb-6 bg-white rounded-lg shadow p-4">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
                    <input
                        v-model="localFilters.search"
                        type="text"
                        placeholder="Search branches..."
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        @input="debouncedSearch"
                    />
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select v-model="localFilters.status" @change="applyFilters" class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500">
                        <option value="">All Status</option>
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Branches Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Branch</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Code</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Contact</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Users</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Stock Items</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                        <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Actions</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    <tr v-for="branch in branches.data" :key="branch.id" class="hover:bg-gray-50">
                        <td class="px-6 py-4">
                            <div class="text-sm font-medium text-gray-900">{{ branch.name }}</div>
                            <div class="text-sm text-gray-500">{{ branch.address }}</div>
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-900 font-mono">{{ branch.code }}</td>
                        <td class="px-6 py-4">
                            <div class="text-sm text-gray-900">{{ branch.phone || '-' }}</div>
                            <div class="text-sm text-gray-500">{{ branch.email || '-' }}</div>
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-900">{{ branch.users_count }}</td>
                        <td class="px-6 py-4 text-sm text-gray-900">{{ branch.stock_items_count }}</td>
                        <td class="px-6 py-4">
                            <span :class="branch.is_active ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" class="px-2 py-1 text-xs font-medium rounded-full">
                                {{ branch.is_active ? 'Active' : 'Inactive' }}
                            </span>
                        </td>
                        <td class="px-6 py-4 text-right text-sm font-medium space-x-2">
                            <button @click="$inertia.visit(route('admin.branches.show', branch.id))" class="text-primary-600 hover:text-primary-900">View</button>
                            <button @click="$inertia.visit(route('admin.branches.edit', branch.id))" class="text-gray-600 hover:text-gray-900">Edit</button>
                            <button @click="confirmDelete(branch)" class="text-red-600 hover:text-red-900">Delete</button>
                        </td>
                    </tr>
                    <tr v-if="branches.data.length === 0">
                        <td colspan="7" class="px-6 py-12 text-center text-gray-500">No branches found.</td>
                    </tr>
                </tbody>
            </table>

            <!-- Pagination -->
            <div v-if="branches.links && branches.links.length > 3" class="px-6 py-4 border-t border-gray-200">
                <div class="flex items-center justify-between">
                    <div class="text-sm text-gray-700">
                        Showing {{ branches.from }} to {{ branches.to }} of {{ branches.total }} branches
                    </div>
                    <div class="flex space-x-1">
                        <template v-for="link in branches.links" :key="link.label">
                            <button
                                v-if="link.url"
                                @click="$inertia.visit(link.url)"
                                :class="link.active ? 'bg-primary-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'"
                                class="px-3 py-1 text-sm border rounded"
                                v-html="link.label"
                            ></button>
                        </template>
                    </div>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div v-if="showDeleteModal" class="fixed inset-0 z-50 overflow-y-auto">
            <div class="flex items-center justify-center min-h-screen px-4">
                <div class="fixed inset-0 bg-gray-500 bg-opacity-75" @click="showDeleteModal = false"></div>
                <div class="relative bg-white rounded-lg shadow-xl max-w-md w-full p-6">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Delete Branch</h3>
                    <p class="text-sm text-gray-600 mb-6">
                        Are you sure you want to delete <strong>{{ branchToDelete?.name }}</strong>? This action cannot be undone.
                    </p>
                    <div class="flex justify-end gap-3">
                        <Button @click="showDeleteModal = false" variant="outline">Cancel</Button>
                        <Button @click="deleteBranch" variant="danger">Delete</Button>
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
    branches: Object,
    filters: Object,
});

const localFilters = reactive({
    search: props.filters?.search || '',
    status: props.filters?.status || '',
});

const showDeleteModal = ref(false);
const branchToDelete = ref(null);

let searchTimeout;
const debouncedSearch = () => {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(applyFilters, 300);
};

const applyFilters = () => {
    router.get(route('admin.branches.index'), localFilters, { preserveState: true, preserveScroll: true });
};

const confirmDelete = (branch) => {
    branchToDelete.value = branch;
    showDeleteModal.value = true;
};

const deleteBranch = () => {
    router.delete(route('admin.branches.destroy', branchToDelete.value.id), {
        onSuccess: () => { showDeleteModal.value = false; branchToDelete.value = null; }
    });
};
</script>

