<template>
    <button
        :type="type"
        :disabled="disabled"
        class="inline-flex items-center justify-center px-4 py-2 border font-medium rounded-lg focus:outline-none focus:ring-2 focus:ring-offset-2 transition disabled:opacity-50 disabled:cursor-not-allowed"
        :class="buttonClasses"
    >
        <svg
            v-if="loading"
            class="animate-spin -ml-1 mr-2 h-4 w-4"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
        >
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <slot />
    </button>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
    type: {
        type: String,
        default: 'button',
    },
    variant: {
        type: String,
        default: 'primary',
        validator: (value) => ['primary', 'secondary', 'danger', 'success', 'warning', 'outline'].includes(value),
    },
    size: {
        type: String,
        default: 'md',
        validator: (value) => ['sm', 'md', 'lg'].includes(value),
    },
    disabled: Boolean,
    loading: Boolean,
});

const buttonClasses = computed(() => {
    const variants = {
        primary: 'border-transparent text-white bg-primary-600 hover:bg-primary-700 focus:ring-primary-500',
        secondary: 'border-transparent text-white bg-secondary-600 hover:bg-secondary-700 focus:ring-secondary-500',
        danger: 'border-transparent text-white bg-danger-600 hover:bg-danger-700 focus:ring-danger-500',
        success: 'border-transparent text-white bg-green-600 hover:bg-green-700 focus:ring-green-500',
        warning: 'border-transparent text-white bg-warning-600 hover:bg-warning-700 focus:ring-warning-500',
        outline: 'border-gray-300 text-gray-700 bg-white hover:bg-gray-50 focus:ring-primary-500',
    };

    const sizes = {
        sm: 'text-xs px-3 py-1.5',
        md: 'text-sm px-4 py-2',
        lg: 'text-base px-6 py-3',
    };

    return `${variants[props.variant]} ${sizes[props.size]}`;
});
</script>

