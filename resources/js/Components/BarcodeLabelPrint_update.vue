<template>
    <div>
        <!-- Print Button -->
        <button
            @click="printLabel"
            type="button"
            class="inline-flex items-center px-3 py-1.5 border border-gray-300 rounded-md shadow-sm text-xs font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
        >
            <svg class="h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" />
            </svg>
            Print Label
        </button>

        <!-- Hidden Print Area -->
        <div v-if="labelData" class="hidden">
            <div ref="printArea" class="barcode-label">
                <div class="label-content">
                    <div class="drug-info">
                        <h3>{{ labelData.drug.brand_name }}</h3>
                        <p>{{ labelData.drug.strength }} - {{ labelData.drug.dosage_form }}</p>
                    </div>
                    <div class="batch-info">
                        <p><strong>Batch:</strong> {{ labelData.batch_number }}</p>
                        <p><strong>Exp:</strong> {{ labelData.expiry_date }}</p>
                        <p><strong>Price:</strong> ₦{{ formatNumber(labelData.selling_price) }}</p>
                    </div>
                    <div class="barcode-container">
                        <img :src="labelData.barcode_image" alt="Barcode" />
                        <p class="barcode-value">{{ labelData.barcode_value }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';

/**
 * IMPORTANT: Always use window.axios instead of importing axios directly.
 * The global axios instance is configured in bootstrap.js with CSRF token
 * and withCredentials settings required for Laravel's CSRF protection.
 */
const axios = window.axios;

const props = defineProps({
    stockItemId: {
        type: Number,
        required: true,
    },
});

const labelData = ref(null);
const printArea = ref(null);

const formatNumber = (value) => {
    return parseFloat(value).toLocaleString('en-NG', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    });
};

const printLabel = async () => {
    try {
        // Fetch label data
        const response = await axios.get(route('barcodes.print-label', props.stockItemId));
        labelData.value = response.data;

        // Wait for DOM update
        await new Promise(resolve => setTimeout(resolve, 100));

        // Print
        const printWindow = window.open('', '_blank');
        printWindow.document.write(`
            <!DOCTYPE html>
            <html>
            <head>
                <title>Barcode Label</title>
                <style>
                    @page {
                        size: 2in 1in;
                        margin: 0;
                    }
                    body {
                        margin: 0;
                        padding: 0;
                        font-family: Arial, sans-serif;
                    }
                    .barcode-label {
                        width: 2in;
                        height: 1in;
                        padding: 0.1in;
                        box-sizing: border-box;
                    }
                    .label-content {
                        display: flex;
                        flex-direction: column;
                        height: 100%;
                    }
                    .drug-info h3 {
                        margin: 0;
                        font-size: 8pt;
                        font-weight: bold;
                    }
                    .drug-info p {
                        margin: 0;
                        font-size: 6pt;
                    }
                    .batch-info {
                        margin-top: 2px;
                        font-size: 5pt;
                    }
                    .batch-info p {
                        margin: 0;
                        line-height: 1.2;
                    }
                    .barcode-container {
                        margin-top: auto;
                        text-align: center;
                    }
                    .barcode-container img {
                        width: 100%;
                        height: auto;
                        max-height: 0.3in;
                    }
                    .barcode-value {
                        margin: 0;
                        font-size: 5pt;
                        text-align: center;
                    }
                </style>
            </head>
            <body>
                ${printArea.value.outerHTML}
            </body>
            </html>
        `);
        printWindow.document.close();
        printWindow.focus();
        
        setTimeout(() => {
            printWindow.print();
            printWindow.close();
        }, 250);
    } catch (error) {
        console.error('Print error:', error);
        alert('Failed to print label. Please try again.');
    }
};
</script>

<style scoped>
.barcode-label {
    width: 2in;
    height: 1in;
    padding: 0.1in;
    box-sizing: border-box;
    background: white;
}
</style>

