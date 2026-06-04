<?php

namespace App\Services;

use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Config;
use ZipArchive;

class DatabaseBackupService
{
    protected string $dataPath;
    protected string $backupPath;
    protected int $maxBackups = 10;
    protected string $dbDriver;
    protected array $dbConfig;

    public function __construct()
    {
        $this->dataPath = env('DASI_PHARMA_DATA', storage_path());
        $this->backupPath = $this->dataPath . '/backups';

        if (! File::isDirectory($this->backupPath)) {
            File::makeDirectory($this->backupPath, 0755, true);
        }

        // Get current database driver and configuration
        $this->dbDriver = DB::getDriverName();
        $connectionName = Config::get('database.default');
        $this->dbConfig = Config::get("database.connections.{$connectionName}");
    }

    public function createBackup(string $prefix = 'manual'): string
    {
        $timestamp = now()->format('Y-m-d_His');
        $filename = "{$prefix}_backup_{$timestamp}.zip";
        $backupFile = $this->backupPath . '/' . $filename;

        $zip = new ZipArchive();
        if ($zip->open($backupFile, ZipArchive::CREATE) !== true) {
            throw new \RuntimeException("Cannot create backup archive: $backupFile");
        }

        // Create database backup based on driver
        $dbDumpFile = null;
        $dbSize = 0;

        if ($this->dbDriver === 'sqlite') {
            $dbDumpFile = $this->createSqliteBackup($zip);
            $dbPath = database_path($this->dbConfig['database'] ?? 'database.sqlite');
            $dbSize = File::exists($dbPath) ? File::size($dbPath) : 0;
        } elseif ($this->dbDriver === 'mysql') {
            $dbDumpFile = $this->createMysqlBackup($zip);
            $dbSize = File::exists($dbDumpFile) ? File::size($dbDumpFile) : 0;
        } else {
            $zip->close();
            File::delete($backupFile);
            throw new \RuntimeException("Unsupported database driver: {$this->dbDriver}");
        }

        // Add metadata
        $metadata = [
            'created_at' => now()->toIso8601String(),
            'version' => config('app.version', '1.0.0'),
            'prefix' => $prefix,
            'db_driver' => $this->dbDriver,
            'db_size' => $dbSize,
            'db_host' => $this->dbConfig['host'] ?? 'N/A',
            'db_name' => $this->dbConfig['database'] ?? 'N/A',
        ];
        $zip->addFromString('metadata.json', json_encode($metadata, JSON_PRETTY_PRINT));

        $zip->close();

        // Cleanup temporary dump file if created
        if ($dbDumpFile && File::exists($dbDumpFile) && $this->dbDriver === 'mysql') {
            File::delete($dbDumpFile);
        }

        // Cleanup old backups
        $this->cleanupOldBackups();

        Log::info("Database backup created: $filename", [
            'driver' => $this->dbDriver,
            'size' => $dbSize,
        ]);

        return $backupFile;
    }

    /**
     * Create SQLite backup and add to ZIP.
     */
    protected function createSqliteBackup(ZipArchive $zip): ?string
    {
        $dbPath = database_path($this->dbConfig['database'] ?? 'database.sqlite');

        if (! File::exists($dbPath)) {
            throw new \RuntimeException("SQLite database file not found: $dbPath");
        }

        // Add SQLite database file to ZIP
        $zip->addFile($dbPath, 'database.sqlite');

        return $dbPath;
    }

    /**
     * Create MySQL backup and add to ZIP.
     */
    protected function createMysqlBackup(ZipArchive $zip): string
    {
        $timestamp = now()->format('Y-m-d_His');
        $dumpFile = storage_path("app/temp_dump_{$timestamp}.sql");

        $host = $this->dbConfig['host'] ?? '127.0.0.1';
        $port = $this->dbConfig['port'] ?? '3306';
        $database = $this->dbConfig['database'];
        $username = $this->dbConfig['username'];
        $password = $this->dbConfig['password'] ?? '';

        // Build mysqldump command
        $command = sprintf(
            'mysqldump --host=%s --port=%s --user=%s --password=%s --single-transaction --routines --triggers %s > %s',
            escapeshellarg($host),
            escapeshellarg($port),
            escapeshellarg($username),
            escapeshellarg($password),
            escapeshellarg($database),
            escapeshellarg($dumpFile)
        );

        // If password is empty, remove the password flag
        if (empty($password)) {
            $command = sprintf(
                'mysqldump --host=%s --port=%s --user=%s --single-transaction --routines --triggers %s > %s',
                escapeshellarg($host),
                escapeshellarg($port),
                escapeshellarg($username),
                escapeshellarg($database),
                escapeshellarg($dumpFile)
            );
        }

        // Execute mysqldump
        $output = [];
        $returnCode = 0;
        exec($command . ' 2>&1', $output, $returnCode);

        if ($returnCode !== 0) {
            $errorMsg = implode("\n", $output);
            throw new \RuntimeException("MySQL backup failed: {$errorMsg}");
        }

        if (! File::exists($dumpFile) || File::size($dumpFile) === 0) {
            throw new \RuntimeException("MySQL dump file was not created or is empty");
        }

        // Add SQL dump to ZIP
        $zip->addFile($dumpFile, 'database.sql');

        return $dumpFile;
    }

    public function restoreBackup(string $backupFile): bool
    {
        if (! File::exists($backupFile)) {
            throw new \RuntimeException("Backup file not found: $backupFile");
        }

        $zip = new ZipArchive();
        if ($zip->open($backupFile) !== true) {
            throw new \RuntimeException("Cannot open backup archive: $backupFile");
        }

        // Extract to temp location
        $tempDir = storage_path('app/temp_restore_' . time());
        File::makeDirectory($tempDir, 0755, true);
        $zip->extractTo($tempDir);
        $zip->close();

        // Read and validate metadata
        $metadataFile = $tempDir . '/metadata.json';
        if (! File::exists($metadataFile)) {
            File::deleteDirectory($tempDir);
            throw new \RuntimeException("Backup metadata not found");
        }

        $metadata = json_decode(File::get($metadataFile), true);
        $backupDriver = $metadata['db_driver'] ?? 'unknown';

        // Validate backup compatibility
        if ($backupDriver !== $this->dbDriver) {
            File::deleteDirectory($tempDir);
            throw new \RuntimeException(
                "Backup incompatibility: This backup was created from a '{$backupDriver}' database, " .
                "but the current server is configured to use '{$this->dbDriver}'. " .
                "Please ensure the database drivers match before restoring."
            );
        }

        // Restore based on driver
        try {
            if ($this->dbDriver === 'sqlite') {
                $this->restoreSqliteBackup($tempDir);
            } elseif ($this->dbDriver === 'mysql') {
                $this->restoreMysqlBackup($tempDir);
            } else {
                throw new \RuntimeException("Unsupported database driver: {$this->dbDriver}");
            }

            File::deleteDirectory($tempDir);

            Log::info("Database restored from: $backupFile", [
                'driver' => $this->dbDriver,
                'backup_created' => $metadata['created_at'] ?? 'unknown',
            ]);

            return true;
        } catch (\Exception $e) {
            File::deleteDirectory($tempDir);
            throw $e;
        }
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
                    'db_driver' => $metadata['db_driver'] ?? 'unknown',
                    'db_name' => $metadata['db_name'] ?? 'N/A',
                ];
            }
        }

        usort($backups, fn($a, $b) => ($b['created_at'] ?? '') <=> ($a['created_at'] ?? ''));

        return $backups;
    }

    /**
     * Restore SQLite database from extracted backup.
     */
    protected function restoreSqliteBackup(string $tempDir): void
    {
        $extractedDb = $tempDir . '/database.sqlite';

        if (! File::exists($extractedDb)) {
            throw new \RuntimeException("SQLite database not found in backup archive");
        }

        // Validate the restored database
        if (! $this->validateSqliteDatabase($extractedDb)) {
            throw new \RuntimeException("Restored SQLite database failed validation");
        }

        $dbPath = database_path($this->dbConfig['database'] ?? 'database.sqlite');

        // Replace current database
        if (File::exists($dbPath)) {
            File::delete($dbPath);
        }
        File::copy($extractedDb, $dbPath);
    }

    /**
     * Restore MySQL database from extracted backup.
     */
    protected function restoreMysqlBackup(string $tempDir): void
    {
        $extractedSql = $tempDir . '/database.sql';

        if (! File::exists($extractedSql)) {
            throw new \RuntimeException("MySQL dump file not found in backup archive");
        }

        $host = $this->dbConfig['host'] ?? '127.0.0.1';
        $port = $this->dbConfig['port'] ?? '3306';
        $database = $this->dbConfig['database'];
        $username = $this->dbConfig['username'];
        $password = $this->dbConfig['password'] ?? '';

        // Build mysql import command
        $command = sprintf(
            'mysql --host=%s --port=%s --user=%s --password=%s %s < %s',
            escapeshellarg($host),
            escapeshellarg($port),
            escapeshellarg($username),
            escapeshellarg($password),
            escapeshellarg($database),
            escapeshellarg($extractedSql)
        );

        // If password is empty, remove the password flag
        if (empty($password)) {
            $command = sprintf(
                'mysql --host=%s --port=%s --user=%s %s < %s',
                escapeshellarg($host),
                escapeshellarg($port),
                escapeshellarg($username),
                escapeshellarg($database),
                escapeshellarg($extractedSql)
            );
        }

        // Execute mysql import
        $output = [];
        $returnCode = 0;
        exec($command . ' 2>&1', $output, $returnCode);

        if ($returnCode !== 0) {
            $errorMsg = implode("\n", $output);
            throw new \RuntimeException("MySQL restore failed: {$errorMsg}");
        }
    }

    /**
     * Validate SQLite database.
     */
    protected function validateSqliteDatabase(string $dbPath): bool
    {
        try {
            $pdo = new \PDO("sqlite:$dbPath");
            $pdo->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
            $result = $pdo->query("PRAGMA integrity_check")->fetchColumn();
            return $result === 'ok';
        } catch (\Exception $e) {
            Log::error("SQLite database validation failed: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Validate MySQL database connection.
     */
    protected function validateMysqlDatabase(): bool
    {
        try {
            DB::connection()->getPdo();
            return true;
        } catch (\Exception $e) {
            Log::error("MySQL database validation failed: " . $e->getMessage());
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

