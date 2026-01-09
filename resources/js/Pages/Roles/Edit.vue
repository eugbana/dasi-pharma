<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Edit Role: {{ role.name }}</h1>
            <p class="mt-1 text-sm text-gray-500">
                Modify role details and permission assignments
            </p>
        </div>

        <!-- User Warning -->
        <div v-if="users_count > 0" class="mb-6 bg-yellow-50 border border-yellow-200 rounded-lg p-4">
            <div class="flex">
                <svg class="h-5 w-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                </svg>
                <div class="ml-3">
                    <h3 class="text-sm font-medium text-yellow-800">
                        This role is assigned to {{ users_count }} {{ users_count === 1 ? 'user' : 'users' }}
                    </h3>
                    <p class="mt-1 text-sm text-yellow-700">
                        Changes to permissions will affect all users with this role.
                    </p>
                </div>
            </div>
        </div>

        <!-- Form -->
        <div class="bg-white rounded-lg shadow">
            <form @submit.prevent="submit" class="p-6 space-y-6">
                <!-- Role Name -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                        Role Name <span class="text-red-500">*</span>
                    </label>
                    <input
                        v-model="form.name"
                        type="text"
                        required
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        :class="{ 'border-red-500': form.errors.name }"
                    />
                    <p v-if="form.errors.name" class="mt-1 text-sm text-red-600">{{ form.errors.name }}</p>
                </div>

                <!-- Description -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                        Description
                    </label>
                    <textarea
                        v-model="form.description"
                        rows="3"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        :class="{ 'border-red-500': form.errors.description }"
                    ></textarea>
                    <p v-if="form.errors.description" class="mt-1 text-sm text-red-600">{{ form.errors.description }}</p>
                </div>

                <!-- Permissions -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-3">
                        Permissions
                    </label>
                    <PermissionSelector
                        v-model="form.permissions"
                        :permissions="permissions"
                    />
                    <p v-if="form.errors.permissions" class="mt-1 text-sm text-red-600">{{ form.errors.permissions }}</p>
                </div>

                <!-- Actions -->
                <div class="flex justify-end gap-3 pt-4 border-t border-gray-200">
                    <Button
                        type="button"
                        @click="$inertia.visit(route('roles.index'))"
                        variant="outline"
                    >
                        Cancel
                    </Button>
                    <Button
                        type="submit"
                        :disabled="form.processing"
                    >
                        {{ form.processing ? 'Updating...' : 'Update Role' }}
                    </Button>
                </div>
            </form>
        </div>

        <!-- Permission Changes Preview -->
        <div v-if="hasChanges" class="mt-6 bg-blue-50 rounded-lg p-6 border border-blue-200">
            <h3 class="text-sm font-medium text-blue-900 mb-3">Permission Changes</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <!-- Added Permissions -->
                <div v-if="addedPermissions.length > 0">
                    <h4 class="text-xs font-semibold text-green-800 uppercase mb-2">
                        Added ({{ addedPermissions.length }})
                    </h4>
                    <ul class="space-y-1">
                        <li
                            v-for="perm in addedPermissions"
                            :key="perm.id"
                            class="text-xs text-green-700 flex items-center"
                        >
                            <svg class="h-3 w-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                            </svg>
                            {{ perm.description }}
                        </li>
                    </ul>
                </div>

                <!-- Removed Permissions -->
                <div v-if="removedPermissions.length > 0">
                    <h4 class="text-xs font-semibold text-red-800 uppercase mb-2">
                        Removed ({{ removedPermissions.length }})
                    </h4>
                    <ul class="space-y-1">
                        <li
                            v-for="perm in removedPermissions"
                            :key="perm.id"
                            class="text-xs text-red-700 flex items-center"
                        >
                            <svg class="h-3 w-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                            </svg>
                            {{ perm.description }}
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { computed } from 'vue';
import { useForm } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';
import PermissionSelector from '@/Components/PermissionSelector.vue';

const props = defineProps({
    role: Object,
    permissions: Object,
    users_count: Number,
});

// Ensure permission_ids are integers for proper comparison
const initialPermissionIds = (props.role.permission_ids || []).map(id => parseInt(id));

const form = useForm({
    name: props.role.name,
    description: props.role.description,
    permissions: initialPermissionIds,
});

const allPermissions = computed(() => {
    return Object.values(props.permissions).flat();
});

const hasChanges = computed(() => {
    return addedPermissions.value.length > 0 || removedPermissions.value.length > 0;
});

const addedPermissions = computed(() => {
    const added = form.permissions.filter(id => !initialPermissionIds.includes(id));
    return allPermissions.value.filter(p => added.includes(p.id));
});

const removedPermissions = computed(() => {
    const removed = initialPermissionIds.filter(id => !form.permissions.includes(id));
    return allPermissions.value.filter(p => removed.includes(p.id));
});

const submit = () => {
    form.put(route('roles.update', props.role.id));
};
</script>

