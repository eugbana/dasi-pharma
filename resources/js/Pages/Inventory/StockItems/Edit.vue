<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Edit Stock Item</h1>
            <p class="mt-1 text-sm text-gray-500">
                Update stock item pricing and inventory levels
            </p>
        </div>

        <!-- Stock Item Info -->
        <div class="bg-white rounded-lg shadow p-6 mb-6">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <div>
                    <label class="block text-xs font-medium text-gray-500 uppercase">Product</label>
                    <p class="text-lg font-semibold text-gray-900">{{ stockItem.drug?.brand_name }}</p>
                    <p class="text-sm text-gray-600">{{ stockItem.drug?.generic_name }}</p>
                </div>
                <div>
                    <label class="block text-xs font-medium text-gray-500 uppercase">Batch Number</label>
                    <p class="text-lg font-medium text-gray-900">{{ stockItem.batch_number }}</p>
                </div>
                <div>
                    <label class="block text-xs font-medium text-gray-500 uppercase">Expiry Date</label>
                    <p class="text-lg font-medium" :class="expiryClass">{{ formatDate(stockItem.expiry_date) }}</p>
                    <p class="text-sm" :class="expiryClass">{{ expiryStatus }}</p>
                </div>
                <div>
                    <label class="block text-xs font-medium text-gray-500 uppercase">Current Stock</label>
                    <p class="text-lg font-semibold" :class="stockClass">{{ stockItem.quantity_available }} units</p>
                </div>
            </div>
        </div>

        <!-- Edit Form -->
        <div class="bg-white rounded-lg shadow p-6 max-w-2xl">
            <form @submit.prevent="submit">
                <div class="space-y-6">
                    <!-- Pricing with Markup Calculator -->
                    <div class="p-4 bg-green-50 rounded-lg border border-green-200">
                        <h3 class="text-sm font-medium text-green-900 mb-4">Pricing & Markup</h3>
                        
                        <div class="mb-4">
                            <label class="block text-sm font-medium text-gray-700 mb-1">
                                Purchase Price (₦) <span class="text-gray-500">(read-only)</span>
                            </label>
                            <input
                                :value="stockItem.purchase_price"
                                type="number"
                                disabled
                                class="w-full rounded-md border-gray-300 bg-gray-100 shadow-sm"
                            />
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">
                                    Markup %
                                </label>
                                <input
                                    v-model="markupInput"
                                    type="number"
                                    step="0.1"
                                    min="0"
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                    placeholder="e.g., 25"
                                    @input="calculateSellingPrice"
                                />
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">
                                    Selling Price (₦) <span class="text-danger-500">*</span>
                                </label>
                                <input
                                    v-model="form.selling_price"
                                    type="number"
                                    step="0.01"
                                    min="0"
                                    required
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                    :class="{ 'border-red-500': form.errors.selling_price }"
                                    @input="updateMarkupFromPrice"
                                />
                                <p v-if="form.errors.selling_price" class="mt-1 text-xs text-danger-600">
                                    {{ form.errors.selling_price }}
                                </p>
                            </div>
                        </div>

                        <!-- Markup Summary -->
                        <div class="mt-4 pt-3 border-t border-green-200">
                            <div class="flex items-center justify-between text-sm">
                                <span class="text-gray-700">Current Markup:</span>
                                <span :class="markupClass" class="font-bold text-lg">{{ calculatedMarkup }}%</span>
                            </div>
                            <div class="flex items-center justify-between text-sm mt-1">
                                <span class="text-gray-700">Profit per unit:</span>
                                <span class="font-medium text-green-700">₦{{ profitPerUnit }}</span>
                            </div>
                        </div>

                        <!-- VAT Applicable Checkbox -->
                        <div class="mt-4 pt-3 border-t border-green-200">
                            <label class="flex items-center">
                                <input
                                    v-model="form.vat_applicable"
                                    type="checkbox"
                                    class="rounded border-gray-300 text-primary-600 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                />
                                <span class="ml-2 text-sm text-gray-700">VAT Applicable</span>
                            </label>
                            <p class="mt-1 text-xs text-gray-500">Check if VAT should be applied to this item at point of sale</p>
                        </div>
                    </div>

                    <!-- Stock Levels -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <Input
                            v-model="form.minimum_stock_level"
                            label="Minimum Stock Level"
                            type="number"
                            min="0"
                            :error="form.errors.minimum_stock_level"
                            placeholder="0"
                        />

                        <Input
                            v-model="form.reorder_point"
                            label="Reorder Point"
                            type="number"
                            min="0"
                            :error="form.errors.reorder_point"
                            placeholder="0"
                        />
                    </div>

                    <!-- Form Actions -->
                    <div class="flex items-center justify-end space-x-3 pt-6 border-t">
                        <Button type="button" variant="outline" @click="$inertia.visit(route('stock-items.index'))" :disabled="form.processing">
                            Cancel
                        </Button>
                        <Button type="submit" :disabled="form.processing">
                            <span v-if="!form.processing">Update Stock Item</span>
                            <span v-else>Updating...</span>
                        </Button>
                    </div>
                </div>
            </form>
        </div>
    </AppLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useForm } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';
import Input from '@/Components/Input.vue';

const props = defineProps({
    stockItem: Object,
});

const markupInput = ref('');

const form = useForm({
    selling_price: props.stockItem.selling_price || '',
    vat_applicable: props.stockItem.vat_applicable || false,
    minimum_stock_level: props.stockItem.minimum_stock_level || '',
    reorder_point: props.stockItem.reorder_point || '',
});

// Initialize markup from existing prices
onMounted(() => {
    if (props.stockItem.purchase_price && props.stockItem.selling_price) {
        const purchase = parseFloat(props.stockItem.purchase_price);
        const selling = parseFloat(props.stockItem.selling_price);
        if (purchase > 0) {
            markupInput.value = (((selling - purchase) / purchase) * 100).toFixed(1);
        }
    }
});

// Computed
const calculatedMarkup = computed(() => {
    if (!props.stockItem.purchase_price || !form.selling_price) return '0.00';
    const purchase = parseFloat(props.stockItem.purchase_price);
    const selling = parseFloat(form.selling_price);
    if (purchase === 0) return '0.00';
    return (((selling - purchase) / purchase) * 100).toFixed(2);
});

const profitPerUnit = computed(() => {
    if (!props.stockItem.purchase_price || !form.selling_price) return '0.00';
    const purchase = parseFloat(props.stockItem.purchase_price);
    const selling = parseFloat(form.selling_price);
    return (selling - purchase).toFixed(2);
});

const markupClass = computed(() => {
    const markup = parseFloat(calculatedMarkup.value);
    if (markup < 0) return 'text-danger-600';
    if (markup < 10) return 'text-warning-600';
    return 'text-success-600';
});

const expiryClass = computed(() => {
    if (!props.stockItem.expiry_date) return 'text-gray-900';
    const expiry = new Date(props.stockItem.expiry_date);
    const now = new Date();
    const daysUntilExpiry = Math.ceil((expiry - now) / (1000 * 60 * 60 * 24));

    if (daysUntilExpiry <= 0) return 'text-danger-600';
    if (daysUntilExpiry <= 90) return 'text-warning-600';
    return 'text-success-600';
});

const expiryStatus = computed(() => {
    if (!props.stockItem.expiry_date) return '';
    const expiry = new Date(props.stockItem.expiry_date);
    const now = new Date();
    const daysUntilExpiry = Math.ceil((expiry - now) / (1000 * 60 * 60 * 24));

    if (daysUntilExpiry <= 0) return 'Expired';
    if (daysUntilExpiry <= 30) return `Expires in ${daysUntilExpiry} days`;
    if (daysUntilExpiry <= 90) return 'Expiring soon';
    return 'Valid';
});

const stockClass = computed(() => {
    const qty = props.stockItem.quantity_available || 0;
    const min = props.stockItem.minimum_stock_level || 0;

    if (qty <= 0) return 'text-danger-600';
    if (qty <= min) return 'text-warning-600';
    return 'text-success-600';
});

// Methods
const formatDate = (date) => {
    if (!date) return 'N/A';
    return new Date(date).toLocaleDateString('en-NG', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
    });
};

const calculateSellingPrice = () => {
    if (props.stockItem.purchase_price && markupInput.value) {
        const purchase = parseFloat(props.stockItem.purchase_price);
        const markup = parseFloat(markupInput.value);
        form.selling_price = (purchase * (1 + markup / 100)).toFixed(2);
    }
};

const updateMarkupFromPrice = () => {
    if (props.stockItem.purchase_price && form.selling_price) {
        const purchase = parseFloat(props.stockItem.purchase_price);
        const selling = parseFloat(form.selling_price);
        if (purchase > 0) {
            markupInput.value = (((selling - purchase) / purchase) * 100).toFixed(1);
        }
    }
};

const submit = () => {
    form.put(route('stock-items.update', props.stockItem.id), {
        onSuccess: () => {
            // Redirect handled by controller
        },
    });
};
</script>

