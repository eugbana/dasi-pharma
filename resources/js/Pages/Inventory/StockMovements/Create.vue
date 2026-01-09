<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Record Stock Adjustment</h1>
            <p class="mt-1 text-sm text-gray-500">
                Record manual stock adjustments, damages, or returns
            </p>
        </div>

        <!-- Form -->
        <div class="bg-white rounded-lg shadow p-6 max-w-2xl">
            <form @submit.prevent="submit">
                <div class="space-y-6">
                    <!-- Stock Item Selection -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Stock Item <span class="text-danger-500">*</span>
                        </label>
                        <select
                            v-model="form.stock_item_id"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-danger-500': form.errors.stock_item_id }"
                            @change="onStockItemChange"
                        >
                            <option value="">Select a stock item</option>
                            <option v-for="item in stockItems" :key="item.id" :value="item.id">
                                {{ item.label }}
                            </option>
                        </select>
                        <p v-if="form.errors.stock_item_id" class="mt-1 text-sm text-danger-600">
                            {{ form.errors.stock_item_id }}
                        </p>
                        <p v-if="selectedItem" class="mt-2 text-sm text-gray-600">
                            Current quantity: <span class="font-medium">{{ selectedItem.current_quantity }}</span>
                        </p>
                    </div>

                    <!-- Movement Type -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Movement Type <span class="text-danger-500">*</span>
                        </label>
                        <select
                            v-model="form.movement_type"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-danger-500': form.errors.movement_type }"
                        >
                            <option value="">Select type</option>
                            <option value="adjustment">Stock Adjustment</option>
                            <option value="expiry">Expiry/Damage</option>
                            <option value="return">Customer Return</option>
                        </select>
                        <p v-if="form.errors.movement_type" class="mt-1 text-sm text-danger-600">
                            {{ form.errors.movement_type }}
                        </p>
                    </div>

                    <!-- Quantity -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Quantity Change <span class="text-danger-500">*</span>
                        </label>
                        <input
                            v-model="form.quantity"
                            type="number"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-danger-500': form.errors.quantity }"
                            placeholder="Use negative for decrease, positive for increase"
                        />
                        <p v-if="form.errors.quantity" class="mt-1 text-sm text-danger-600">
                            {{ form.errors.quantity }}
                        </p>
                        <p class="mt-1 text-xs text-gray-500">
                            Enter negative number to decrease stock (e.g., -10 for damage), positive to increase (e.g., +5 for return)
                        </p>
                        <p v-if="selectedItem && form.quantity" class="mt-2 text-sm font-medium" :class="newQuantityClass">
                            New quantity will be: {{ newQuantity }}
                        </p>
                    </div>

                    <!-- Movement Date -->
                    <Input
                        v-model="form.movement_date"
                        label="Movement Date"
                        type="date"
                        required
                        :error="form.errors.movement_date"
                        :max="today"
                    />

                    <!-- Reason -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Reason <span class="text-danger-500">*</span>
                        </label>
                        <textarea
                            v-model="form.reason"
                            rows="3"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            :class="{ 'border-danger-500': form.errors.reason }"
                            placeholder="Explain the reason for this stock movement..."
                        ></textarea>
                        <p v-if="form.errors.reason" class="mt-1 text-sm text-danger-600">
                            {{ form.errors.reason }}
                        </p>
                    </div>

                    <!-- Warning for negative quantity -->
                    <div v-if="form.quantity && parseInt(form.quantity) < 0" class="bg-warning-50 border border-warning-200 rounded-md p-4">
                        <div class="flex">
                            <svg class="h-5 w-5 text-warning-400" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                            </svg>
                            <div class="ml-3">
                                <h3 class="text-sm font-medium text-warning-800">Stock Decrease</h3>
                                <p class="mt-1 text-sm text-warning-700">
                                    This will reduce the available stock. Make sure the reason is clearly documented.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex items-center justify-end space-x-3 pt-6 border-t">
                        <Button
                            type="button"
                            variant="outline"
                            @click="$inertia.visit(route('stock-movements.index'))"
                            :disabled="form.processing"
                        >
                            Cancel
                        </Button>
                        <Button
                            type="submit"
                            :disabled="form.processing"
                        >
                            <span v-if="!form.processing">Record Movement</span>
                            <span v-else class="flex items-center">
                                <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                </svg>
                                Recording...
                            </span>
                        </Button>
                    </div>
                </div>
            </form>
        </div>
    </AppLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useForm } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';
import Input from '@/Components/Input.vue';

const props = defineProps({
    stockItems: Array,
});

const selectedItem = ref(null);
const today = new Date().toISOString().split('T')[0];

const form = useForm({
    stock_item_id: '',
    movement_type: '',
    quantity: '',
    movement_date: today,
    reason: '',
});

const onStockItemChange = () => {
    selectedItem.value = props.stockItems.find(item => item.id === parseInt(form.stock_item_id));
};

const newQuantity = computed(() => {
    if (!selectedItem.value || !form.quantity) return 0;
    return selectedItem.value.current_quantity + parseInt(form.quantity);
});

const newQuantityClass = computed(() => {
    const qty = newQuantity.value;
    if (qty < 0) return 'text-danger-600';
    if (qty === 0) return 'text-warning-600';
    return 'text-success-600';
});

const submit = () => {
    form.post(route('stock-movements.store'), {
        onSuccess: () => {
            // Redirect handled by controller
        },
    });
};
</script>


