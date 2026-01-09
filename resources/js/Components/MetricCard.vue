<template>
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
        <div class="flex items-center">
            <div class="flex-shrink-0">
                <div class="rounded-lg p-3" :class="iconColor">
                    <slot name="icon" />
                </div>
            </div>
            <div class="ml-5 w-0 flex-1">
                <dl>
                    <dt class="text-sm font-medium text-gray-500 truncate">
                        {{ title }}
                    </dt>
                    <dd class="flex items-baseline">
                        <div class="text-2xl font-semibold text-gray-900">
                            {{ value }}
                        </div>
                    </dd>
                    <dd v-if="subtitle" class="text-xs text-gray-500 mt-1">
                        {{ subtitle }}
                    </dd>
                </dl>
            </div>
        </div>
    </div>
</template>

<script setup>
defineProps({
    title: String,
    value: [String, Number],
    subtitle: String,
    iconColor: {
        type: String,
        default: 'bg-primary-500',
    },
});
</script>

