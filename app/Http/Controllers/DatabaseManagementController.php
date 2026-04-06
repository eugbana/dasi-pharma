<?php

namespace App\Http\Controllers;

use App\Services\DatabaseBackupService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;
use Inertia\Response;

class DatabaseManagementController extends Controller
{
    protected DatabaseBackupService $backupService;

    public function __construct(DatabaseBackupService $backupService)
    {
        $this->backupService = $backupService;
    }

    /**
     * Display the database management page.
     */
    public function index(Request $request): Response
    {
        // Get list of backups
        $backups = $this->backupService->listBackups();

        // Get database info
        $dbPath = database_path('database.sqlite');
        $dbInfo = [
            'size' => File::exists($dbPath) ? File::size($dbPath) : 0,
            'path' => $dbPath,
            'exists' => File::exists($dbPath),
        ];

        return Inertia::render('Settings/Database', [
            'backups' => $backups,
            'dbInfo' => $dbInfo,
        ]);
    }

    /**
     * Create a new database backup.
     */
    public function backup(Request $request)
    {
        try {
            $prefix = $request->input('prefix', 'manual');
            
            $backupFile = $this->backupService->createBackup($prefix);
            $fileInfo = pathinfo($backupFile);
            
            Log::info('Manual database backup created', [
                'user_id' => $request->user()->id,
                'user_email' => $request->user()->email,
                'backup_file' => $fileInfo['basename'],
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Database backup created successfully',
                'backup' => [
                    'filename' => $fileInfo['basename'],
                    'path' => $backupFile,
                    'size' => File::size($backupFile),
                    'created_at' => now()->toIso8601String(),
                ],
            ]);

        } catch (\Exception $e) {
            Log::error('Database backup failed', [
                'user_id' => $request->user()->id,
                'error' => $e->getMessage(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Backup failed: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Restore database from uploaded backup file.
     */
    public function restore(Request $request)
    {
        $validated = $request->validate([
            'backup_file' => 'required|file|mimes:zip|max:102400', // Max 100MB
            'create_pre_restore_backup' => 'boolean',
        ]);

        try {
            // Store uploaded file temporarily
            $uploadedFile = $request->file('backup_file');
            $tempPath = storage_path('app/temp_restore_' . time() . '.zip');
            $uploadedFile->move(dirname($tempPath), basename($tempPath));

            // Create pre-restore backup if requested
            if ($validated['create_pre_restore_backup'] ?? true) {
                $this->backupService->createBackup('pre-restore');
            }

            // Validate database before restore
            $this->validateCurrentDatabase();

            // Perform restore
            $result = $this->backupService->restoreBackup($tempPath);

            // Clean up temp file
            if (File::exists($tempPath)) {
                File::delete($tempPath);
            }

            if (!$result) {
                throw new \RuntimeException('Restore operation returned false');
            }

            // Validate restored database
            $this->validateCurrentDatabase();

            Log::info('Database restored successfully', [
                'user_id' => $request->user()->id,
                'user_email' => $request->user()->email,
                'backup_file' => $uploadedFile->getClientOriginalName(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Database restored successfully',
            ]);

        } catch (\Exception $e) {
            // Clean up temp file on error
            if (isset($tempPath) && File::exists($tempPath)) {
                File::delete($tempPath);
            }

            Log::error('Database restore failed', [
                'user_id' => $request->user()->id,
                'error' => $e->getMessage(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Restore failed: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Download a specific backup file.
     */
    public function downloadBackup(Request $request, string $filename)
    {
        $backupPath = storage_path('backups/' . $filename);

        if (!File::exists($backupPath)) {
            abort(404, 'Backup file not found');
        }

        Log::info('Backup file downloaded', [
            'user_id' => $request->user()->id,
            'backup_file' => $filename,
        ]);

        return response()->download($backupPath);
    }

    /**
     * Delete a specific backup file.
     */
    public function deleteBackup(Request $request, string $filename)
    {
        try {
            $backupPath = storage_path('backups/' . $filename);

            if (!File::exists($backupPath)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Backup file not found',
                ], 404);
            }

            File::delete($backupPath);

            Log::info('Backup file deleted', [
                'user_id' => $request->user()->id,
                'backup_file' => $filename,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Backup deleted successfully',
            ]);

        } catch (\Exception $e) {
            Log::error('Failed to delete backup', [
                'user_id' => $request->user()->id,
                'backup_file' => $filename,
                'error' => $e->getMessage(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to delete backup: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Validate the current database.
     */
    protected function validateCurrentDatabase(): void
    {
        $result = DB::select("PRAGMA integrity_check");
        if (($result[0]->integrity_check ?? '') !== 'ok') {
            throw new \RuntimeException('Database integrity check failed');
        }
    }
}
