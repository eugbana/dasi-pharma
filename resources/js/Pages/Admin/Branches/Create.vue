<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <div class="flex items-center gap-2 text-sm text-gray-500 mb-2">
                <button @click="$inertia.visit(route('admin.branches.index'))" class="hover:text-primary-600">Branches</button>
                <span>/</span>
                <span>Create</span>
            </div>
            <h1 class="text-2xl font-bold text-gray-900">Create Branch</h1>
        </div>

        <form @submit.prevent="submit">
            <div class="bg-white rounded-lg shadow">
                <div class="p-6 space-y-6">
                    <!-- Basic Information -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">
                                Branch Name <span class="text-red-500">*</span>
                            </label>
                            <input
                                v-model="form.name"
                                type="text"
                                class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                :class="{ 'border-red-500': form.errors.name }"
                                placeholder="e.g., Main Branch"
                            />
                            <p v-if="form.errors.name" class="mt-1 text-sm text-red-600">{{ form.errors.name }}</p>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">
                                Branch Code <span class="text-red-500">*</span>
                            </label>
                            <input
                                v-model="form.code"
                                type="text"
                                class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500 uppercase"
                                :class="{ 'border-red-500': form.errors.code }"
                                placeholder="e.g., MAIN"
                                maxlength="20"
                            />
                            <p v-if="form.errors.code" class="mt-1 text-sm text-red-600">{{ form.errors.code }}</p>
                            <p v-else class="mt-1 text-xs text-gray-500">Unique identifier for the branch</p>
                        </div>
                    </div>

                    <!-- Address -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Address <span class="text-red-500">*</span>
                        </label>
                        <textarea
                            v-model="form.address"
                            rows="3"
                            class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-red-500': form.errors.address }"
                            placeholder="Full branch address"
                        ></textarea>
                        <p v-if="form.errors.address" class="mt-1 text-sm text-red-600">{{ form.errors.address }}</p>
                    </div>

                    <!-- Contact Information -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Phone</label>
                            <input
                                v-model="form.phone"
                                type="tel"
                                class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                :class="{ 'border-red-500': form.errors.phone }"
                                placeholder="e.g., +234 800 000 0000"
                            />
                            <p v-if="form.errors.phone" class="mt-1 text-sm text-red-600">{{ form.errors.phone }}</p>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                            <input
                                v-model="form.email"
                                type="email"
                                class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                :class="{ 'border-red-500': form.errors.email }"
                                placeholder="e.g., branch@example.com"
                            />
                            <p v-if="form.errors.email" class="mt-1 text-sm text-red-600">{{ form.errors.email }}</p>
                        </div>
                    </div>

                    <!-- Status -->
                    <div>
                        <label class="flex items-center gap-2">
                            <input
                                v-model="form.is_active"
                                type="checkbox"
                                class="rounded border-gray-400 text-primary-600 focus:ring-primary-500"
                            />
                            <span class="text-sm font-medium text-gray-700">Active</span>
                        </label>
                        <p class="mt-1 text-xs text-gray-500">Inactive branches cannot process sales or transfers</p>
                    </div>
                </div>

                <!-- Actions -->
                <div class="px-6 py-4 bg-gray-50 border-t border-gray-200 flex justify-end gap-3">
                    <Button @click="$inertia.visit(route('admin.branches.index'))" variant="outline" type="button">
                        Cancel
                    </Button>
                    <Button type="submit" :disabled="form.processing">
                        {{ form.processing ? 'Creating...' : 'Create Branch' }}
                    </Button>
                </div>
            </div>
        </form>
    </AppLayout>
</template>

<script setup>
import { useForm } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';

const form = useForm({
    name: '',
    code: '',
    address: '',
    phone: '',
    email: '',
    is_active: true,
});

const submit = () => {
    form.post(route('admin.branches.store'));
};
</script>

