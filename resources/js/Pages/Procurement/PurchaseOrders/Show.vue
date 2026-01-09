<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Purchase Order Details</h1>
                <p class="mt-1 text-sm text-gray-500">
                    {{ purchaseOrder.order_number }}
                </p>
            </div>
            <div class="flex gap-2 flex-wrap">
                <Button
                    v-if="purchaseOrder.status === 'draft'"
                    @click="submitForApproval"
                    variant="warning"
                >
                    Submit for Approval
                </Button>
                <Button
                    v-if="purchaseOrder.status === 'pending_approval' && canApprove"
                    @click="approvePO"
                    variant="success"
                >
                    Approve PO
                </Button>
                <Button
                    v-if="purchaseOrder.status === 'approved' || purchaseOrder.status === 'partially_received'"
                    @click="createGRN"
                >
                    Create GRN
                </Button>
                <Button
                    v-if="purchaseOrder.status === 'draft' || purchaseOrder.status === 'pending_approval'"
                    @click="cancelPO"
                    variant="danger"
                >
                    Cancel
                </Button>
                <Button
                    @click="$inertia.visit(route('purchase-orders.index'))"
                    variant="outline"
                >
                    Back to List
                </Button>
            </div>
        </div>

        <!-- PO Information -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
            <!-- Main Details -->
            <div class="lg:col-span-2 bg-white rounded-lg shadow">
                <div class="p-6 border-b border-gray-200">
                    <h2 class="text-lg font-semibold text-gray-900">Order Information</h2>
                </div>
                <div class="p-6">
                    <dl class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <dt class="text-sm font-medium text-gray-500">PO Number</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ purchaseOrder.order_number }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Status</dt>
                            <dd class="mt-1">
                                <Badge :variant="getStatusVariant(purchaseOrder.status)">
                                    {{ getStatusLabel(purchaseOrder.status) }}
                                </Badge>
                            </dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Supplier</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ purchaseOrder.supplier?.name || 'N/A' }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Order Date</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ formatDate(purchaseOrder.order_date) }}</dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Expected Delivery</dt>
                            <dd class="mt-1 text-sm text-gray-900">
                                {{ purchaseOrder.expected_delivery_date ? formatDate(purchaseOrder.expected_delivery_date) : 'N/A' }}
                            </dd>
                        </div>
                        <div>
                            <dt class="text-sm font-medium text-gray-500">Created By</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ purchaseOrder.creator?.name || 'N/A' }}</dd>
                        </div>
                        <div v-if="purchaseOrder.approved_by">
                            <dt class="text-sm font-medium text-gray-500">Approved By</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ purchaseOrder.approver?.name || 'N/A' }}</dd>
                        </div>
                        <div v-if="purchaseOrder.approved_at">
                            <dt class="text-sm font-medium text-gray-500">Approved At</dt>
                            <dd class="mt-1 text-sm text-gray-900">{{ formatDateTime(purchaseOrder.approved_at) }}</dd>
                        </div>
                    </dl>
                    <div v-if="purchaseOrder.notes" class="mt-4">
                        <dt class="text-sm font-medium text-gray-500">Notes</dt>
                        <dd class="mt-1 text-sm text-gray-900">{{ purchaseOrder.notes }}</dd>
                    </div>
                </div>
            </div>

            <!-- Summary Card -->
            <div class="bg-white rounded-lg shadow">
                <div class="p-6 border-b border-gray-200">
                    <h2 class="text-lg font-semibold text-gray-900">Order Summary</h2>
                </div>
                <div class="p-6">
                    <div class="space-y-4">
                        <div>
                            <p class="text-sm text-gray-500">Total Items</p>
                            <p class="text-2xl font-bold text-gray-900">{{ purchaseOrder.items?.length || 0 }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Total Quantity</p>
                            <p class="text-2xl font-bold text-gray-900">{{ totalQuantity }}</p>
                        </div>
                        <div class="pt-4 border-t border-gray-200">
                            <p class="text-sm text-gray-500">Total Amount</p>
                            <p class="text-3xl font-bold text-primary-600">₦{{ formatNumber(purchaseOrder.total_amount) }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Order Items -->
        <div class="bg-white rounded-lg shadow mb-6">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-lg font-semibold text-gray-900">Order Items</h2>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Drug</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Strength</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Quantity</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Unit Price</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr v-for="item in purchaseOrder.items" :key="item.id">
                            <td class="px-6 py-4 text-sm text-gray-900">
                                {{ item.drug?.brand_name || 'N/A' }}
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-500">
                                {{ item.drug?.strength || 'N/A' }} - {{ item.drug?.dosage_form || 'N/A' }}
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-900 text-right">
                                {{ item.quantity_ordered }}
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-900 text-right">
                                ₦{{ formatNumber(item.unit_price) }}
                            </td>
                            <td class="px-6 py-4 text-sm font-medium text-gray-900 text-right">
                                ₦{{ formatNumber(item.subtotal) }}
                            </td>
                        </tr>
                    </tbody>
                    <tfoot class="bg-gray-50">
                        <tr>
                            <td colspan="4" class="px-6 py-4 text-right text-sm font-semibold text-gray-900">
                                Total:
                            </td>
                            <td class="px-6 py-4 text-right text-sm font-bold text-gray-900">
                                ₦{{ formatNumber(purchaseOrder.total_amount) }}
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>

        <!-- Goods Received Notes -->
        <div v-if="purchaseOrder.goods_received_notes && purchaseOrder.goods_received_notes.length > 0" class="bg-white rounded-lg shadow">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-lg font-semibold text-gray-900">Goods Received Notes</h2>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">GRN Number</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Received Date</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Received By</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr v-for="grn in purchaseOrder.goods_received_notes" :key="grn.id">
                            <td class="px-6 py-4 text-sm font-medium text-gray-900">
                                {{ grn.grn_number }}
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-500">
                                {{ formatDate(grn.received_date) }}
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-900">
                                {{ grn.receiver?.name || 'N/A' }}
                            </td>
                            <td class="px-6 py-4">
                                <Badge :variant="getGRNStatusVariant(grn.status)">
                                    {{ getStatusLabel(grn.status) }}
                                </Badge>
                            </td>
                            <td class="px-6 py-4 text-right text-sm font-medium">
                                <button
                                    @click="$inertia.visit(route('goods-received-notes.show', grn.id))"
                                    class="text-primary-600 hover:text-primary-900"
                                >
                                    View
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { computed } from 'vue';
import { router } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';
import Badge from '@/Components/Badge.vue';

const props = defineProps({
    purchaseOrder: Object,
});

const canApprove = computed(() => {
    // Add role check here if needed
    return true;
});

const totalQuantity = computed(() => {
    return props.purchaseOrder.items?.reduce((sum, item) => sum + item.quantity_ordered, 0) || 0;
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

const formatDateTime = (datetime) => {
    return new Date(datetime).toLocaleString('en-NG');
};

const getStatusVariant = (status) => {
    const variants = {
        draft: 'secondary',
        pending_approval: 'warning',
        approved: 'success',
        partially_received: 'info',
        completed: 'success',
        cancelled: 'danger',
    };
    return variants[status] || 'secondary';
};

const getGRNStatusVariant = (status) => {
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

const submitForApproval = () => {
    if (confirm('Are you sure you want to submit this purchase order for approval?')) {
        router.post(route('purchase-orders.submit', props.purchaseOrder.id));
    }
};

const approvePO = () => {
    if (confirm('Are you sure you want to approve this purchase order?')) {
        router.post(route('purchase-orders.approve', props.purchaseOrder.id));
    }
};

const cancelPO = () => {
    if (confirm('Are you sure you want to cancel this purchase order? This action cannot be undone.')) {
        router.post(route('purchase-orders.cancel', props.purchaseOrder.id));
    }
};

const createGRN = () => {
    router.visit(route('goods-received-notes.create', { po: props.purchaseOrder.id }));
};
</script>


