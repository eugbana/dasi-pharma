<template>
    <Link
        :href="href"
        class="group flex items-center px-3 py-2 text-sm font-medium rounded-lg transition-colors"
        :class="[
            active
                ? 'bg-primary-50 text-primary-700'
                : 'text-gray-700 hover:bg-gray-50 hover:text-gray-900'
        ]"
    >
        <span
            class="mr-3"
            :class="[
                active
                    ? 'text-primary-600'
                    : 'text-gray-400 group-hover:text-gray-500'
            ]"
        >
            <slot name="icon" />
        </span>
        <slot />
    </Link>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';

defineProps({
    href: String,
    active: Boolean,
});
</script>

