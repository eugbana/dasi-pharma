<template>
    <div class="min-h-screen bg-gray-100 py-8">
        <div class="max-w-2xl mx-auto">
            <!-- Print Controls -->
            <div class="mb-4 flex justify-between items-center print:hidden">
                <button @click="goBack" class="text-gray-600 hover:text-gray-900 flex items-center">
                    <svg class="h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                    </svg>
                    Back
                </button>
                <button @click="printReceipt" class="bg-primary-600 text-white px-4 py-2 rounded-lg hover:bg-primary-700 flex items-center">
                    <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" />
                    </svg>
                    Print Receipt
                </button>
            </div>

            <!-- Receipt -->
            <div id="receipt" class="bg-white shadow-lg rounded-lg p-8 print:shadow-none print:rounded-none">
                <!-- Header -->
                <div class="text-center border-b pb-6 mb-6">
                    <h1 class="text-2xl font-bold text-gray-900">{{ receiptConfig.business_name || returnData.branch.name }}</h1>
                    <p class="text-sm text-gray-600">{{ returnData.branch.address }}</p>
                    <p class="text-sm text-gray-600">Tel: {{ returnData.branch.phone }}</p>
                    <div class="mt-4 inline-block bg-red-100 text-red-800 px-4 py-2 rounded-full font-semibold">
                        RETURN RECEIPT
                    </div>
                </div>

                <!-- Return Info -->
                <div class="grid grid-cols-2 gap-4 mb-6 text-sm">
                    <div>
                        <p class="text-gray-500">Return Number:</p>
                        <p class="font-semibold">{{ returnData.return_number }}</p>
                    </div>
                    <div>
                        <p class="text-gray-500">Return Date:</p>
                        <p class="font-semibold">{{ formatDate(returnData.return_date) }}</p>
                    </div>
                    <div>
                        <p class="text-gray-500">Return Type:</p>
                        <p class="font-semibold" :class="returnData.return_type === 'Full Return' ? 'text-red-600' : 'text-yellow-600'">
                            {{ returnData.return_type }}
                        </p>
                    </div>
                    <div>
                        <p class="text-gray-500">Refund Method:</p>
                        <p class="font-semibold">{{ returnData.refund_method }}</p>
                    </div>
                </div>

                <!-- Original Sale Info -->
                <div class="bg-gray-50 rounded-lg p-4 mb-6">
                    <h3 class="font-semibold text-gray-700 mb-2">Original Sale Information</h3>
                    <div class="grid grid-cols-2 gap-2 text-sm">
                        <div>
                            <span class="text-gray-500">Sale #:</span>
                            <span class="ml-2">{{ returnData.original_sale.sale_number }}</span>
                        </div>
                        <div>
                            <span class="text-gray-500">Date:</span>
                            <span class="ml-2">{{ formatDate(returnData.original_sale.sale_date) }}</span>
                        </div>
                        <div>
                            <span class="text-gray-500">Customer:</span>
                            <span class="ml-2">{{ returnData.original_sale.customer_name }}</span>
                        </div>
                        <div>
                            <span class="text-gray-500">Original Amount:</span>
                            <span class="ml-2 font-semibold">₦{{ formatNumber(returnData.original_sale.total_amount) }}</span>
                        </div>
                    </div>
                </div>

                <!-- Returned Items -->
                <div class="mb-6">
                    <h3 class="font-semibold text-gray-700 mb-3">Returned Items</h3>
                    <table class="w-full text-sm">
                        <thead>
                            <tr class="border-b text-left text-gray-600">
                                <th class="py-2">Item</th>
                                <th class="py-2 text-center">Qty</th>
                                <th class="py-2 text-right">Unit Price</th>
                                <th class="py-2 text-right">Refund</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(item, index) in returnData.items" :key="index" class="border-b">
                                <td class="py-2">
                                    <div class="font-medium">{{ item.drug_name }}</div>
                                    <div class="text-xs text-gray-500">{{ item.strength }} {{ item.dosage_form }}</div>
                                    <div class="text-xs text-gray-400">Batch: {{ item.batch_number }}</div>
                                </td>
                                <td class="py-2 text-center">{{ item.quantity }}</td>
                                <td class="py-2 text-right">₦{{ formatNumber(item.unit_price) }}</td>
                                <td class="py-2 text-right text-red-600 font-medium">₦{{ formatNumber(item.refund_amount) }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Reason -->
                <div class="mb-6 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
                    <p class="text-sm text-gray-600"><span class="font-semibold">Return Reason:</span> {{ returnData.reason }}</p>
                </div>

                <!-- Totals -->
                <div class="border-t pt-4 mb-6">
                    <div class="flex justify-between items-center text-xl font-bold">
                        <span>Total Refunded:</span>
                        <span class="text-red-600">₦{{ formatNumber(returnData.refund_amount) }}</span>
                    </div>
                </div>

                <!-- Authorization -->
                <div class="border-t pt-4 text-sm text-gray-600">
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <p class="text-gray-500">Processed By:</p>
                            <p class="font-medium">{{ returnData.processed_by }}</p>
                        </div>
                        <div>
                            <p class="text-gray-500">Authorized By:</p>
                            <p class="font-medium">{{ returnData.authorized_by }}</p>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div class="mt-8 pt-4 border-t text-center text-xs text-gray-500">
                    <p>This is an official return receipt.</p>
                    <p>Please retain for your records.</p>
                    <p class="mt-2">{{ receiptConfig.footer_message || 'Thank you for your patience.' }}</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    returnData: Object,
    receiptConfig: {
        type: Object,
        default: () => ({
            business_name: '',
            footer_message: 'Thank you for your business',
        }),
    },
});

const formatNumber = (value) => {
    return parseFloat(value || 0).toLocaleString('en-NG', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    });
};

const formatDate = (dateString) => {
    return new Date(dateString).toLocaleString('en-NG', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
    });
};

const goBack = () => {
    window.history.back();
};

const printReceipt = () => {
    window.print();
};
</script>

<style>
@media print {
    body { background: white !important; }
    .print\:hidden { display: none !important; }
    .print\:shadow-none { box-shadow: none !important; }
    .print\:rounded-none { border-radius: 0 !important; }
}
</style>

