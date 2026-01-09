<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Goods Received Note</h1>
                <p class="mt-1 text-sm text-gray-500">
                    {{ grn.grn_number }}
                </p>
            </div>
            <div class="flex gap-2">
                <Button
                    v-if="grn.status === 'pending_quality_check'"
                    @click="showQCModal = true"
                    variant="success"
                >
                    Perform Quality Check
                </Button>
                <Button
                    @click="$inertia.visit(route('goods-received-notes.index'))"
                    variant="outline"
                >
                    Back to List
                </Button>
            </div>
        </div>

        <!-- GRN Information -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
            <!-- Main Details -->
            <div class="lg:col-span-2 bg-white rounded-lg shadow">
                <div class="p-6 border-b border-gray-200">
                    <h2 class="text-lg font-semibold text-gray-900">Receipt Information</h2>
                </div>
                <div class="p-6">
                    <dl class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <dt class="text-sm font-medium text-gray-500">GRN Number</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ grn.grn_number }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Status</dt>
                            <dd class="mt-1">
                                <Badge :variant="getStatusVariant(grn.status)">
                                    {{ getStatusLabel(grn.status) }}
                                </Badge>
                            </dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Purchase Order</dt>
                            <dd class="mt-1 text-sm text-gray-900">
                                <button
                                    @click="$inertia.visit(route('purchase-orders.show', grn.purchase_order.id))"
                                    class="text-primary-600 hover:text-primary-900"
                                >
                                    {{ grn.purchase_order?.order_number || 'N/A' }}
                                </button>
                            </dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Supplier</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ grn.purchase_order?.supplier?.name || 'N/A' }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Received Date</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ formatDate(grn.received_date) }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Received By</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ grn.receiver?.name || 'N/A' }}</dd>
                        </div>
                    </dl>
                    <div v-if="grn.notes" class="mt-4">
                        <dt class="text-sm font-medium text-gray-500">Notes</dt>
                        <dd class="mt-1 text-sm text-gray-900">{{ grn.notes }}</dd>
                    </div>
                </div>
            </div>

            <!-- Summary Card -->
            <div class="bg-white rounded-lg shadow">
                <div class="p-6 border-b border-gray-200">
                    <h2 class="text-lg font-semibold text-gray-900">Receipt Summary</h2>
                </div>
                <div class="p-6">
                    <div class="space-y-4">
                        <div>
                            <p class="text-sm text-gray-500">Total Items</p>
                            <p class="text-2xl font-bold text-gray-900">{{ grn.items?.length || 0 }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Total Quantity</p>
                            <p class="text-2xl font-bold text-gray-900">{{ totalQuantity }}</p>
                        </div>
                        <div v-if="grn.status !== 'pending_quality_check'">
                            <p class="text-sm text-gray-500">Approved Items</p>
                            <p class="text-2xl font-bold text-green-600">{{ approvedItems }}</p>
                        </div>
                        <div v-if="grn.status !== 'pending_quality_check'">
                            <p class="text-sm text-gray-500">Rejected Items</p>
                            <p class="text-2xl font-bold text-red-600">{{ rejectedItems }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Received Items -->
        <div class="bg-white rounded-lg shadow">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-lg font-semibold text-gray-900">Received Items</h2>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Drug</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Batch</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Expiry</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Quantity</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Unit Price</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">QC Status</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr v-for="item in grn.items" :key="item.id">
                            <td class="px-6 py-4 text-sm text-gray-900">
                                {{ item.drug?.brand_name || 'N/A' }}
                                <br>
                                <span class="text-xs text-gray-500">
                                    {{ item.drug?.strength }} - {{ item.drug?.dosage_form }}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-900">
                                {{ item.batch_number }}
                                <br>
                                <span v-if="item.manufacturing_date" class="text-xs text-gray-500">
                                    Mfg: {{ formatDate(item.manufacturing_date) }}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-900">
                                {{ formatDate(item.expiry_date) }}
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-900 text-right">
                                {{ item.quantity_received }}
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-900 text-right">
                                ₦{{ formatNumber(item.unit_price) }}
                            </td>
                            <td class="px-6 py-4">
                                <div v-if="grn.status === 'pending_quality_check'">
                                    <Badge variant="warning">Pending</Badge>
                                </div>
                                <div v-else>
                                    <Badge :variant="item.quality_check_passed ? 'success' : 'danger'">
                                        {{ item.quality_check_passed ? 'Passed' : 'Failed' }}
                                    </Badge>
                                    <p v-if="item.quality_notes" class="text-xs text-gray-500 mt-1">
                                        {{ item.quality_notes }}
                                    </p>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Quality Check Modal -->
        <div v-if="showQCModal" class="fixed inset-0 bg-gray-500 bg-opacity-75 flex items-center justify-center z-50">
            <div class="bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
                <div class="p-6 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-900">Quality Control Check</h3>
                </div>
                <form @submit.prevent="submitQC">
                    <div class="p-6 space-y-4">
                        <div v-for="(item, index) in qcForm.items" :key="index" class="border border-gray-200 rounded-lg p-4">
                            <div class="flex items-start justify-between mb-3">
                                <div>
                                    <p class="font-medium text-gray-900">{{ grn.items[index].drug?.brand_name }}</p>
                                    <p class="text-sm text-gray-500">
                                        Batch: {{ grn.items[index].batch_number }} |
                                        Qty: {{ grn.items[index].quantity_received }}
                                    </p>
                                </div>
                                <div class="flex gap-2">
                                    <button
                                        type="button"
                                        @click="item.quality_check_passed = true"
                                        :class="[
                                            'px-4 py-2 rounded-md text-sm font-medium',
                                            item.quality_check_passed === true
                                                ? 'bg-green-600 text-white'
                                                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                                        ]"
                                    >
                                        Pass
                                    </button>
                                    <button
                                        type="button"
                                        @click="item.quality_check_passed = false"
                                        :class="[
                                            'px-4 py-2 rounded-md text-sm font-medium',
                                            item.quality_check_passed === false
                                                ? 'bg-red-600 text-white'
                                                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                                        ]"
                                    >
                                        Fail
                                    </button>
                                </div>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Quality Notes</label>
                                <textarea
                                    v-model="item.quality_notes"
                                    rows="2"
                                    placeholder="Enter quality check observations..."
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                ></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="p-6 border-t border-gray-200 flex justify-end gap-4">
                        <Button
                            type="button"
                            @click="showQCModal = false"
                            variant="outline"
                            :disabled="qcForm.processing"
                        >
                            Cancel
                        </Button>
                        <Button type="submit" :disabled="qcForm.processing || !allItemsChecked">
                            Submit Quality Check
                        </Button>
                    </div>
                </form>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { computed, ref } from 'vue';
import { useForm } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';
import Badge from '@/Components/Badge.vue';

const props = defineProps({
    grn: Object,
});

const showQCModal = ref(false);

const qcForm = useForm({
    items: props.grn.items.map(item => ({
        id: item.id,
        quality_check_passed: null,
        quality_notes: '',
    })),
});

const totalQuantity = computed(() => {
    return props.grn.items?.reduce((sum, item) => sum + item.quantity_received, 0) || 0;
});

const approvedItems = computed(() => {
    return props.grn.items?.filter(item => item.quality_check_passed === true).length || 0;
});

const rejectedItems = computed(() => {
    return props.grn.items?.filter(item => item.quality_check_passed === false).length || 0;
});

const allItemsChecked = computed(() => {
    return qcForm.items.every(item => item.quality_check_passed !== null);
});

const formatNumber = (value) => {
    return parseFloat(value || 0).toLocaleString('en-NG', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    });
};

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-NG');
};

const getStatusVariant = (status) => {
    const variants = {
        pending_quality_check: 'warning',
        approved: 'success',
        rejected: 'danger',
    };
    return variants[status] || 'secondary';
};

const getStatusLabel = (status) => {
    return status.replace(/_/g, ' ').toUpperCase();
};

const submitQC = () => {
    qcForm.post(route('goods-received-notes.quality-check', props.grn.id), {
        onSuccess: () => {
            showQCModal.value = false;
        },
    });
};
</script>


