<template>
    <div>
        <label v-if="label" :for="id" class="block text-sm font-medium text-gray-700 mb-2">
            {{ label }}
            <span v-if="required" class="text-danger-500">*</span>
        </label>
        <div class="relative">
            <input
                :id="id"
                :type="type"
                :value="modelValue"
                @input="$emit('update:modelValue', $event.target.value)"
                :placeholder="placeholder"
                :required="required"
                :disabled="disabled"
                :readonly="readonly"
                :autocomplete="autocomplete"
                :min="min"
                :max="max"
                :step="step"
                class="block w-full px-4 py-2.5 border rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition disabled:bg-gray-50 disabled:text-gray-500 disabled:cursor-not-allowed"
                :class="[
                    error ? 'border-danger-500' : 'border-gray-400',
                    icon ? 'pl-10' : ''
                ]"
            />
            <div v-if="icon" class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <slot name="icon" />
            </div>
        </div>
        <p v-if="error" class="mt-2 text-sm text-danger-600">
            {{ error }}
        </p>
        <p v-else-if="hint" class="mt-2 text-sm text-gray-500">
            {{ hint }}
        </p>
    </div>
</template>

<script setup>
defineProps({
    id: String,
    label: String,
    type: {
        type: String,
        default: 'text',
    },
    modelValue: [String, Number],
    placeholder: String,
    required: Boolean,
    disabled: Boolean,
    readonly: Boolean,
    autocomplete: String,
    error: String,
    hint: String,
    icon: Boolean,
    min: [String, Number],
    max: [String, Number],
    step: [String, Number],
});

defineEmits(['update:modelValue']);
</script>

