<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Create New Role</h1>
            <p class="mt-1 text-sm text-gray-500">
                Define a new role and assign permissions
            </p>
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
                        placeholder="e.g., Branch Manager"
                        class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
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
                        placeholder="Describe the responsibilities and scope of this role"
                        class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
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
                        {{ form.processing ? 'Creating...' : 'Create Role' }}
                    </Button>
                </div>
            </form>
        </div>

        <!-- Permission Preview -->
        <div v-if="form.permissions.length > 0" class="mt-6 bg-blue-50 rounded-lg p-6 border border-blue-200">
            <h3 class="text-sm font-medium text-blue-900 mb-3">Permission Preview</h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div v-for="(perms, module) in selectedPermissionsByModule" :key="module">
                    <h4 class="text-xs font-semibold text-blue-800 uppercase mb-2">{{ module }}</h4>
                    <ul class="space-y-1">
                        <li
                            v-for="perm in perms"
                            :key="perm.id"
                            class="text-xs text-blue-700"
                        >
                            {{ formatPermissionName(perm.name) }}
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
    permissions: Object,
});

const form = useForm({
    name: '',
    description: '',
    permissions: [],
});

const selectedPermissionsByModule = computed(() => {
    const result = {};
    
    Object.entries(props.permissions).forEach(([module, perms]) => {
        const selected = perms.filter(p => form.permissions.includes(p.id));
        if (selected.length > 0) {
            result[module] = selected;
        }
    });
    
    return result;
});

const formatPermissionName = (name) => {
    const parts = name.split('.');
    const action = parts[parts.length - 1];
    return action.split('_').map(word => 
        word.charAt(0).toUpperCase() + word.slice(1)
    ).join(' ');
};

const submit = () => {
    form.post(route('roles.store'));
};
</script>

