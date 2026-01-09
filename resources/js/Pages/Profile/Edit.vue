<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">My Profile</h1>
            <p class="mt-1 text-sm text-gray-500">
                Manage your account settings and authorization code
            </p>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Profile Information -->
            <div class="bg-white rounded-lg shadow">
                <div class="p-6 border-b border-gray-200">
                    <h2 class="text-lg font-medium text-gray-900">Profile Information</h2>
                    <p class="mt-1 text-sm text-gray-500">Update your account's profile information.</p>
                </div>
                <form @submit.prevent="submitProfile" class="p-6 space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Full Name</label>
                        <input v-model="profileForm.name" type="text" required 
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-red-500': profileForm.errors.name }"/>
                        <p v-if="profileForm.errors.name" class="mt-1 text-sm text-red-600">{{ profileForm.errors.name }}</p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Email Address</label>
                        <input v-model="profileForm.email" type="email" required 
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-red-500': profileForm.errors.email }"/>
                        <p v-if="profileForm.errors.email" class="mt-1 text-sm text-red-600">{{ profileForm.errors.email }}</p>
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 pt-4 border-t">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Role</label>
                            <p class="text-sm text-gray-900">{{ user.role?.name || 'N/A' }}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Branch</label>
                            <p class="text-sm text-gray-900">{{ user.branch?.name || 'N/A' }}</p>
                        </div>
                    </div>
                    <div class="flex justify-end pt-4">
                        <Button type="submit" :disabled="profileForm.processing">
                            {{ profileForm.processing ? 'Saving...' : 'Save Changes' }}
                        </Button>
                    </div>
                </form>
            </div>

            <!-- Change Password -->
            <div class="bg-white rounded-lg shadow">
                <div class="p-6 border-b border-gray-200">
                    <h2 class="text-lg font-medium text-gray-900">Change Password</h2>
                    <p class="mt-1 text-sm text-gray-500">Ensure your account uses a strong password.</p>
                </div>
                <form @submit.prevent="submitPassword" class="p-6 space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Current Password</label>
                        <input v-model="passwordForm.current_password" type="password" required 
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-red-500': passwordForm.errors.current_password }"/>
                        <p v-if="passwordForm.errors.current_password" class="mt-1 text-sm text-red-600">{{ passwordForm.errors.current_password }}</p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">New Password</label>
                        <input v-model="passwordForm.password" type="password" required 
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-red-500': passwordForm.errors.password }"/>
                        <p v-if="passwordForm.errors.password" class="mt-1 text-sm text-red-600">{{ passwordForm.errors.password }}</p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Confirm New Password</label>
                        <input v-model="passwordForm.password_confirmation" type="password" required 
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"/>
                    </div>
                    <div class="flex justify-end pt-4">
                        <Button type="submit" :disabled="passwordForm.processing">
                            {{ passwordForm.processing ? 'Updating...' : 'Update Password' }}
                        </Button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Authorization Code Section (only for users with authorizable roles) -->
        <div v-if="user.can_set_auth_code" class="mt-6 bg-white rounded-lg shadow">
            <div class="p-6 border-b border-amber-200 bg-amber-50 rounded-t-lg">
                <div class="flex items-center">
                    <svg class="w-6 h-6 text-amber-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                    </svg>
                    <div>
                        <h2 class="text-lg font-medium text-amber-900">Authorization Code</h2>
                        <p class="mt-1 text-sm text-amber-700">
                            Set your 6-digit PIN for quick authorization of sensitive operations like returns and discounts.
                        </p>
                    </div>
                </div>
            </div>
            <div class="p-6">
                <!-- Current Status -->
                <div class="mb-6 p-4 rounded-lg" :class="user.has_authorization_code ? 'bg-green-50 border border-green-200' : 'bg-yellow-50 border border-yellow-200'">
                    <div class="flex items-center">
                        <svg v-if="user.has_authorization_code" class="w-5 h-5 text-green-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        <svg v-else class="w-5 h-5 text-yellow-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                        </svg>
                        <span :class="user.has_authorization_code ? 'text-green-700' : 'text-yellow-700'" class="text-sm font-medium">
                            {{ user.has_authorization_code ? 'Authorization code is set' : 'No authorization code set' }}
                        </span>
                    </div>
                </div>

                <!-- Set/Update Code Form -->
                <div class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">New Authorization Code (6 digits)</label>
                        <div class="flex gap-2">
                            <input
                                v-model="authCodeForm.authorization_code"
                                type="password"
                                maxlength="6"
                                pattern="[0-9]{6}"
                                placeholder="••••••"
                                class="flex-1 rounded-md border-gray-300 shadow-sm focus:border-amber-500 focus:ring-amber-500 font-mono text-xl tracking-widest text-center"
                                :class="{ 'border-red-500': authCodeError }"
                            />
                            <button
                                type="button"
                                @click="generateCode"
                                class="px-4 py-2 bg-amber-100 text-amber-700 rounded-md hover:bg-amber-200 text-sm font-medium"
                                title="Generate random code"
                            >
                                Generate
                            </button>
                        </div>
                        <p class="mt-1 text-xs text-gray-500">Enter a 6-digit numeric code that you can easily remember.</p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Confirm with Current Password</label>
                        <input
                            v-model="authCodeForm.current_password"
                            type="password"
                            placeholder="Enter your current password"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-amber-500 focus:ring-amber-500"
                        />
                        <p class="mt-1 text-xs text-gray-500">For security, enter your password to confirm this change.</p>
                    </div>
                    <p v-if="authCodeError" class="text-sm text-red-600">{{ authCodeError }}</p>
                    <p v-if="authCodeSuccess" class="text-sm text-green-600">{{ authCodeSuccess }}</p>
                    <div class="flex justify-end pt-4">
                        <Button
                            @click="submitAuthCode"
                            :disabled="authCodeLoading || authCodeForm.authorization_code.length !== 6 || !authCodeForm.current_password"
                            class="bg-amber-600 hover:bg-amber-700"
                        >
                            {{ authCodeLoading ? 'Saving...' : 'Update Authorization Code' }}
                        </Button>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { ref, reactive } from 'vue';
import { useForm, router } from '@inertiajs/vue3';
import axios from 'axios';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';

const props = defineProps({
    user: Object,
});

const profileForm = useForm({
    name: props.user.name,
    email: props.user.email,
});

const passwordForm = useForm({
    current_password: '',
    password: '',
    password_confirmation: '',
});

// Authorization code form
const authCodeForm = reactive({
    authorization_code: '',
    current_password: '',
});
const authCodeLoading = ref(false);
const authCodeError = ref('');
const authCodeSuccess = ref('');

const submitProfile = () => {
    profileForm.put(route('profile.update'), {
        preserveScroll: true,
    });
};

const submitPassword = () => {
    passwordForm.put(route('profile.update'), {
        preserveScroll: true,
        onSuccess: () => passwordForm.reset(),
    });
};

const generateCode = () => {
    // Generate random 6-digit code
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    authCodeForm.authorization_code = code;
};

const submitAuthCode = async () => {
    if (authCodeForm.authorization_code.length !== 6 || !authCodeForm.current_password) return;

    authCodeLoading.value = true;
    authCodeError.value = '';
    authCodeSuccess.value = '';

    try {
        const response = await axios.post(route('profile.authorization-code'), {
            authorization_code: authCodeForm.authorization_code,
            current_password: authCodeForm.current_password,
        });

        if (response.data.success) {
            authCodeSuccess.value = response.data.message;
            authCodeForm.authorization_code = '';
            authCodeForm.current_password = '';
            // Reload page to update status
            router.reload({ only: ['user'] });
        } else {
            authCodeError.value = response.data.message;
        }
    } catch (error) {
        authCodeError.value = error.response?.data?.message || 'Failed to update authorization code.';
    } finally {
        authCodeLoading.value = false;
    }
};
</script>

