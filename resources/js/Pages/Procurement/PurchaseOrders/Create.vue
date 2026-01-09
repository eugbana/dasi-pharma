<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Create Purchase Order</h1>
            <p class="mt-1 text-sm text-gray-500">
                Create a new purchase order for supplier
            </p>
        </div>

        <div class="bg-white rounded-lg shadow p-6">
            <form @submit.prevent="submitForm">
                <!-- Supplier Selection -->
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Supplier *</label>
                    <select
                        v-model="form.supplier_id"
                        required
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    >
                        <option value="">Select Supplier</option>
                        <option v-for="supplier in suppliers" :key="supplier.id" :value="supplier.id">
                            {{ supplier.name }}
                        </option>
                    </select>
                    <p v-if="form.errors.supplier_id" class="mt-1 text-sm text-red-600">{{ form.errors.supplier_id }}</p>
                </div>

                <!-- Order Details -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Order Date *</label>
                        <input
                            v-model="form.order_date"
                            type="date"
                            required
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        />
                        <p v-if="form.errors.order_date" class="mt-1 text-sm text-red-600">{{ form.errors.order_date }}</p>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Expected Delivery Date</label>
                        <input
                            v-model="form.expected_delivery_date"
                            type="date"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        />
                    </div>
                </div>

                <!-- Notes -->
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Notes</label>
                    <textarea
                        v-model="form.notes"
                        rows="3"
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        placeholder="Additional notes or instructions..."
                    ></textarea>
                </div>

                <!-- Line Items Section -->
                <div class="mb-6">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-gray-900">Order Items</h3>
                        <Button type="button" @click="addItem" variant="outline" size="sm">
                            <svg class="h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                            </svg>
                            Add Item
                        </Button>
                    </div>

                    <div class="space-y-4">
                        <div
                            v-for="(item, index) in form.items"
                            :key="index"
                            class="grid grid-cols-12 gap-4 p-4 border border-gray-200 rounded-lg"
                        >
                            <div class="col-span-4">
                                <label class="block text-xs font-medium text-gray-700 mb-1">Drug</label>
                                <select
                                    v-model="item.drug_id"
                                    required
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-sm"
                                >
                                    <option value="">Select Drug</option>
                                    <option v-for="drug in drugs" :key="drug.id" :value="drug.id">
                                        {{ drug.brand_name }} - {{ drug.strength }}
                                    </option>
                                </select>
                            </div>

                            <div class="col-span-2">
                                <label class="block text-xs font-medium text-gray-700 mb-1">Quantity</label>
                                <input
                                    v-model.number="item.quantity_ordered"
                                    type="number"
                                    min="1"
                                    required
                                    @input="calculateItemTotal(index)"
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-sm"
                                />
                            </div>

                            <div class="col-span-2">
                                <label class="block text-xs font-medium text-gray-700 mb-1">Unit Price</label>
                                <input
                                    v-model.number="item.unit_price"
                                    type="number"
                                    step="0.01"
                                    min="0"
                                    required
                                    @input="calculateItemTotal(index)"
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-sm"
                                />
                            </div>

                            <div class="col-span-3">
                                <label class="block text-xs font-medium text-gray-700 mb-1">Total</label>
                                <input
                                    :value="formatNumber(item.total || 0)"
                                    type="text"
                                    readonly
                                    class="w-full rounded-md border-gray-300 bg-gray-50 text-sm"
                                />
                            </div>

                            <div class="col-span-1 flex items-end">
                                <button
                                    type="button"
                                    @click="removeItem(index)"
                                    class="w-full px-3 py-2 text-red-600 hover:text-red-800 hover:bg-red-50 rounded-md"
                                >
                                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                    </svg>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div v-if="form.items.length === 0" class="text-center py-8 text-gray-500 border-2 border-dashed border-gray-300 rounded-lg">
                        No items added. Click "Add Item" to start.
                    </div>
                </div>

                <!-- Total -->
                <div class="flex justify-end mb-6">
                    <div class="w-64">
                        <div class="flex justify-between items-center py-2 border-t-2 border-gray-900">
                            <span class="text-lg font-semibold">Total:</span>
                            <span class="text-lg font-bold">₦{{ formatNumber(totalAmount) }}</span>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="flex justify-end gap-4">
                    <Button
                        type="button"
                        @click="$inertia.visit(route('purchase-orders.index'))"
                        variant="outline"
                        :disabled="form.processing"
                    >
                        Cancel
                    </Button>
                    <Button type="submit" :disabled="form.processing || form.items.length === 0">
                        Create Purchase Order
                    </Button>
                </div>
            </form>
        </div>
    </AppLayout>
</template>

<script setup>
import { computed } from 'vue';
import { useForm } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';

const props = defineProps({
    suppliers: Array,
    drugs: Array,
});

const form = useForm({
    supplier_id: '',
    order_date: new Date().toISOString().split('T')[0],
    expected_delivery_date: '',
    notes: '',
    items: [],
});

const totalAmount = computed(() => {
    return form.items.reduce((sum, item) => sum + (item.total || 0), 0);
});

const formatNumber = (value) => {
    return parseFloat(value || 0).toLocaleString('en-NG', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    });
};

const addItem = () => {
    form.items.push({
        drug_id: '',
        quantity_ordered: 1,
        unit_price: 0,
        total: 0,
    });
};

const removeItem = (index) => {
    form.items.splice(index, 1);
};

const calculateItemTotal = (index) => {
    const item = form.items[index];
    item.total = (item.quantity_ordered || 0) * (item.unit_price || 0);
};

const submitForm = () => {
    form.post(route('purchase-orders.store'));
};
</script>

