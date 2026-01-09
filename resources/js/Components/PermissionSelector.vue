<template>
    <div class="space-y-6">
        <!-- Module Tabs -->
        <div class="border-b border-gray-200">
            <nav class="-mb-px flex space-x-8 overflow-x-auto">
                <button
                    v-for="(perms, module) in permissions"
                    :key="module"
                    type="button"
                    @click.prevent.stop="activeModule = module"
                    :class="[
                        activeModule === module
                            ? 'border-primary-500 text-primary-600'
                            : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300',
                        'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm capitalize'
                    ]"
                >
                    {{ module }}
                    <span class="ml-2 text-xs text-gray-500">
                        ({{ getSelectedCount(module) }}/{{ perms.length }})
                    </span>
                </button>
            </nav>
        </div>

        <!-- Permissions List -->
        <div v-for="(perms, module) in permissions" :key="module" v-show="activeModule === module">
            <!-- Module Actions -->
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-lg font-medium text-gray-900 capitalize">{{ module }} Permissions</h3>
                <div class="flex gap-2">
                    <button
                        @click="selectAllInModule(module)"
                        type="button"
                        class="text-sm text-primary-600 hover:text-primary-700 font-medium"
                    >
                        Select All
                    </button>
                    <span class="text-gray-300">|</span>
                    <button
                        @click="deselectAllInModule(module)"
                        type="button"
                        class="text-sm text-gray-600 hover:text-gray-700 font-medium"
                    >
                        Deselect All
                    </button>
                </div>
            </div>

            <!-- Permission Checkboxes -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div
                    v-for="permission in perms"
                    :key="permission.id"
                    class="relative flex items-start p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
                >
                    <div class="flex items-center h-5">
                        <input
                            :id="`permission-${permission.id}`"
                            type="checkbox"
                            :value="permission.id"
                            v-model="localSelected"
                            class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
                        />
                    </div>
                    <div class="ml-3 text-sm">
                        <label :for="`permission-${permission.id}`" class="font-medium text-gray-900 cursor-pointer">
                            {{ formatPermissionName(permission.name) }}
                        </label>
                        <p class="text-gray-500">{{ permission.description }}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Summary -->
        <div class="bg-gray-50 rounded-lg p-4 border border-gray-200">
            <div class="flex items-center justify-between">
                <div>
                    <h4 class="text-sm font-medium text-gray-900">Selected Permissions</h4>
                    <p class="text-sm text-gray-500 mt-1">
                        {{ localSelected.length }} of {{ totalPermissions }} permissions selected
                    </p>
                </div>
                <button
                    v-if="localSelected.length > 0"
                    @click="clearAll"
                    type="button"
                    class="text-sm text-red-600 hover:text-red-700 font-medium"
                >
                    Clear All
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';

const props = defineProps({
    permissions: {
        type: Object,
        required: true,
    },
    modelValue: {
        type: Array,
        default: () => [],
    },
});

const emit = defineEmits(['update:modelValue']);

const activeModule = ref(Object.keys(props.permissions)[0] || 'inventory');

// Helper to normalize IDs to integers and sort for comparison
const normalizeIds = (ids) => [...ids].map(id => parseInt(id)).sort((a, b) => a - b);

// Helper to check if two arrays are equal
const arraysEqual = (a, b) => {
    if (a.length !== b.length) return false;
    const sortedA = normalizeIds(a);
    const sortedB = normalizeIds(b);
    return sortedA.every((val, idx) => val === sortedB[idx]);
};

// Ensure IDs are integers for consistent comparison
const localSelected = ref(normalizeIds(props.modelValue));

// Watch for external changes - only update if actually different
watch(() => props.modelValue, (newValue) => {
    const normalized = normalizeIds(newValue);
    if (!arraysEqual(localSelected.value, normalized)) {
        localSelected.value = normalized;
    }
}, { deep: true });

// Emit changes - only emit if actually different
watch(localSelected, (newValue) => {
    if (!arraysEqual(newValue, props.modelValue)) {
        emit('update:modelValue', [...newValue]);
    }
}, { deep: true });

const totalPermissions = computed(() => {
    return Object.values(props.permissions).reduce((total, perms) => total + perms.length, 0);
});

const getSelectedCount = (module) => {
    const modulePermissions = props.permissions[module] || [];
    return modulePermissions.filter(p => localSelected.value.includes(p.id)).length;
};

const selectAllInModule = (module) => {
    const modulePermissions = props.permissions[module] || [];
    const moduleIds = modulePermissions.map(p => p.id);
    
    // Add all module permissions that aren't already selected
    moduleIds.forEach(id => {
        if (!localSelected.value.includes(id)) {
            localSelected.value.push(id);
        }
    });
};

const deselectAllInModule = (module) => {
    const modulePermissions = props.permissions[module] || [];
    const moduleIds = modulePermissions.map(p => p.id);
    
    // Remove all module permissions
    localSelected.value = localSelected.value.filter(id => !moduleIds.includes(id));
};

const clearAll = () => {
    localSelected.value = [];
};

const formatPermissionName = (name) => {
    // Convert 'inventory.view' to 'View'
    const parts = name.split('.');
    const action = parts[parts.length - 1];
    return action.split('_').map(word => 
        word.charAt(0).toUpperCase() + word.slice(1)
    ).join(' ');
};
</script>

