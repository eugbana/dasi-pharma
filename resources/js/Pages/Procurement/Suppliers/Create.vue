<template>
    <AppLayout>
        <div class="max-w-3xl mx-auto">
            <!-- Page Header -->
            <div class="mb-6">
                <h1 class="text-2xl font-bold text-gray-900">Add New Supplier</h1>
                <p class="mt-1 text-sm text-gray-500">
                    Enter supplier information to add them to your vendor list
                </p>
            </div>

            <!-- Form -->
            <form @submit.prevent="submit" class="bg-white rounded-lg shadow p-6 space-y-6">
                <!-- Basic Information -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Supplier Name <span class="text-red-500">*</span>
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

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Contact Person</label>
                        <input
                            v-model="form.contact_person"
                            type="text"
                            class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        />
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Phone <span class="text-red-500">*</span>
                        </label>
                        <input
                            v-model="form.phone"
                            type="tel"
                            required
                            class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-red-500': form.errors.phone }"
                        />
                        <p v-if="form.errors.phone" class="mt-1 text-sm text-red-600">{{ form.errors.phone }}</p>
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                        <input
                            v-model="form.email"
                            type="email"
                            class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-red-500': form.errors.email }"
                        />
                        <p v-if="form.errors.email" class="mt-1 text-sm text-red-600">{{ form.errors.email }}</p>
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Address</label>
                        <textarea
                            v-model="form.address"
                            rows="3"
                            class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        ></textarea>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Payment Terms</label>
                        <input
                            v-model="form.payment_terms"
                            type="text"
                            placeholder="e.g., Net 30 days"
                            class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        />
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Delivery Days</label>
                        <input
                            v-model="form.delivery_days"
                            type="number"
                            min="1"
                            placeholder="e.g., 7"
                            class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        />
                    </div>

                    <div class="md:col-span-2">
                        <label class="flex items-center">
                            <input
                                v-model="form.is_active"
                                type="checkbox"
                                class="rounded border-gray-400 text-primary-600 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            />
                            <span class="ml-2 text-sm text-gray-700">Active Supplier</span>
                        </label>
                    </div>
                </div>

                <!-- Actions -->
                <div class="flex justify-end gap-3 pt-4 border-t">
                    <Button
                        type="button"
                        @click="$inertia.visit(route('suppliers.index'))"
                        variant="outline"
                        :disabled="form.processing"
                    >
                        Cancel
                    </Button>
                    <Button
                        type="submit"
                        :disabled="form.processing"
                    >
                        <span v-if="form.processing">Creating...</span>
                        <span v-else>Create Supplier</span>
                    </Button>
                </div>
            </form>
        </div>
    </AppLayout>
</template>

<script setup>
import { useForm } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';

const form = useForm({
    name: '',
    contact_person: '',
    phone: '',
    email: '',
    address: '',
    payment_terms: '',
    delivery_days: null,
    is_active: true,
});

const submit = () => {
    form.post(route('suppliers.store'));
};
</script>

