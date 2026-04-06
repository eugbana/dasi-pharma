<template>
    <AppLayout>
        <!-- Page Header -->
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Database Management</h1>
            <p class="mt-1 text-sm text-gray-500">
                Backup and restore your database
            </p>
        </div>

        <!-- Database Information Card -->
        <div class="bg-white rounded-lg shadow p-6 mb-6">
            <h2 class="text-lg font-semibold text-gray-900 mb-4">Database Information</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div class="border border-gray-200 rounded-lg p-4">
                    <p class="text-sm text-gray-500">Database Size</p>
                    <p class="text-xl font-semibold text-gray-900">{{ formatBytes(dbInfo.size) }}</p>
                </div>
                <div class="border border-gray-200 rounded-lg p-4">
                    <p class="text-sm text-gray-500">Location</p>
                    <p class="text-sm font-medium text-gray-900 truncate">{{ dbInfo.path }}</p>
                </div>
                <div class="border border-gray-200 rounded-lg p-4">
                    <p class="text-sm text-gray-500">Status</p>
                    <p class="text-xl font-semibold" :class="dbInfo.exists ? 'text-green-600' : 'text-red-600'">
                        {{ dbInfo.exists ? 'Active' : 'Not Found' }}
                    </p>
                </div>
            </div>
        </div>

        <!-- Backup Section -->
        <div class="bg-white rounded-lg shadow p-6 mb-6">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <h2 class="text-lg font-semibold text-gray-900">Create Backup</h2>
                    <p class="text-sm text-gray-500">Create a backup of your database</p>
                </div>
                <Button @click="createBackup" :disabled="isCreatingBackup" variant="primary">
                    <svg v-if="!isCreatingBackup" class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3 3m0 0l-3-3m3 3V4" />
                    </svg>
                    <svg v-else class="animate-spin h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    {{ isCreatingBackup ? 'Creating Backup...' : 'Create Backup' }}
                </Button>
            </div>

            <!-- Success/Error Messages for Backup -->
            <div v-if="backupMessage" :class="backupSuccess ? 'bg-green-50 border-green-200 text-green-800' : 'bg-red-50 border-red-200 text-red-800'" class="border rounded-lg p-4 mb-4">
                <div class="flex items-start">
                    <svg v-if="backupSuccess" class="h-5 w-5 mr-2 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                    </svg>
                    <svg v-else class="h-5 w-5 mr-2 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                    </svg>
                    <div class="flex-1">
                        <p class="font-medium">{{ backupMessage }}</p>
                        <p v-if="lastBackup && backupSuccess" class="text-sm mt-1">
                            Filename: {{ lastBackup.filename }} ({{ formatBytes(lastBackup.size) }})
                        </p>
                    </div>
                    <button @click="backupMessage = null" class="ml-4 text-gray-400 hover:text-gray-600">
                        <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>

        <!-- Restore Section -->
        <div class="bg-white rounded-lg shadow p-6 mb-6">
            <div class="mb-4">
                <h2 class="text-lg font-semibold text-gray-900">Restore from Backup</h2>
                <p class="text-sm text-gray-500">Upload and restore a backup file</p>
            </div>

            <!-- Warning -->
            <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4 mb-4">
                <div class="flex items-start">
                    <svg class="h-5 w-5 text-yellow-600 mr-2 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                    </svg>
                    <div>
                        <p class="font-medium text-yellow-800">⚠️ Warning: This will replace your current database!</p>
                        <p class="text-sm text-yellow-700 mt-1">A safety backup will be created automatically before restore (unless you opt out).</p>
                    </div>
                </div>
            </div>

            <!-- File Upload -->
            <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-2">Select Backup File (.zip)</label>
                <input
                    type="file"
                    ref="fileInput"
                    @change="handleFileSelect"
                    accept=".zip"
                    class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-primary-50 file:text-primary-700 hover:file:bg-primary-100"
                />
                <p v-if="selectedFile" class="text-sm text-gray-600 mt-2">
                    Selected: {{ selectedFile.name }} ({{ formatBytes(selectedFile.size) }})
                </p>
            </div>

            <!-- Pre-restore Backup Option -->
            <div class="mb-4">
                <label class="flex items-center">
                    <input
                        type="checkbox"
                        v-model="createPreRestoreBackup"
                        class="rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                    />
                    <span class="ml-2 text-sm text-gray-700">Create backup before restore (recommended)</span>
                </label>
            </div>

            <!-- Restore Button -->
            <Button @click="showRestoreConfirmation" :disabled="!selectedFile || isRestoring" variant="danger">
                <svg v-if="!isRestoring" class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                </svg>
                <svg v-else class="animate-spin h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                {{ isRestoring ? 'Restoring Database...' : 'Restore Database' }}
            </Button>

            <!-- Success/Error Messages for Restore -->
            <div v-if="restoreMessage" :class="restoreSuccess ? 'bg-green-50 border-green-200 text-green-800' : 'bg-red-50 border-red-200 text-red-800'" class="border rounded-lg p-4 mt-4">
                <div class="flex items-start">
                    <svg v-if="restoreSuccess" class="h-5 w-5 mr-2 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                    </svg>
                    <svg v-else class="h-5 w-5 mr-2 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                    </svg>
                    <div class="flex-1">
                        <p class="font-medium">{{ restoreMessage }}</p>
                    </div>
                    <button @click="restoreMessage = null" class="ml-4 text-gray-400 hover:text-gray-600">
                        <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>

        <!-- Backup List -->
        <div class="bg-white rounded-lg shadow p-6">
            <h2 class="text-lg font-semibold text-gray-900 mb-4">Available Backups</h2>

            <div v-if="backups.length === 0" class="text-center py-8 text-gray-500">
                <svg class="h-12 w-12 mx-auto mb-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                </svg>
                <p>No backups found</p>
                <p class="text-sm mt-1">Create your first backup above</p>
            </div>

            <div v-else class="space-y-3">
                <div v-for="backup in backups" :key="backup.filename" class="border border-gray-200 rounded-lg p-4 hover:border-gray-300 transition-colors">
                    <div class="flex items-center justify-between">
                        <div class="flex-1">
                            <div class="flex items-center">
                                <svg class="h-5 w-5 text-gray-400 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                </svg>
                                <h3 class="font-medium text-gray-900">{{ backup.filename }}</h3>
                            </div>
                            <div class="mt-1 flex items-center space-x-4 text-sm text-gray-500">
                                <span>{{ formatBytes(backup.size) }}</span>
                                <span>•</span>
                                <span>{{ backup.created_at || 'Unknown date' }}</span>
                                <span v-if="backup.version">•</span>
                                <span v-if="backup.version">v{{ backup.version }}</span>
                            </div>
                        </div>
                        <div class="flex items-center space-x-2 ml-4">
                            <button
                                @click="downloadBackup(backup.filename)"
                                class="p-2 text-primary-600 hover:bg-primary-50 rounded-md transition-colors"
                                title="Download"
                            >
                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                                </svg>
                            </button>
                            <button
                                @click="confirmDeleteBackup(backup.filename)"
                                class="p-2 text-red-600 hover:bg-red-50 rounded-md transition-colors"
                                title="Delete"
                            >
                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Confirmation Modal -->
        <Modal :show="showConfirmModal" @close="showConfirmModal = false" :title="confirmModalTitle">
            <p class="text-gray-600">{{ confirmModalContent }}</p>
            <template #footer>
                <div class="flex justify-end space-x-3">
                    <Button @click="showConfirmModal = false" variant="outline">Cancel</Button>
                    <Button @click="confirmModalAction" variant="danger">
                        {{ confirmModalButton }}
                    </Button>
                </div>
            </template>
        </Modal>
    </AppLayout>
</template>

<script setup>
import { ref } from 'vue';
import { router } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';
import Modal from '@/Components/Modal.vue';
import axios from 'axios';

const props = defineProps({
    backups: Array,
    dbInfo: Object,
});

// Backup state
const isCreatingBackup = ref(false);
const backupMessage = ref(null);
const backupSuccess = ref(false);
const lastBackup = ref(null);

// Restore state
const isRestoring = ref(false);
const restoreMessage = ref(null);
const restoreSuccess = ref(false);
const selectedFile = ref(null);
const createPreRestoreBackup = ref(true);
const fileInput = ref(null);

// Confirmation modal
const showConfirmModal = ref(false);
const confirmModalTitle = ref('');
const confirmModalContent = ref('');
const confirmModalButton = ref('');
const confirmModalAction = ref(null);

// Format bytes to human-readable size
const formatBytes = (bytes) => {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
};

// Create backup
const createBackup = async () => {
    isCreatingBackup.value = true;
    backupMessage.value = null;

    try {
        const response = await axios.post(route('admin.database.backup'), {
            prefix: 'manual'
        });

        if (response.data.success) {
            backupSuccess.value = true;
            backupMessage.value = response.data.message;
            lastBackup.value = response.data.backup;

            // Reload page to refresh backup list
            setTimeout(() => {
                router.reload();
            }, 2000);
        }
    } catch (error) {
        backupSuccess.value = false;
        backupMessage.value = error.response?.data?.message || 'Failed to create backup';
    } finally {
        isCreatingBackup.value = false;
    }
};

// Handle file selection
const handleFileSelect = (event) => {
    selectedFile.value = event.target.files[0] || null;
    restoreMessage.value = null;
};

// Show restore confirmation
const showRestoreConfirmation = () => {
    confirmModalTitle.value = 'Confirm Database Restore';
    confirmModalContent.value = 'Are you sure you want to restore the database from this backup? This will replace all current data. ' +
        (createPreRestoreBackup.value ? 'A safety backup will be created automatically.' : '');
    confirmModalButton.value = 'Restore Database';
    confirmModalAction.value = restoreDatabase;
    showConfirmModal.value = true;
};

// Restore database
const restoreDatabase = async () => {
    showConfirmModal.value = false;
    isRestoring.value = true;
    restoreMessage.value = null;

    try {
        const formData = new FormData();
        formData.append('backup_file', selectedFile.value);
        formData.append('create_pre_restore_backup', createPreRestoreBackup.value ? '1' : '0');

        const response = await axios.post(route('admin.database.restore'), formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });

        if (response.data.success) {
            restoreSuccess.value = true;
            restoreMessage.value = response.data.message;
            selectedFile.value = null;
            if (fileInput.value) {
                fileInput.value.value = '';
            }

            // Reload page after successful restore
            setTimeout(() => {
                router.reload();
            }, 2000);
        }
    } catch (error) {
        restoreSuccess.value = false;
        restoreMessage.value = error.response?.data?.message || 'Failed to restore database';
    } finally {
        isRestoring.value = false;
    }
};

// Download backup
const downloadBackup = (filename) => {
    window.location.href = route('admin.database.backup.download', { filename });
};

// Confirm delete backup
const confirmDeleteBackup = (filename) => {
    confirmModalTitle.value = 'Delete Backup';
    confirmModalContent.value = `Are you sure you want to delete the backup "${filename}"? This action cannot be undone.`;
    confirmModalButton.value = 'Delete';
    confirmModalAction.value = () => deleteBackup(filename);
    showConfirmModal.value = true;
};

// Delete backup
const deleteBackup = async (filename) => {
    showConfirmModal.value = false;

    try {
        const response = await axios.delete(route('admin.database.backup.delete', { filename }));

        if (response.data.success) {
            // Reload page to refresh backup list
            router.reload();
        }
    } catch (error) {
        alert(error.response?.data?.message || 'Failed to delete backup');
    }
};
</script>

<style scoped>
/* Add any custom styles if needed */
</style>


