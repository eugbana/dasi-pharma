<template>
    <div class="flex items-center justify-between px-4 py-3 bg-white border-t border-gray-200 sm:px-6">
        <div class="flex justify-between flex-1 sm:hidden">
            <Link
                v-if="links[0]?.url"
                :href="links[0].url"
                class="relative inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
            >
                Previous
            </Link>
            <span v-else class="relative inline-flex items-center px-4 py-2 text-sm font-medium text-gray-400 bg-gray-100 border border-gray-300 rounded-md cursor-not-allowed">
                Previous
            </span>
            <Link
                v-if="links[links.length - 1]?.url"
                :href="links[links.length - 1].url"
                class="relative inline-flex items-center px-4 py-2 ml-3 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
            >
                Next
            </Link>
            <span v-else class="relative inline-flex items-center px-4 py-2 ml-3 text-sm font-medium text-gray-400 bg-gray-100 border border-gray-300 rounded-md cursor-not-allowed">
                Next
            </span>
        </div>
        <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
            <div>
                <p class="text-sm text-gray-700">
                    Showing page <span class="font-medium">{{ currentPage }}</span> of <span class="font-medium">{{ lastPage }}</span>
                </p>
            </div>
            <div>
                <nav class="inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
                    <template v-for="(link, index) in links" :key="index">
                        <Link
                            v-if="link.url"
                            :href="link.url"
                            class="relative inline-flex items-center px-3 py-2 text-sm font-medium border"
                            :class="[
                                link.active
                                    ? 'z-10 bg-primary-600 border-primary-600 text-white'
                                    : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
                                index === 0 ? 'rounded-l-md' : '',
                                index === links.length - 1 ? 'rounded-r-md' : '',
                            ]"
                            v-html="link.label"
                        />
                        <span
                            v-else
                            class="relative inline-flex items-center px-3 py-2 text-sm font-medium bg-gray-100 border border-gray-300 text-gray-400 cursor-not-allowed"
                            :class="[
                                index === 0 ? 'rounded-l-md' : '',
                                index === links.length - 1 ? 'rounded-r-md' : '',
                            ]"
                            v-html="link.label"
                        />
                    </template>
                </nav>
            </div>
        </div>
    </div>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import { computed } from 'vue';

const props = defineProps({
    links: {
        type: Array,
        required: true,
    },
});

const currentPage = computed(() => {
    const active = props.links.find(link => link.active);
    return active ? active.label : 1;
});

const lastPage = computed(() => {
    // links array is: [prev, 1, 2, 3, ..., next]
    // so last page number is second to last
    if (props.links.length <= 2) return 1;
    return props.links[props.links.length - 2]?.label || 1;
});
</script>

