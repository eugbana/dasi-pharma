<?php

namespace App\Console\Commands;

use App\Services\DatabaseBackupService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class RestoreDatabase extends Command
{
    protected $signature = 'app:restore-database 
                            {backup? : Path to backup file or backup filename}
                            {--latest : Restore from the latest backup}
                            {--force : Skip confirmation prompts}
                            {--no-backup : Skip creating a backup before restore}';
                            
    protected $description = 'Restore the database from a backup';

    protected DatabaseBackupService $backupService;

    public function __construct(DatabaseBackupService $backupService)
    {
        parent::__construct();
        $this->backupService = $backupService;
    }

    public function handle(): int
    {
        // Check database connection before restore
        if (!$this->checkDatabaseConnection()) {
            $this->error('Cannot connect to database. Restore aborted.');
            return Command::FAILURE;
        }

        // Get backup file to restore
        $backupFile = $this->getBackupFile();
        
        if (!$backupFile) {
            $this->error('No backup file specified or found.');
            return Command::FAILURE;
        }

        // Confirm restore operation
        if (!$this->confirmRestore($backupFile)) {
            $this->warn('Restore operation cancelled.');
            return Command::SUCCESS;
        }

        // Create pre-restore backup unless skipped
        if (!$this->option('no-backup')) {
            $this->createPreRestoreBackup();
        }

        // Perform restore
        return $this->restoreFromBackup($backupFile);
    }

    protected function checkDatabaseConnection(): bool
    {
        try {
            DB::connection()->getPdo();
            return true;
        } catch (\Exception $e) {
            Log::error('Database connection check failed', ['error' => $e->getMessage()]);
            return false;
        }
    }

    protected function getBackupFile(): ?string
    {
        // If --latest flag is used, get the most recent backup
        if ($this->option('latest')) {
            $backups = $this->backupService->listBackups();
            if (empty($backups)) {
                $this->error('No backups available.');
                return null;
            }
            return $backups[0]['path']; // First backup is the latest
        }

        // If backup argument is provided
        if ($backup = $this->argument('backup')) {
            // Check if it's a full path
            if (file_exists($backup)) {
                return $backup;
            }
            
            // Check if it's a filename in the backup directory
            $backupPath = storage_path('backups/' . $backup);
            if (file_exists($backupPath)) {
                return $backupPath;
            }

            $this->error("Backup file not found: $backup");
            return null;
        }

        // No backup specified, show available backups
        return $this->selectBackupInteractively();
    }

    protected function selectBackupInteractively(): ?string
    {
        $backups = $this->backupService->listBackups();
        
        if (empty($backups)) {
            $this->error('No backups available.');
            return null;
        }

        $this->info('Available backups:');
        $this->newLine();

        $choices = [];
        foreach ($backups as $index => $backup) {
            $num = $index + 1;
            $label = "[$num] {$backup['filename']} - " . 
                     number_format($backup['size'] / 1024, 2) . " KB - " . 
                     ($backup['created_at'] ?? 'Unknown date');
            $choices[$num] = $label;
            $this->line("  $label");
        }

        $this->newLine();
        $selection = $this->ask('Select a backup number to restore (or press Ctrl+C to cancel)');

        if (!isset($backups[$selection - 1])) {
            $this->error('Invalid selection.');
            return null;
        }

        return $backups[$selection - 1]['path'];
    }

    protected function confirmRestore(string $backupFile): bool
    {
        if ($this->option('force')) {
            return true;
        }

        $this->warn('⚠️  WARNING: This will replace the current database with the backup!');
        $this->line('Backup file: ' . basename($backupFile));
        $this->newLine();

        return $this->confirm('Are you sure you want to proceed?', false);
    }

    protected function createPreRestoreBackup(): void
    {
        $this->info('Creating pre-restore backup...');

        try {
            $backupFile = $this->backupService->createBackup('pre-restore');
            $this->line("  <fg=green>✓</> Pre-restore backup created: " . basename($backupFile));
            $this->newLine();
        } catch (\Exception $e) {
            $this->warn('Failed to create pre-restore backup: ' . $e->getMessage());
            $this->warn('Continuing with restore...');
            $this->newLine();
        }
    }

    protected function restoreFromBackup(string $backupFile): int
    {
        $this->info('Restoring database from backup...');
        $this->newLine();

        try {
            // Validate database before restore
            $dbPath = database_path('database.sqlite');
            if (file_exists($dbPath)) {
                $this->line('  Validating current database...');
                $result = DB::select("PRAGMA integrity_check");
                if (($result[0]->integrity_check ?? '') !== 'ok') {
                    $this->warn('  Current database has integrity issues, but continuing...');
                }
            }

            // Perform restore
            $this->line('  Restoring from backup...');
            $result = $this->backupService->restoreBackup($backupFile);

            if (!$result) {
                throw new \RuntimeException('Restore operation returned false');
            }

            $this->newLine();
            $this->line("  <fg=green>✓</> Database restored successfully!");
            $this->newLine();

            // Validate restored database
            $this->line('  Validating restored database...');
            $integrityResult = DB::select("PRAGMA integrity_check");
            if (($integrityResult[0]->integrity_check ?? '') === 'ok') {
                $this->line("  <fg=green>✓</> Database integrity check passed");
            } else {
                $this->error("  <fg=red>✗</> Database integrity check failed!");
                return Command::FAILURE;
            }

            // Test basic query
            $this->line('  Testing database connection...');
            $userCount = DB::table('users')->count();
            $this->line("  <fg=green>✓</> Database is functional (found $userCount users)");
            $this->newLine();

            $this->info('Restore completed successfully!');
            $this->line('Please verify that your data is correct.');
            $this->newLine();

            Log::info('Database restored successfully', [
                'backup_file' => basename($backupFile),
                'restored_at' => now()->toIso8601String(),
            ]);

            return Command::SUCCESS;

        } catch (\Exception $e) {
            $this->error('Restore failed: ' . $e->getMessage());
            $this->newLine();

            Log::error('Database restore failed', [
                'error' => $e->getMessage(),
                'backup_file' => basename($backupFile),
            ]);

            $this->warn('If the database is now corrupted, you can restore from the pre-restore backup.');
            $this->line('Run: php artisan app:restore-database --latest');
            $this->newLine();

            return Command::FAILURE;
        }
    }
}
