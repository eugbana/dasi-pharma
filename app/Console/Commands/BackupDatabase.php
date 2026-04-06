<?php

namespace App\Console\Commands;

use App\Services\DatabaseBackupService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;

class BackupDatabase extends Command
{
    protected $signature = 'app:backup-database 
                            {--prefix=manual : Prefix for backup filename (e.g., manual, auto, pre-update)}
                            {--list : List all existing backups}
                            {--cleanup : Clean up old backups exceeding the limit}';
                            
    protected $description = 'Create a backup of the database';

    protected DatabaseBackupService $backupService;

    public function __construct(DatabaseBackupService $backupService)
    {
        parent::__construct();
        $this->backupService = $backupService;
    }

    public function handle(): int
    {
        // Handle list option
        if ($this->option('list')) {
            return $this->listBackups();
        }

        // Handle cleanup option
        if ($this->option('cleanup')) {
            return $this->cleanupBackups();
        }

        // Create backup
        return $this->createBackup();
    }

    protected function createBackup(): int
    {
        $prefix = $this->option('prefix');
        
        $this->info('Creating database backup...');
        $this->newLine();

        try {
            $backupFile = $this->backupService->createBackup($prefix);
            
            $this->line("  <fg=green>✓</> Backup created successfully!");
            $this->line("  <fg=gray>File:</> " . basename($backupFile));
            $this->line("  <fg=gray>Location:</> " . dirname($backupFile));
            $this->newLine();

            // Show backup info
            $size = filesize($backupFile);
            $this->line("  <fg=gray>Size:</> " . number_format($size / 1024, 2) . " KB");
            $this->newLine();

            return Command::SUCCESS;

        } catch (\Exception $e) {
            $this->error('Backup failed: ' . $e->getMessage());
            Log::error('Database backup failed', [
                'error' => $e->getMessage(),
                'prefix' => $prefix,
            ]);
            return Command::FAILURE;
        }
    }

    protected function listBackups(): int
    {
        $this->info('=== Available Database Backups ===');
        $this->newLine();

        try {
            $backups = $this->backupService->listBackups();

            if (empty($backups)) {
                $this->line('  <fg=yellow>No backups found.</>');
                $this->newLine();
                return Command::SUCCESS;
            }

            foreach ($backups as $index => $backup) {
                $num = str_pad($index + 1, 2, '0', STR_PAD_LEFT);
                $this->line("  <fg=cyan>[$num]</> {$backup['filename']}");
                $this->line("       Size: " . number_format($backup['size'] / 1024, 2) . " KB");
                $this->line("       Created: " . ($backup['created_at'] ?? 'Unknown'));
                $this->line("       Version: " . ($backup['version'] ?? 'Unknown'));
                $this->newLine();
            }

            $this->line("  <fg=gray>Total backups:</> " . count($backups));
            $this->newLine();

            return Command::SUCCESS;

        } catch (\Exception $e) {
            $this->error('Failed to list backups: ' . $e->getMessage());
            return Command::FAILURE;
        }
    }

    protected function cleanupBackups(): int
    {
        $this->info('Cleaning up old backups...');
        $this->newLine();

        try {
            $backups = $this->backupService->listBackups();
            $initialCount = count($backups);
            
            // The service will automatically cleanup when creating a backup,
            // but we can trigger it manually by checking the count
            $maxBackups = 10; // Should match DatabaseBackupService::$maxBackups
            
            if ($initialCount <= $maxBackups) {
                $this->line("  <fg=green>✓</> No cleanup needed. ($initialCount/$maxBackups backups)");
                $this->newLine();
                return Command::SUCCESS;
            }

            $this->line("  <fg=yellow>⚠</> Found $initialCount backups (limit: $maxBackups)");
            $this->line("  This will be automatically cleaned up on next backup creation.");
            $this->newLine();

            return Command::SUCCESS;

        } catch (\Exception $e) {
            $this->error('Cleanup failed: ' . $e->getMessage());
            return Command::FAILURE;
        }
    }
}
