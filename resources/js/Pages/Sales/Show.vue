<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Sale Receipt</h1>
                <p class="mt-1 text-sm text-gray-500">
                    {{ sale.sale_number }}
                </p>
            </div>
            <div class="flex gap-3">
                <Button @click="printReceipt" variant="outline">
                    <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" />
                    </svg>
                    Print Receipt
                </Button>
                <Button @click="$inertia.visit(route('sales.index'))" variant="outline">
                    Back to Sales
                </Button>
            </div>
        </div>

        <!-- Receipt Container -->
        <div class="max-w-4xl mx-auto">
            <div id="receipt" class="bg-white rounded-lg shadow-lg border border-gray-200 p-8">
                <!-- Pharmacy Header -->
                <div class="text-center border-b-2 border-gray-300 pb-6 mb-6">
                    <h1 class="text-3xl font-bold text-primary-600">{{ receiptConfig.business_name || sale.branch.name }}</h1>
                    <p class="text-sm text-gray-600 mt-2">{{ sale.branch.address }}</p>
                    <p class="text-sm text-gray-600">Phone: {{ sale.branch.phone }} | Email: {{ sale.branch.email }}</p>
                    <div class="mt-3 inline-block bg-primary-100 text-primary-800 px-4 py-1 rounded-full font-semibold text-sm">
                        {{ receiptConfig.header_title || 'SALES RECEIPT' }}
                    </div>
                </div>

                <!-- Sale Information -->
                <div class="grid grid-cols-2 gap-6 mb-6">
                    <div>
                        <h3 class="text-sm font-semibold text-gray-700 mb-2">Sale Information</h3>
                        <div class="space-y-1 text-sm">
                            <div class="flex justify-between">
                                <span class="text-gray-600">Receipt #:</span>
                                <span class="font-semibold">{{ sale.sale_number }}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Date:</span>
                                <span>{{ formatDate(sale.sale_date) }}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Cashier:</span>
                                <span>{{ sale.user.name }}</span>
                            </div>
                            <div v-if="sale.prescription_number" class="flex justify-between">
                                <span class="text-gray-600">Prescription #:</span>
                                <span class="font-semibold text-primary-600">{{ sale.prescription_number }}</span>
                            </div>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-sm font-semibold text-gray-700 mb-2">Customer Information</h3>
                        <div class="space-y-1 text-sm">
                            <div class="flex justify-between">
                                <span class="text-gray-600">Name:</span>
                                <span>{{ sale.customer_name || 'Walk-in Customer' }}</span>
                            </div>
                            <div v-if="sale.customer_phone" class="flex justify-between">
                                <span class="text-gray-600">Phone:</span>
                                <span>{{ sale.customer_phone }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Items Table -->
                <div class="mb-6">
                    <h3 class="text-sm font-semibold text-gray-700 mb-3">Items Purchased</h3>
                    <table class="w-full">
                        <thead class="bg-gray-50 border-y border-gray-300">
                            <tr>
                                <th class="px-4 py-2 text-left text-xs font-semibold text-gray-700">Item</th>
                                <th class="px-4 py-2 text-center text-xs font-semibold text-gray-700">Batch</th>
                                <th class="px-4 py-2 text-center text-xs font-semibold text-gray-700">Qty</th>
                                <th class="px-4 py-2 text-right text-xs font-semibold text-gray-700">Unit Price</th>
                                <th class="px-4 py-2 text-right text-xs font-semibold text-gray-700">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            <tr v-for="item in sale.items" :key="item.id">
                                <td class="px-4 py-3">
                                    <div class="text-sm font-medium text-gray-900">{{ item.stock_item.drug.name }}</div>
                                    <div class="text-xs text-gray-500">{{ item.stock_item.drug.generic_name }}</div>
                                </td>
                                <td class="px-4 py-3 text-center text-xs text-gray-600">
                                    {{ item.batch_number }}
                                </td>
                                <td class="px-4 py-3 text-center text-sm text-gray-900">
                                    {{ item.quantity }}
                                </td>
                                <td class="px-4 py-3 text-right text-sm text-gray-900">
                                    ₦{{ formatNumber(item.unit_price) }}
                                </td>
                                <td class="px-4 py-3 text-right text-sm font-semibold text-gray-900">
                                    ₦{{ formatNumber(item.subtotal) }}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Totals -->
                <div class="border-t-2 border-gray-300 pt-4 mb-6">
                    <div class="flex justify-end">
                        <div class="w-64 space-y-2">
                            <div class="flex justify-between text-sm">
                                <span class="text-gray-600">Subtotal:</span>
                                <span class="font-medium">₦{{ formatNumber(sale.subtotal) }}</span>
                            </div>
                            <div v-if="sale.discount_amount > 0" class="flex justify-between text-sm">
                                <span class="text-gray-600">Discount:</span>
                                <span class="font-medium text-red-600">-₦{{ formatNumber(sale.discount_amount) }}</span>
                            </div>
                            <div v-if="sale.tax_amount > 0" class="flex justify-between text-sm">
                                <span class="text-gray-600">Tax:</span>
                                <span class="font-medium">₦{{ formatNumber(sale.tax_amount) }}</span>
                            </div>
                            <div class="flex justify-between text-lg font-bold border-t border-gray-300 pt-2">
                                <span>Total:</span>
                                <span class="text-primary-600">₦{{ formatNumber(sale.total_amount) }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Payment Information -->
                <div class="mb-6">
                    <h3 class="text-sm font-semibold text-gray-700 mb-3">Payment Details</h3>
                    <div class="bg-gray-50 rounded-lg p-4">
                        <div v-for="payment in sale.payments" :key="payment.id" class="flex justify-between text-sm mb-2 last:mb-0">
                            <div>
                                <span class="text-gray-600">{{ formatPaymentMethod(payment.payment_method) }}</span>
                                <span v-if="payment.reference_number" class="text-xs text-gray-500 ml-2">
                                    (Ref: {{ payment.reference_number }})
                                </span>
                            </div>
                            <span class="font-semibold">₦{{ formatNumber(payment.amount) }}</span>
                        </div>
                    </div>
                </div>

                <!-- Status Badge -->
                <div v-if="sale.status !== 'completed'" class="mb-6">
                    <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                        <div class="flex items-center">
                            <svg class="h-5 w-5 text-yellow-600 mr-2" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                            </svg>
                            <span class="text-sm font-medium text-yellow-800">
                                This sale has been {{ sale.status === 'returned' ? 'fully returned' : 'partially returned' }}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div class="border-t border-gray-300 pt-6 text-center">
                    <p class="text-sm text-gray-600 mb-2">{{ receiptConfig.footer_message || 'Thank you for your business' }}</p>
                    <p class="text-xs text-gray-500">This is a computer-generated receipt and does not require a signature.</p>
                    <p class="text-xs text-gray-500 mt-2">For inquiries, please contact us at {{ sale.branch.phone }}</p>

                    <div v-if="sale.prescription_number" class="mt-4 p-3 bg-blue-50 border border-blue-200 rounded-lg">
                        <p class="text-xs text-blue-800 font-medium">
                            ⚕️ Prescription Medication - Take as directed by your physician
                        </p>
                    </div>
                </div>
            </div>

            <!-- Return Section (Only for completed sales) -->
            <div v-if="sale.status === 'completed'" class="mt-6 bg-white rounded-lg shadow-lg border border-gray-200 p-6">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Process Return</h3>
                <p class="text-sm text-gray-600 mb-4">
                    If the customer needs to return items from this sale, you can process the return here.
                </p>
                <Button @click="showReturnModal = true" variant="outline">
                    <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6" />
                    </svg>
                    Process Return
                </Button>
            </div>
        </div>

        <!-- Return Modal (simplified - can be enhanced) -->
        <div v-if="showReturnModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50" @click="showReturnModal = false">
            <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white" @click.stop>
                <div class="mt-3">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">Process Return</h3>
                    <p class="text-sm text-gray-600 mb-4">
                        Return functionality will be implemented with detailed item selection and reason tracking.
                    </p>
                    <div class="flex justify-end gap-3">
                        <Button @click="showReturnModal = false" variant="outline">
                            Close
                        </Button>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { ref } from 'vue';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';

const props = defineProps({
    sale: Object,
    receiptConfig: {
        type: Object,
        default: () => ({
            business_name: '',
            header_title: 'SALES RECEIPT',
            footer_message: 'Thank you for your business',
            vat_rate: 0,
            vat_display_text: 'VAT',
        }),
    },
});

const showReturnModal = ref(false);

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-NG', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
    });
};

const formatNumber = (number) => {
    return parseFloat(number).toLocaleString('en-NG', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    });
};

const formatPaymentMethod = (method) => {
    const methods = {
        'cash': 'Cash',
        'card': 'Card Payment',
        'transfer': 'Bank Transfer',
        'mobile_money': 'Mobile Money',
    };
    return methods[method] || method;
};

const printReceipt = () => {
    window.print();
};
</script>

<style scoped>
@media print {
    /* Hide everything except the receipt */
    body * {
        visibility: hidden;
    }
    #receipt, #receipt * {
        visibility: visible;
    }
    #receipt {
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
    }
}
</style>


