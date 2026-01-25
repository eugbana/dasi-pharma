<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">System Configuration</h1>
            <p class="mt-1 text-sm text-gray-500">
                Manage system-wide settings including receipt customization and tax configuration
            </p>
        </div>

        <!-- Flash Messages -->
        <div v-if="$page.props.flash?.success" class="mb-6 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded">
            {{ $page.props.flash.success }}
        </div>

        <form @submit.prevent="submit">
            <div class="space-y-6">
                <!-- Receipt Configuration -->
                <div class="bg-white rounded-lg shadow">
                    <div class="p-6 border-b border-gray-200">
                        <h2 class="text-lg font-semibold text-gray-900">Receipt Configuration</h2>
                        <p class="text-sm text-gray-500">Customize how receipts appear to customers</p>
                    </div>
                    <div class="p-6 space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">
                                Business Name
                                <span class="text-gray-400 font-normal">(Leave empty to use branch name)</span>
                            </label>
                            <input
                                v-model="form.receipt_business_name"
                                type="text"
                                class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                placeholder="e.g., Dasi Pharma Ltd"
                            />
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">
                                Receipt Header Title
                            </label>
                            <input
                                v-model="form.receipt_header_title"
                                type="text"
                                class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                placeholder="e.g., SALES RECEIPT"
                            />
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">
                                Receipt Footer Message
                            </label>
                            <textarea
                                v-model="form.receipt_footer_message"
                                rows="3"
                                class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                placeholder="e.g., Thank you for your business"
                            ></textarea>
                        </div>
                    </div>
                </div>

                <!-- Tax Configuration -->
                <div class="bg-white rounded-lg shadow">
                    <div class="p-6 border-b border-gray-200">
                        <h2 class="text-lg font-semibold text-gray-900">Tax Configuration</h2>
                        <p class="text-sm text-gray-500">Configure VAT and tax settings</p>
                    </div>
                    <div class="p-6 space-y-4">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">
                                    VAT Rate (%)
                                </label>
                                <div class="relative">
                                    <input
                                        v-model="form.vat_rate"
                                        type="number"
                                        step="0.01"
                                        min="0"
                                        max="100"
                                        class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500 pr-8"
                                        placeholder="e.g., 7.5"
                                    />
                                    <span class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400">%</span>
                                </div>
                                <p class="mt-1 text-xs text-gray-500">Enter 0 to disable VAT</p>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">
                                    VAT Display Text
                                </label>
                                <input
                                    v-model="form.vat_display_text"
                                    type="text"
                                    class="w-full rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                    placeholder="e.g., VAT"
                                />
                                <p class="mt-1 text-xs text-gray-500">How VAT appears on receipts</p>
                            </div>
                        </div>

                        <!-- VAT Preview -->
                        <div v-if="form.vat_rate > 0" class="mt-4 p-4 bg-blue-50 rounded-lg border border-blue-200">
                            <h4 class="text-sm font-medium text-blue-900 mb-2">VAT Preview</h4>
                            <p class="text-sm text-blue-700">
                                For a ₦1,000 item with VAT:
                            </p>
                            <div class="mt-2 space-y-1 text-sm">
                                <div class="flex justify-between">
                                    <span class="text-blue-600">Base Price:</span>
                                    <span class="font-medium">₦1,000.00</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-blue-600">{{ form.vat_display_text || 'VAT' }} ({{ form.vat_rate }}%):</span>
                                    <span class="font-medium">₦{{ (1000 * form.vat_rate / 100).toFixed(2) }}</span>
                                </div>
                                <div class="flex justify-between border-t border-blue-200 pt-1">
                                    <span class="text-blue-700 font-medium">Total:</span>
                                    <span class="font-bold">₦{{ (1000 * (1 + form.vat_rate / 100)).toFixed(2) }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Submit -->
                <div class="flex justify-end">
                    <Button type="submit" :disabled="form.processing">
                        <span v-if="form.processing">Saving...</span>
                        <span v-else>Save Configuration</span>
                    </Button>
                </div>
            </div>
        </form>
    </AppLayout>
</template>

<script setup>
import { useForm } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';

const props = defineProps({
    receiptConfig: Object,
    taxConfig: Object,
});

const form = useForm({
    receipt_business_name: props.receiptConfig?.receipt_business_name || '',
    receipt_header_title: props.receiptConfig?.receipt_header_title || 'SALES RECEIPT',
    receipt_footer_message: props.receiptConfig?.receipt_footer_message || 'Thank you for your business',
    vat_rate: props.taxConfig?.vat_rate || 0,
    vat_display_text: props.taxConfig?.vat_display_text || 'VAT',
});

const submit = () => {
    form.put(route('admin.system-config.update'));
};
</script>

