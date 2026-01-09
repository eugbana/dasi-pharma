<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6 flex items-center justify-between">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Roles & Permissions</h1>
                <p class="mt-1 text-sm text-gray-500">
                    Manage system roles and their permission assignments
                </p>
            </div>
            <Button @click="$inertia.visit(route('roles.create'))">
                <template #icon>
                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                </template>
                Create Role
            </Button>
        </div>

        <!-- Roles Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <div
                v-for="role in roles"
                :key="role.id"
                class="bg-white rounded-lg shadow-sm border border-gray-200 hover:shadow-md transition-shadow"
            >
                <!-- Role Header -->
                <div class="p-6 border-b border-gray-200">
                    <div class="flex items-start justify-between">
                        <div class="flex-1">
                            <h3 class="text-lg font-semibold text-gray-900">{{ role.name }}</h3>
                            <p class="mt-1 text-sm text-gray-500">{{ role.description || 'No description' }}</p>
                        </div>
                        <Badge :variant="getRoleBadgeVariant(role.name)">
                            {{ role.users_count }} {{ role.users_count === 1 ? 'user' : 'users' }}
                        </Badge>
                    </div>
                </div>

                <!-- Permissions Summary -->
                <div class="p-6">
                    <div class="flex items-center justify-between mb-4">
                        <span class="text-sm font-medium text-gray-700">Permissions</span>
                        <span class="text-sm text-gray-500">{{ role.permissions_count }} assigned</span>
                    </div>

                    <!-- Permission Modules -->
                    <div class="space-y-2">
                        <div
                            v-for="(perms, module) in role.permissions"
                            :key="module"
                            class="flex items-center justify-between text-sm"
                        >
                            <span class="text-gray-600 capitalize">{{ module }}</span>
                            <span class="text-gray-900 font-medium">{{ perms.length }}</span>
                        </div>
                        <div v-if="role.permissions_count === 0" class="text-sm text-gray-400 italic">
                            No permissions assigned
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="px-6 py-4 bg-gray-50 border-t border-gray-200 flex gap-2">
                    <Button
                        @click="$inertia.visit(route('roles.edit', role.id))"
                        variant="outline"
                        size="sm"
                        class="flex-1"
                    >
                        Edit
                    </Button>
                    <Button
                        v-if="role.users_count === 0"
                        @click="deleteRole(role)"
                        variant="outline"
                        size="sm"
                        class="text-red-600 hover:text-red-700 hover:border-red-300"
                    >
                        Delete
                    </Button>
                    <Button
                        v-else
                        disabled
                        variant="outline"
                        size="sm"
                        class="text-gray-400 cursor-not-allowed"
                        title="Cannot delete role with assigned users"
                    >
                        Delete
                    </Button>
                </div>
            </div>
        </div>

        <!-- Empty State -->
        <div v-if="roles.length === 0" class="text-center py-12">
            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
            </svg>
            <h3 class="mt-2 text-sm font-medium text-gray-900">No roles</h3>
            <p class="mt-1 text-sm text-gray-500">Get started by creating a new role.</p>
            <div class="mt-6">
                <Button @click="$inertia.visit(route('roles.create'))">
                    <template #icon>
                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                        </svg>
                    </template>
                    Create Role
                </Button>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { router } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';
import Badge from '@/Components/Badge.vue';

const props = defineProps({
    roles: Array,
});

const getRoleBadgeVariant = (roleName) => {
    const variants = {
        'Super Admin': 'danger',
        'Pharmacist': 'success',
        'Store Manager': 'info',
        'Sales Staff': 'secondary',
    };
    return variants[roleName] || 'primary';
};

const deleteRole = (role) => {
    if (confirm(`Are you sure you want to delete the role "${role.name}"? This action cannot be undone.`)) {
        router.delete(route('roles.destroy', role.id));
    }
};
</script>

