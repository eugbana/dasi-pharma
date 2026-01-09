<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Create Goods Received Note</h1>
            <p class="mt-1 text-sm text-gray-500">
                Record receipt of goods from supplier
            </p>
        </div>

        <div class="bg-white rounded-lg shadow p-6">
            <form @submit.prevent="submitForm">
                <!-- Purchase Order Selection -->
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Purchase Order *</label>
                    <select
                        v-model="form.purchase_order_id"
                        @change="loadPOItems"
                        required
                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                    >
                        <option value="">Select Purchase Order</option>
                        <option v-for="po in purchaseOrders" :key="po.id" :value="po.id">
                            {{ po.order_number }} - {{ po.supplier?.name }} ({{ formatDate(po.order_date) }})
                        </option>
                    </select>
                    <p v-if="form.errors.purchase_order_id" class="mt-1 text-sm text-red-600">
                        {{ form.errors.purchase_order_id }}
                    </p>
                </div>

                <!-- Receipt Details -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Received Date *</label>
                        <input
                            v-model="form.received_date"
                            type="date"
                            required
                            :max="today"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        />
                        <p v-if="form.errors.received_date" class="mt-1 text-sm text-red-600">
                            {{ form.errors.received_date }}
                        </p>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Notes</label>
                        <input
                            v-model="form.notes"
                            type="text"
                            placeholder="Delivery notes, condition, etc."
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                        />
                    </div>
                </div>

                <!-- Items Section -->
                <div v-if="selectedPO" class="mb-6">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-gray-900">Received Items</h3>
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
                            <div class="col-span-3">
                                <label class="block text-xs font-medium text-gray-700 mb-1">Drug *</label>
                                <select
                                    v-model="item.drug_id"
                                    required
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-sm"
                                >
                                    <option value="">Select Drug</option>
                                    <option v-for="poItem in selectedPO.items" :key="poItem.drug_id" :value="poItem.drug_id">
                                        {{ poItem.drug?.brand_name }} - {{ poItem.drug?.strength }}
                                    </option>
                                </select>
                            </div>

                            <div class="col-span-2">
                                <label class="block text-xs font-medium text-gray-700 mb-1">Batch Number *</label>
                                <input
                                    v-model="item.batch_number"
                                    type="text"
                                    required
                                    placeholder="Batch #"
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-sm"
                                />
                            </div>

                            <div class="col-span-2">
                                <label class="block text-xs font-medium text-gray-700 mb-1">Expiry Date *</label>
                                <input
                                    v-model="item.expiry_date"
                                    type="date"
                                    required
                                    :min="tomorrow"
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-sm"
                                />
                            </div>

                            <div class="col-span-1">
                                <label class="block text-xs font-medium text-gray-700 mb-1">Qty *</label>
                                <input
                                    v-model.number="item.quantity_received"
                                    type="number"
                                    min="1"
                                    required
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-sm"
                                />
                            </div>

                            <div class="col-span-2">
                                <label class="block text-xs font-medium text-gray-700 mb-1">Unit Price *</label>
                                <input
                                    v-model.number="item.unit_price"
                                    type="number"
                                    step="0.01"
                                    min="0"
                                    required
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-sm"
                                />
                            </div>

                            <div class="col-span-1">
                                <label class="block text-xs font-medium text-gray-700 mb-1">Mfg Date</label>
                                <input
                                    v-model="item.manufacturing_date"
                                    type="date"
                                    :max="today"
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-sm"
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
                        No items added. Click "Add Item" to record received goods.
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="flex justify-end gap-4">
                    <Button
                        type="button"
                        @click="$inertia.visit(route('goods-received-notes.index'))"
                        variant="outline"
                        :disabled="form.processing"
                    >
                        Cancel
                    </Button>
                    <Button type="submit" :disabled="form.processing || form.items.length === 0 || !form.purchase_order_id">
                        Create GRN
                    </Button>
                </div>
            </form>
        </div>
    </AppLayout>
</template>

<script setup>
import { computed, ref } from 'vue';
import { useForm } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';

const props = defineProps({
    purchaseOrders: Array,
});

const selectedPO = ref(null);
const today = new Date().toISOString().split('T')[0];
const tomorrow = new Date(Date.now() + 86400000).toISOString().split('T')[0];

const form = useForm({
    purchase_order_id: '',
    received_date: today,
    notes: '',
    items: [],
});

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-NG');
};

const loadPOItems = () => {
    selectedPO.value = props.purchaseOrders.find(po => po.id === form.purchase_order_id);
    form.items = [];
};

const addItem = () => {
    form.items.push({
        drug_id: '',
        batch_number: '',
        manufacturing_date: '',
        expiry_date: '',
        quantity_received: 1,
        unit_price: 0,
    });
};

const removeItem = (index) => {
    form.items.splice(index, 1);
};

const submitForm = () => {
    form.post(route('goods-received-notes.store'));
};
</script>

