<template>
    <div class="relative">
        <label v-if="label" class="block text-sm font-medium text-gray-700 mb-1">
            {{ label }}
            <span v-if="required" class="text-red-500">*</span>
        </label>
        <div class="relative">
            <input
                ref="inputRef"
                v-model="barcodeValue"
                type="text"
                :placeholder="placeholder"
                :required="required"
                class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500 pr-10"
                :class="{ 'border-red-500': error }"
                @input="handleInput"
                @keydown.enter="handleEnter"
            />
            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
                </svg>
            </div>
        </div>
        <p v-if="error" class="mt-1 text-sm text-red-600">{{ error }}</p>
        <p v-else-if="helpText" class="mt-1 text-sm text-gray-500">{{ helpText }}</p>
        
        <!-- Scan indicator -->
        <div v-if="isScanning" class="mt-2 flex items-center gap-2 text-sm text-blue-600">
            <svg class="animate-pulse h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span>Barcode detected!</span>
        </div>
    </div>
</template>

<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
    modelValue: {
        type: String,
        default: '',
    },
    label: {
        type: String,
        default: '',
    },
    placeholder: {
        type: String,
        default: 'Scan or enter barcode...',
    },
    required: {
        type: Boolean,
        default: false,
    },
    error: {
        type: String,
        default: '',
    },
    helpText: {
        type: String,
        default: 'Supports USB barcode scanners and manual entry',
    },
    autoSubmit: {
        type: Boolean,
        default: true,
    },
});

const emit = defineEmits(['update:modelValue', 'scan', 'enter']);

const inputRef = ref(null);
const barcodeValue = ref(props.modelValue);
const isScanning = ref(false);
let scanTimeout = null;
let lastInputTime = 0;

// Watch for external changes to modelValue
watch(() => props.modelValue, (newValue) => {
    barcodeValue.value = newValue;
});

// Watch for changes to barcodeValue
watch(barcodeValue, (newValue) => {
    emit('update:modelValue', newValue);
});

const handleInput = (event) => {
    const currentTime = Date.now();
    const timeDiff = currentTime - lastInputTime;
    lastInputTime = currentTime;

    // If input is very fast (< 50ms between characters), it's likely a scanner
    if (timeDiff < 50 && barcodeValue.value.length > 3) {
        isScanning.value = true;
        clearTimeout(scanTimeout);
        
        scanTimeout = setTimeout(() => {
            isScanning.value = false;
            if (props.autoSubmit && barcodeValue.value.length > 0) {
                emit('scan', barcodeValue.value);
            }
        }, 100);
    }
};

const handleEnter = (event) => {
    event.preventDefault();
    if (barcodeValue.value.length > 0) {
        emit('scan', barcodeValue.value);
        emit('enter', barcodeValue.value);
    }
};

// Focus method for parent components
const focus = () => {
    inputRef.value?.focus();
};

// Clear method for parent components
const clear = () => {
    barcodeValue.value = '';
    isScanning.value = false;
};

defineExpose({ focus, clear });
</script>

