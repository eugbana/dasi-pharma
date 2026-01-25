<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Edit User</h1>
            <p class="mt-1 text-sm text-gray-500">
                Update user account details
            </p>
        </div>

        <!-- Form -->
        <div class="bg-white rounded-lg shadow">
            <form @submit.prevent="submit" class="p-6 space-y-6">
                <!-- Name -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                        Full Name <span class="text-red-500">*</span>
                    </label>
                    <input
                        v-model="form.name"
                        type="text"
                        required
                        class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        :class="{ 'border-red-500': form.errors.name }"
                    />
                    <p v-if="form.errors.name" class="mt-1 text-sm text-red-600">{{ form.errors.name }}</p>
                </div>

                <!-- Email -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                        Email Address <span class="text-red-500">*</span>
                    </label>
                    <input
                        v-model="form.email"
                        type="email"
                        required
                        class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        :class="{ 'border-red-500': form.errors.email }"
                    />
                    <p v-if="form.errors.email" class="mt-1 text-sm text-red-600">{{ form.errors.email }}</p>
                </div>

                <!-- Password (Optional) -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            New Password <span class="text-gray-500">(leave blank to keep current)</span>
                        </label>
                        <input
                            v-model="form.password"
                            type="password"
                            class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-red-500': form.errors.password }"
                        />
                        <p v-if="form.errors.password" class="mt-1 text-sm text-red-600">{{ form.errors.password }}</p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Confirm New Password
                        </label>
                        <input
                            v-model="form.password_confirmation"
                            type="password"
                            class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        />
                    </div>
                </div>

                <!-- Role and Branch -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Role <span class="text-red-500">*</span>
                        </label>
                        <select
                            v-model="form.role_id"
                            required
                            class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-red-500': form.errors.role_id }"
                        >
                            <option value="">Select Role</option>
                            <option v-for="role in roles" :key="role.id" :value="role.id">
                                {{ role.name }} ({{ role.permissions_count }} permissions)
                            </option>
                        </select>
                        <p v-if="form.errors.role_id" class="mt-1 text-sm text-red-600">{{ form.errors.role_id }}</p>
                        <p v-if="selectedRole" class="mt-1 text-xs text-gray-500">
                            {{ selectedRole.description }}
                        </p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Branch <span class="text-red-500">*</span>
                        </label>
                        <select
                            v-model="form.branch_id"
                            required
                            class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-red-500': form.errors.branch_id }"
                        >
                            <option value="">Select Branch</option>
                            <option v-for="branch in branches" :key="branch.id" :value="branch.id">
                                {{ branch.name }} ({{ branch.code }})
                            </option>
                        </select>
                        <p v-if="form.errors.branch_id" class="mt-1 text-sm text-red-600">{{ form.errors.branch_id }}</p>
                    </div>
                </div>

                <!-- Active Status -->
                <div class="flex items-center">
                    <input
                        v-model="form.is_active"
                        type="checkbox"
                        id="is_active"
                        class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-400 rounded"
                    />
                    <label for="is_active" class="ml-2 block text-sm text-gray-900">
                        Active (user can log in)
                    </label>
                </div>

                <!-- Authorization Code Section -->
                <div class="p-4 bg-amber-50 rounded-lg border border-amber-200">
                    <h3 class="text-sm font-medium text-amber-900 mb-3 flex items-center">
                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                        </svg>
                        Authorization Code Settings
                    </h3>
                    <p class="text-xs text-amber-700 mb-4">
                        Enable a 6-digit PIN for quick authorization of sensitive operations like returns, discounts, and void transactions.
                    </p>

                    <div class="flex items-center mb-4">
                        <input
                            v-model="form.can_authorize"
                            type="checkbox"
                            id="can_authorize"
                            class="h-4 w-4 text-amber-600 focus:ring-amber-500 border-gray-400 rounded"
                        />
                        <label for="can_authorize" class="ml-2 block text-sm text-amber-900">
                            Can authorize sensitive operations
                        </label>
                    </div>

                    <div v-if="form.can_authorize" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-amber-800 mb-1">
                                Authorization Code (6 digits)
                            </label>
                            <div class="flex gap-2">
                                <input
                                    v-model="form.authorization_code"
                                    type="text"
                                    maxlength="6"
                                    pattern="[0-9]{6}"
                                    placeholder="e.g., 123456"
                                    class="flex-1 rounded-md border-amber-300 shadow-sm focus:border-amber-500 focus:ring-amber-500 font-mono text-lg tracking-widest text-center"
                                    :class="{ 'border-red-500': form.errors.authorization_code }"
                                />
                                <button
                                    type="button"
                                    @click="generateCode"
                                    class="px-3 py-2 bg-amber-600 text-white rounded-md hover:bg-amber-700 text-sm"
                                    title="Generate random code"
                                >
                                    Generate
                                </button>
                            </div>
                            <p v-if="form.errors.authorization_code" class="mt-1 text-sm text-red-600">
                                {{ form.errors.authorization_code }}
                            </p>
                            <p class="mt-1 text-xs text-amber-600">
                                This code will be used instead of password for quick authorizations.
                            </p>
                        </div>
                        <div class="flex items-center">
                            <div v-if="form.authorization_code && form.authorization_code.length === 6" class="p-3 bg-white rounded-lg border border-amber-200">
                                <p class="text-xs text-amber-700 mb-1">Current Code:</p>
                                <p class="font-mono text-2xl font-bold text-amber-900 tracking-widest">
                                    {{ form.authorization_code }}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="flex justify-end gap-3 pt-4 border-t border-gray-200">
                    <Button
                        type="button"
                        @click="$inertia.visit(route('users.index'))"
                        variant="outline"
                    >
                        Cancel
                    </Button>
                    <Button
                        type="submit"
                        :disabled="form.processing"
                    >
                        {{ form.processing ? 'Updating...' : 'Update User' }}
                    </Button>
                </div>
            </form>
        </div>

        <!-- Role Permissions Preview -->
        <div v-if="selectedRole && selectedRole.permissions_count > 0" class="mt-6 bg-blue-50 rounded-lg p-6 border border-blue-200">
            <h3 class="text-sm font-medium text-blue-900 mb-3">
                {{ selectedRole.name }} Permissions ({{ selectedRole.permissions_count }})
            </h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div v-for="(perms, module) in selectedRole.permissions" :key="module">
                    <h4 class="text-xs font-semibold text-blue-800 uppercase mb-2">{{ module }}</h4>
                    <ul class="space-y-1">
                        <li
                            v-for="perm in perms"
                            :key="perm.id"
                            class="text-xs text-blue-700"
                            :title="perm.description"
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

const props = defineProps({
    user: Object,
    roles: Array,
    branches: Array,
});

const form = useForm({
    name: props.user.name,
    email: props.user.email,
    password: '',
    password_confirmation: '',
    role_id: props.user.role_id,
    branch_id: props.user.branch_id,
    is_active: props.user.is_active,
    can_authorize: props.user.can_authorize || false,
    authorization_code: props.user.authorization_code || '',
});

const selectedRole = computed(() => {
    return props.roles.find(role => role.id === form.role_id);
});

const formatPermissionName = (name) => {
    const parts = name.split('.');
    const action = parts[parts.length - 1];
    return action.split('_').map(word =>
        word.charAt(0).toUpperCase() + word.slice(1)
    ).join(' ');
};

const generateCode = () => {
    // Generate random 6-digit code
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    form.authorization_code = code;
};

const submit = () => {
    form.put(route('users.update', props.user.id));
};
</script>

