<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Create Stock Transfer</h1>
            <p class="mt-1 text-sm text-gray-500">
                Transfer stock items to another branch
            </p>
        </div>

        <!-- Form -->
        <div class="bg-white rounded-lg shadow p-6 max-w-4xl">
            <form @submit.prevent="submit">
                <div class="space-y-6">
                    <!-- Transfer Details -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Destination Branch -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">
                                Destination Branch <span class="text-danger-500">*</span>
                            </label>
                            <select
                                v-model="form.to_branch_id"
                                class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                :class="{ 'border-danger-500': form.errors.to_branch_id }"
                            >
                                <option value="">Select destination branch</option>
                                <option v-for="branch in branches" :key="branch.id" :value="branch.id">
                                    {{ branch.name }} ({{ branch.code }})
                                </option>
                            </select>
                            <p v-if="form.errors.to_branch_id" class="mt-1 text-sm text-danger-600">
                                {{ form.errors.to_branch_id }}
                            </p>
                        </div>

                        <!-- Transfer Date -->
                        <Input
                            v-model="form.transfer_date"
                            label="Transfer Date"
                            type="date"
                            required
                            :error="form.errors.transfer_date"
                        />
                    </div>

                    <!-- Notes -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Notes</label>
                        <textarea
                            v-model="form.notes"
                            rows="2"
                            class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            placeholder="Optional notes about this transfer..."
                        ></textarea>
                    </div>

                    <!-- Transfer Items -->
                    <div>
                        <div class="flex items-center justify-between mb-3">
                            <label class="block text-sm font-medium text-gray-900">
                                Transfer Items <span class="text-danger-500">*</span>
                            </label>
                            <Button type="button" variant="outline" size="sm" @click="addItem">
                                <svg class="h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                                </svg>
                                Add Item
                            </Button>
                        </div>

                        <p v-if="form.errors.items" class="mb-2 text-sm text-danger-600">
                            {{ form.errors.items }}
                        </p>

                        <!-- Items List -->
                        <div class="space-y-3">
                            <div
                                v-for="(item, index) in form.items"
                                :key="index"
                                class="flex items-start gap-3 p-4 bg-gray-50 rounded-lg"
                            >
                                <!-- Stock Item Selection -->
                                <div class="flex-1">
                                    <select
                                        v-model="item.stock_item_id"
                                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-sm"
                                        @change="onStockItemChange(index)"
                                    >
                                        <option value="">Select stock item</option>
                                        <option
                                            v-for="stockItem in availableStockItems(index)"
                                            :key="stockItem.id"
                                            :value="stockItem.id"
                                        >
                                            {{ stockItem.label }}
                                        </option>
                                    </select>
                                    <p v-if="form.errors[`items.${index}.stock_item_id`]" class="mt-1 text-xs text-danger-600">
                                        {{ form.errors[`items.${index}.stock_item_id`] }}
                                    </p>
                                    <p v-if="item.stock_item_id" class="mt-1 text-xs text-gray-600">
                                        Available: {{ getStockItemQuantity(item.stock_item_id) }} | 
                                        Expires: {{ getStockItemExpiry(item.stock_item_id) }}
                                    </p>
                                </div>

                                <!-- Quantity -->
                                <div class="w-32">
                                    <input
                                        v-model="item.quantity"
                                        type="number"
                                        min="1"
                                        :max="getStockItemQuantity(item.stock_item_id)"
                                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-sm"
                                        placeholder="Qty"
                                    />
                                    <p v-if="form.errors[`items.${index}.quantity`]" class="mt-1 text-xs text-danger-600">
                                        {{ form.errors[`items.${index}.quantity`] }}
                                    </p>
                                </div>

                                <!-- Remove Button -->
                                <button
                                    type="button"
                                    @click="removeItem(index)"
                                    class="mt-1 text-danger-600 hover:text-danger-900"
                                >
                                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <!-- Empty State -->
                        <div v-if="form.items.length === 0" class="text-center py-8 bg-gray-50 rounded-lg">
                            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                            </svg>
                            <p class="mt-2 text-sm text-gray-500">No items added yet. Click "Add Item" to start.</p>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex items-center justify-end space-x-3 pt-6 border-t">
                        <Button
                            type="button"
                            variant="outline"
                            @click="$inertia.visit(route('stock-transfers.index'))"
                            :disabled="form.processing"
                        >
                            Cancel
                        </Button>
                        <Button
                            type="submit"
                            :disabled="form.processing || form.items.length === 0"
                        >
                            <span v-if="!form.processing">Create Transfer</span>
                            <span v-else>Creating...</span>
                        </Button>
                    </div>
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
import Input from '@/Components/Input.vue';

const props = defineProps({
    branches: Array,
    stockItems: Array,
});

const form = useForm({
    to_branch_id: '',
    transfer_date: new Date().toISOString().split('T')[0],
    notes: '',
    items: [],
});

const addItem = () => {
    form.items.push({
        stock_item_id: '',
        quantity: '',
    });
};

const removeItem = (index) => {
    form.items.splice(index, 1);
};

const onStockItemChange = (index) => {
    // Reset quantity when stock item changes
    form.items[index].quantity = '';
};

const availableStockItems = (currentIndex) => {
    // Filter out already selected items (except current)
    const selectedIds = form.items
        .map((item, index) => index !== currentIndex ? item.stock_item_id : null)
        .filter(id => id !== null);

    return props.stockItems.filter(item => !selectedIds.includes(item.id));
};

const getStockItemQuantity = (stockItemId) => {
    const item = props.stockItems.find(i => i.id === stockItemId);
    return item ? item.quantity_available : 0;
};

const getStockItemExpiry = (stockItemId) => {
    const item = props.stockItems.find(i => i.id === stockItemId);
    if (!item) return '';
    return new Date(item.expiry_date).toLocaleDateString('en-NG', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
    });
};

const submit = () => {
    form.post(route('stock-transfers.store'), {
        onSuccess: () => {
            // Redirect handled by controller
        },
    });
};
</script>


