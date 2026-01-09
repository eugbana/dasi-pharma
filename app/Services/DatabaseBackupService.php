<?php

namespace App\Services;

use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;
use ZipArchive;

class DatabaseBackupService
{
    protected string $dataPath;
    protected string $backupPath;
    protected int $maxBackups = 10;

    public function __construct()
    {
        $this->dataPath = env('DASI_PHARMA_DATA', storage_path());
        $this->backupPath = $this->dataPath . '/backups';
        
        if (! File::isDirectory($this->backupPath)) {
            File::makeDirectory($this->backupPath, 0755, true);
        }
    }

    public function createBackup(string $prefix = 'manual'): string
    {
        $timestamp = now()->format('Y-m-d_His');
        $filename = "{$prefix}_backup_{$timestamp}.zip";
        $backupFile = $this->backupPath . '/' . $filename;
        
        $dbPath = database_path('database.sqlite');
        
        if (! File::exists($dbPath)) {
            throw new \RuntimeException("Database file not found: $dbPath");
        }
        
        $zip = new ZipArchive();
        if ($zip->open($backupFile, ZipArchive::CREATE) !== true) {
            throw new \RuntimeException("Cannot create backup archive: $backupFile");
        }
        
        // Add database file
        $zip->addFile($dbPath, 'database.sqlite');
        
        // Add metadata
        $metadata = [
            'created_at' => now()->toIso8601String(),
            'version' => config('app.version', '1.0.0'),
            'prefix' => $prefix,
            'db_size' => File::size($dbPath),
        ];
        $zip->addFromString('metadata.json', json_encode($metadata, JSON_PRETTY_PRINT));
        
        $zip->close();
        
        // Cleanup old backups
        $this->cleanupOldBackups();
        
        Log::info("Database backup created: $filename");
        
        return $backupFile;
    }

    public function restoreBackup(string $backupFile): bool
    {
        if (! File::exists($backupFile)) {
            throw new \RuntimeException("Backup file not found: $backupFile");
        }

        $dbPath = database_path('database.sqlite');
        $tempPath = $dbPath . '.restoring';
        
        $zip = new ZipArchive();
        if ($zip->open($backupFile) !== true) {
            throw new \RuntimeException("Cannot open backup archive: $backupFile");
        }
        
        // Extract to temp location
        $tempDir = storage_path('app/temp_restore_' . time());
        File::makeDirectory($tempDir, 0755, true);
        $zip->extractTo($tempDir);
        $zip->close();
        
        $extractedDb = $tempDir . '/database.sqlite';
        if (! File::exists($extractedDb)) {
            File::deleteDirectory($tempDir);
            throw new \RuntimeException("Database not found in backup archive");
        }
        
        // Validate the restored database
        if (! $this->validateDatabase($extractedDb)) {
            File::deleteDirectory($tempDir);
            throw new \RuntimeException("Restored database failed validation");
        }
        
        // Replace current database
        if (File::exists($dbPath)) {
            File::delete($dbPath);
        }
        File::copy($extractedDb, $dbPath);
        File::deleteDirectory($tempDir);
        
        Log::info("Database restored from: $backupFile");
        
        return true;
    }

    public function listBackups(): array
    {
        $backups = [];
        
        if (! File::isDirectory($this->backupPath)) {
            return $backups;
        }
        
        foreach (File::files($this->backupPath) as $file) {
            if ($file->getExtension() === 'zip') {
                $metadata = $this->getBackupMetadata($file->getPathname());
                $backups[] = [
                    'filename' => $file->getFilename(),
                    'path' => $file->getPathname(),
                    'size' => $file->getSize(),
                    'created_at' => $metadata['created_at'] ?? null,
                    'version' => $metadata['version'] ?? 'unknown',
                ];
            }
        }
        
        usort($backups, fn($a, $b) => ($b['created_at'] ?? '') <=> ($a['created_at'] ?? ''));
        
        return $backups;
    }

    protected function validateDatabase(string $dbPath): bool
    {
        try {
            $pdo = new \PDO("sqlite:$dbPath");
            $pdo->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
            $result = $pdo->query("PRAGMA integrity_check")->fetchColumn();
            return $result === 'ok';
        } catch (\Exception $e) {
            Log::error("Database validation failed: " . $e->getMessage());
            return false;
        }
    }

    protected function cleanupOldBackups(): void
    {
        $backups = $this->listBackups();
        $toDelete = array_slice($backups, $this->maxBackups);
        
        foreach ($toDelete as $backup) {
            File::delete($backup['path']);
            Log::info("Deleted old backup: " . $backup['filename']);
        }
    }

    protected function getBackupMetadata(string $backupFile): array
    {
        try {
            $zip = new ZipArchive();
            if ($zip->open($backupFile) !== true) {
                return [];
            }
            $metadata = $zip->getFromName('metadata.json');
            $zip->close();
            return $metadata ? json_decode($metadata, true) : [];
        } catch (\Exception $e) {
            return [];
        }
    }
}

