<template>
    <div class="relative">
        <div class="relative">
            <input
                ref="inputRef"
                v-model="searchQuery"
                type="text"
                :placeholder="placeholder"
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 pr-10"
                @input="handleInput"
                @focus="showDropdown = true"
                @keydown.down.prevent="navigateDown"
                @keydown.up.prevent="navigateUp"
                @keydown.enter.prevent="selectHighlighted"
                @keydown.esc="closeDropdown"
            />
            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                <svg v-if="loading" class="animate-spin h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                </svg>
                <svg v-else class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
            </div>
        </div>

        <!-- Dropdown Results -->
        <div
            v-if="showDropdown && (results.length > 0 || (searchQuery.length >= minChars && !loading))"
            class="absolute z-50 mt-1 w-full bg-white rounded-md shadow-lg max-h-96 overflow-auto border border-gray-200"
        >
            <div v-if="loading" class="p-4 text-center text-gray-500">
                <span class="text-sm">Searching...</span>
            </div>
            <div v-else-if="results.length === 0 && searchQuery.length >= minChars" class="p-4 text-center text-gray-500">
                <span class="text-sm">No products found</span>
            </div>
            <ul v-else class="py-1">
                <li
                    v-for="(product, index) in results"
                    :key="product.id"
                    class="px-4 py-3 hover:bg-gray-50 cursor-pointer border-b border-gray-100 last:border-b-0"
                    :class="{ 'bg-primary-50': index === highlightedIndex }"
                    @click="selectProduct(product)"
                    @mouseenter="highlightedIndex = index"
                >
                    <div class="flex items-start justify-between">
                        <div class="flex-1">
                            <div class="flex items-center gap-2">
                                <p class="text-sm font-medium text-gray-900">
                                    {{ product.brand_name }}
                                </p>
                                <span
                                    v-if="product.in_stock"
                                    class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800"
                                >
                                    In Stock
                                </span>
                                <span
                                    v-else
                                    class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-red-100 text-red-800"
                                >
                                    Out of Stock
                                </span>
                            </div>
                            <p class="text-xs text-gray-500 mt-1">
                                {{ product.generic_name }} • {{ product.strength }} • {{ product.dosage_form }}
                            </p>
                            <div class="flex items-center gap-3 mt-1">
                                <span v-if="product.category" class="text-xs text-gray-400">
                                    {{ product.category }}
                                    <span v-if="product.subcategory"> › {{ product.subcategory }}</span>
                                </span>
                                <span v-if="product.in_stock" class="text-xs text-gray-600">
                                    Qty: {{ product.stock_available }}
                                </span>
                            </div>
                        </div>
                        <div class="text-right ml-4">
                            <p v-if="product.selling_price" class="text-sm font-semibold text-gray-900">
                                ₦{{ Number(product.selling_price).toLocaleString() }}
                            </p>
                            <p v-if="product.barcode" class="text-xs text-gray-400 mt-1">
                                {{ product.barcode }}
                            </p>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</template>

<script setup>
import { ref, watch } from 'vue';
import axios from 'axios';

const props = defineProps({
    placeholder: {
        type: String,
        default: 'Search products by name, category, or barcode...',
    },
    minChars: {
        type: Number,
        default: 2,
    },
    debounceMs: {
        type: Number,
        default: 300,
    },
    modelValue: {
        type: String,
        default: '',
    },
});

const emit = defineEmits(['update:modelValue', 'select']);

const inputRef = ref(null);
const searchQuery = ref(props.modelValue);
const results = ref([]);
const loading = ref(false);
const showDropdown = ref(false);
const highlightedIndex = ref(-1);
let debounceTimeout = null;

// Watch for external changes to modelValue
watch(() => props.modelValue, (newValue) => {
    searchQuery.value = newValue;
});

// Watch for changes to searchQuery
watch(searchQuery, (newValue) => {
    emit('update:modelValue', newValue);
});

const handleInput = () => {
    clearTimeout(debounceTimeout);
    
    if (searchQuery.value.length < props.minChars) {
        results.value = [];
        showDropdown.value = false;
        return;
    }

    loading.value = true;
    showDropdown.value = true;
    
    debounceTimeout = setTimeout(async () => {
        await searchProducts();
    }, props.debounceMs);
};

const searchProducts = async () => {
    try {
        const response = await axios.get(route('products.autocomplete'), {
            params: {
                query: searchQuery.value,
                limit: 10,
            },
        });

        if (response.data.success) {
            results.value = response.data.products;
            highlightedIndex.value = -1;
        }
    } catch (error) {
        console.error('Autocomplete search error:', error);
        results.value = [];
    } finally {
        loading.value = false;
    }
};

const selectProduct = (product) => {
    emit('select', product);
    searchQuery.value = product.brand_name;
    closeDropdown();
};

const navigateDown = () => {
    if (highlightedIndex.value < results.value.length - 1) {
        highlightedIndex.value++;
    }
};

const navigateUp = () => {
    if (highlightedIndex.value > 0) {
        highlightedIndex.value--;
    }
};

const selectHighlighted = () => {
    if (highlightedIndex.value >= 0 && highlightedIndex.value < results.value.length) {
        selectProduct(results.value[highlightedIndex.value]);
    }
};

const closeDropdown = () => {
    showDropdown.value = false;
    highlightedIndex.value = -1;
};

// Close dropdown when clicking outside
const handleClickOutside = (event) => {
    if (inputRef.value && !inputRef.value.contains(event.target)) {
        closeDropdown();
    }
};

// Add event listener for clicking outside
if (typeof window !== 'undefined') {
    document.addEventListener('click', handleClickOutside);
}

// Focus method for parent components
const focus = () => {
    inputRef.value?.focus();
};

defineExpose({ focus });
</script>
