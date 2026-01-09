<template>
    <AppLayout title="Add Product">
        <template #header>
            <div class="flex items-center">
                <Link :href="route('products.index')" class="text-gray-500 hover:text-gray-700 mr-4">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                    </svg>
                </Link>
                <h2 class="text-xl font-semibold text-gray-800">Add New Product</h2>
            </div>
        </template>

        <div class="py-6">
            <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
                <form @submit.prevent="submit" class="bg-white rounded-lg shadow p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Brand Name -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Brand Name <span class="text-red-500">*</span></label>
                            <input v-model="form.brand_name" type="text" class="w-full rounded-lg border-gray-300 focus:border-primary-500 focus:ring-primary-500" />
                            <div v-if="form.errors.brand_name" class="text-red-500 text-sm mt-1">{{ form.errors.brand_name }}</div>
                        </div>

                        <!-- Generic Name -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Generic Name</label>
                            <input v-model="form.generic_name" type="text" class="w-full rounded-lg border-gray-300 focus:border-primary-500 focus:ring-primary-500" />
                        </div>

                        <!-- Category -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Category <span class="text-red-500">*</span></label>
                            <select v-model="form.category_id" @change="onCategoryChange" class="w-full rounded-lg border-gray-300 focus:border-primary-500 focus:ring-primary-500">
                                <option value="">Select Category</option>
                                <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                            </select>
                            <div v-if="form.errors.category_id" class="text-red-500 text-sm mt-1">{{ form.errors.category_id }}</div>
                        </div>

                        <!-- Subcategory -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Subcategory</label>
                            <select v-model="form.subcategory_id" class="w-full rounded-lg border-gray-300 focus:border-primary-500 focus:ring-primary-500" :disabled="!subcategories.length">
                                <option value="">Select Subcategory</option>
                                <option v-for="sub in subcategories" :key="sub.id" :value="sub.id">{{ sub.name }}</option>
                            </select>
                        </div>

                        <!-- Strength -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Strength</label>
                            <input v-model="form.strength" type="text" placeholder="e.g., 500mg" class="w-full rounded-lg border-gray-300 focus:border-primary-500 focus:ring-primary-500" />
                        </div>

                        <!-- Dosage Form -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Dosage Form</label>
                            <input v-model="form.dosage_form" type="text" placeholder="e.g., Tablet, Syrup" class="w-full rounded-lg border-gray-300 focus:border-primary-500 focus:ring-primary-500" />
                        </div>

                        <!-- Barcode -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Barcode</label>
                            <input v-model="form.barcode" type="text" class="w-full rounded-lg border-gray-300 focus:border-primary-500 focus:ring-primary-500 font-mono" />
                            <div v-if="form.errors.barcode" class="text-red-500 text-sm mt-1">{{ form.errors.barcode }}</div>
                        </div>

                        <!-- Manufacturer -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Manufacturer</label>
                            <input v-model="form.manufacturer" type="text" class="w-full rounded-lg border-gray-300 focus:border-primary-500 focus:ring-primary-500" />
                        </div>

                        <!-- Description -->
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                            <textarea v-model="form.description" rows="3" class="w-full rounded-lg border-gray-300 focus:border-primary-500 focus:ring-primary-500"></textarea>
                        </div>

                        <!-- Prescription Only -->
                        <div class="md:col-span-2">
                            <label class="flex items-center">
                                <input v-model="form.is_prescription_only" type="checkbox" class="rounded border-gray-300 text-primary-600 focus:ring-primary-500" />
                                <span class="ml-2 text-sm text-gray-700">Prescription Only (Rx)</span>
                            </label>
                        </div>
                    </div>

                    <div class="mt-6 flex justify-end space-x-3">
                        <Link :href="route('products.index')" class="btn btn-secondary">Cancel</Link>
                        <button type="submit" class="btn btn-primary" :disabled="form.processing">
                            {{ form.processing ? 'Saving...' : 'Save Product' }}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { computed } from 'vue';
import { Link, useForm } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';

const props = defineProps({
    categories: Array,
});

const form = useForm({
    brand_name: '',
    generic_name: '',
    category_id: '',
    subcategory_id: '',
    strength: '',
    dosage_form: '',
    barcode: '',
    manufacturer: '',
    description: '',
    is_prescription_only: false,
});

const subcategories = computed(() => {
    const cat = props.categories.find(c => c.id === parseInt(form.category_id));
    return cat?.subcategories || [];
});

const onCategoryChange = () => {
    form.subcategory_id = '';
};

const submit = () => {
    form.post(route('products.store'));
};
</script>

