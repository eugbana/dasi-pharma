<template>
    <div class="barcode-scanner">
        <!-- Scanner Toggle Button -->
        <button
            @click="toggleScanner"
            type="button"
            class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
        >
            <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
            </svg>
            {{ isScanning ? 'Stop Scanner' : 'Scan Barcode' }}
        </button>

        <!-- Manual Input -->
        <div v-if="!isScanning" class="mt-2">
            <input
                v-model="manualBarcode"
                @keyup.enter="handleManualScan"
                type="text"
                placeholder="Or enter barcode manually..."
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
            />
        </div>

        <!-- Scanner Container -->
        <div v-if="isScanning" class="mt-4">
            <div id="barcode-reader" class="rounded-lg overflow-hidden border-2 border-primary-500"></div>
            <p class="mt-2 text-sm text-gray-500 text-center">
                Position the barcode within the frame
            </p>
        </div>

        <!-- Error Message -->
        <div v-if="error" class="mt-2 text-sm text-red-600">
            {{ error }}
        </div>
    </div>
</template>

<script setup>
import { ref, onUnmounted } from 'vue';
import { Html5Qrcode } from 'html5-qrcode';

const emit = defineEmits(['scan']);

const isScanning = ref(false);
const manualBarcode = ref('');
const error = ref('');
let html5QrCode = null;

const toggleScanner = async () => {
    if (isScanning.value) {
        await stopScanner();
    } else {
        await startScanner();
    }
};

const startScanner = async () => {
    try {
        error.value = '';
        html5QrCode = new Html5Qrcode('barcode-reader');
        
        const config = {
            fps: 10,
            qrbox: { width: 250, height: 150 },
            aspectRatio: 1.777778,
        };

        await html5QrCode.start(
            { facingMode: 'environment' },
            config,
            onScanSuccess,
            onScanError
        );

        isScanning.value = true;
    } catch (err) {
        error.value = 'Failed to start scanner. Please check camera permissions.';
        console.error('Scanner error:', err);
    }
};

const stopScanner = async () => {
    if (html5QrCode) {
        try {
            await html5QrCode.stop();
            html5QrCode.clear();
            html5QrCode = null;
        } catch (err) {
            console.error('Error stopping scanner:', err);
        }
    }
    isScanning.value = false;
};

const onScanSuccess = (decodedText) => {
    emit('scan', decodedText);
    stopScanner();
};

const onScanError = (errorMessage) => {
    // Ignore scan errors (they happen frequently during scanning)
    // console.log('Scan error:', errorMessage);
};

const handleManualScan = () => {
    if (manualBarcode.value.trim()) {
        emit('scan', manualBarcode.value.trim());
        manualBarcode.value = '';
    }
};

onUnmounted(() => {
    if (html5QrCode) {
        stopScanner();
    }
});
</script>

<style scoped>
#barcode-reader {
    width: 100%;
    max-width: 500px;
    margin: 0 auto;
}
</style>

