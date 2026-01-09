<template>
    <div class="overflow-hidden">
        <!-- Table -->
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <!-- Support both #header and #thead slots -->
                        <slot name="header" />
                        <slot name="thead" />
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    <!-- Support both #body and default slot -->
                    <slot name="body" />
                    <slot />
                </tbody>
            </table>
        </div>

        <!-- Empty State -->
        <slot name="empty" />
    </div>
</template>

<script setup>
// No props needed - slots handle everything
</script>

