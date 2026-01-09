# Dasi Pharma Desktop Packaging Specification

## Executive Summary

This document provides a comprehensive technical specification for bundling the Dasi Pharma Management System (Laravel 10 + Inertia.js + Vue 3 + SQLite) as a native installable desktop application. After evaluating both NativePHP and Tauri, **NativePHP is the recommended solution** for this Laravel-based pharmacy management system.

---

## Table of Contents

1. [Technology Stack Decision](#1-technology-stack-decision)
2. [Architecture Design](#2-architecture-design)
3. [Installation Workflow](#3-installation-workflow)
4. [Database Migration Strategy](#4-database-migration-strategy)
5. [Auto-Update Implementation](#5-auto-update-implementation)
6. [Security Architecture](#6-security-architecture)
7. [Windows Packaging Guide](#7-windows-packaging-guide)
8. [Implementation Roadmap](#8-implementation-roadmap)

---

## 1. Technology Stack Decision

### NativePHP vs Tauri Comparison

| Criteria | NativePHP | Tauri |
|----------|-----------|-------|
| **Laravel Integration** | ⭐⭐⭐⭐⭐ Native | ⭐⭐ Requires API layer |
| **PHP Runtime** | ⭐⭐⭐⭐⭐ Bundled automatically | ⭐ Not applicable |
| **Development Effort** | ⭐⭐⭐⭐⭐ Minimal changes | ⭐⭐ Major refactor needed |
| **Bundle Size** | ⭐⭐⭐ ~100-150MB | ⭐⭐⭐⭐⭐ ~10-20MB |
| **Performance** | ⭐⭐⭐⭐ Good | ⭐⭐⭐⭐⭐ Excellent |
| **Offline Support** | ⭐⭐⭐⭐⭐ Full SQLite | ⭐⭐⭐⭐ Requires setup |
| **Maturity** | ⭐⭐⭐ Newer (2023) | ⭐⭐⭐⭐ Stable |
| **Community/Docs** | ⭐⭐⭐ Growing | ⭐⭐⭐⭐ Extensive |

### Recommendation: **NativePHP**

**Rationale for Dasi Pharma:**

1. **Zero Code Refactoring**: Your existing Laravel + Inertia.js + Vue 3 stack works directly
2. **Built-in PHP Runtime**: NativePHP bundles PHP 8.2+ with all required extensions (PDO SQLite, etc.)
3. **Electron-Based**: Uses Electron under the hood (stable, proven for desktop apps)
4. **SQLite Native Support**: Perfect for your offline-first pharmacy operations
5. **Laravel Artisan Integration**: Database migrations, seeders work seamlessly
6. **Auto-Update Built-in**: Native updater mechanism included

### Why NOT Tauri for This Project:

1. **Complete Rewrite Required**: Tauri expects a pure frontend app with Rust backend
2. **No PHP Support**: Would need to expose all Laravel functionality as REST APIs
3. **Complexity**: Requires maintaining two separate codebases (Vue frontend + Rust backend)
4. **Authentication**: Session-based auth would need complete redesign

---

## 2. Architecture Design

### 2.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Dasi Pharma Desktop                       │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────────────────────┐  │
│  │    Electron     │  │         NativePHP Runtime       │  │
│  │   (Chromium)    │  │  ┌───────────────────────────┐  │  │
│  │                 │  │  │   Embedded PHP 8.2        │  │  │
│  │  ┌───────────┐  │  │  │   + Required Extensions   │  │  │
│  │  │ Vue 3 +   │  │  │  └───────────────────────────┘  │  │
│  │  │ Inertia   │◄─┼──┼──►┌───────────────────────────┐  │  │
│  │  │ Frontend  │  │  │  │   Laravel 10 Application  │  │  │
│  │  └───────────┘  │  │  │   + Sanctum Auth          │  │  │
│  │                 │  │  │   + All Controllers       │  │  │
│  └─────────────────┘  │  └───────────────────────────┘  │  │
│                       │                                  │  │
│                       │  ┌───────────────────────────┐  │  │
│                       │  │    SQLite Database        │  │  │
│                       │  │    (Encrypted at Rest)    │  │  │
│                       │  └───────────────────────────┘  │  │
├─────────────────────────────────────────────────────────────┤
│                    Operating System                          │
│              (Windows / macOS / Linux)                       │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Application Bundling Strategy

```
dasi-pharma-desktop/
├── resources/
│   ├── app/                    # Laravel application (compiled)
│   │   ├── app/
│   │   ├── bootstrap/
│   │   ├── config/
│   │   ├── database/
│   │   │   ├── migrations/     # All migration files
│   │   │   └── seeders/        # All seeder files
│   │   ├── public/
│   │   │   └── build/          # Compiled Vite assets
│   │   ├── resources/
│   │   ├── routes/
│   │   ├── storage/            # Writable storage
│   │   └── vendor/             # Composer dependencies
│   └── php/                    # Bundled PHP runtime
├── data/                       # User data directory
│   ├── database.sqlite         # Application database
│   ├── backups/                # Automatic backups
│   └── logs/                   # Application logs
└── DasiPharma.exe             # Main executable
```

### 2.3 Process Management

NativePHP handles process management automatically:

```php
// config/nativephp.php - Process Configuration
return [
    'processes' => [
        'queue' => [
            'command' => ['php', 'artisan', 'queue:work', '--sleep=3', '--tries=3'],
            'auto_start' => true,
        ],
        'scheduler' => [
            'command' => ['php', 'artisan', 'schedule:work'],
            'auto_start' => true,
        ],
    ],
];
```

### 2.4 Inter-Process Communication

```php
// NativePHP provides native IPC through events
use Native\Laravel\Facades\Window;
use Native\Laravel\Facades\Notification;

class SaleController extends Controller
{
    public function store(Request $request)
    {
        $sale = Sale::create($request->validated());
        
        // Native desktop notification
        Notification::title('Sale Complete')
            ->body("Sale #{$sale->invoice_number} - ₦" . number_format($sale->total))
            ->show();
            
        return redirect()->route('sales.show', $sale);
    }
}
```

### 2.5 Memory and Resource Optimization

```php
// config/nativephp.php - Resource Limits
return [
    'memory_limit' => '256M',
    'max_execution_time' => 300,

    'window' => [
        'width' => 1400,
        'height' => 900,
        'min_width' => 1024,
        'min_height' => 768,
    ],

    // Garbage collection settings
    'php' => [
        'opcache.enable' => 1,
        'opcache.memory_consumption' => 64,
        'opcache.max_accelerated_files' => 4000,
    ],
];
```

---

## 3. Installation Workflow

### 3.1 First-Run Initialization Flow

```
┌──────────────────┐
│  User Launches   │
│  DasiPharma.exe  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐     ┌──────────────────┐
│ Check if First   │ Yes │ Create Data      │
│ Installation?    ├────►│ Directories      │
└────────┬─────────┘     └────────┬─────────┘
         │ No                     │
         │                        ▼
         │              ┌──────────────────┐
         │              │ Copy .env.desktop│
         │              │ Generate APP_KEY │
         │              └────────┬─────────┘
         │                       │
         │                       ▼
         │              ┌──────────────────┐
         │              │ Run Database     │
         │              │ Migrations       │
         │              └────────┬─────────┘
         │                       │
         │                       ▼
         │              ┌──────────────────┐
         │              │ Run Initial      │
         │              │ Seeders          │
         │              └────────┬─────────┘
         │                       │
         ▼                       ▼
┌──────────────────────────────────────────┐
│         Launch Main Application           │
└──────────────────────────────────────────┘
```

### 3.2 NativePHP Installation Provider

Create `app/Providers/NativeAppServiceProvider.php`:

```php
<?php

namespace App\Providers;

use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\File;
use Illuminate\Support\ServiceProvider;
use Native\Laravel\Facades\Window;
use Native\Laravel\Facades\App as NativeApp;

class NativeAppServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        if (! $this->isNativeApp()) {
            return;
        }

        $this->initializeDataDirectory();
        $this->runFirstTimeSetup();
    }

    protected function isNativeApp(): bool
    {
        return class_exists(\Native\Laravel\NativeServiceProvider::class);
    }

    protected function initializeDataDirectory(): void
    {
        $dataPath = $this->getDataPath();

        $directories = [
            $dataPath,
            $dataPath . '/backups',
            $dataPath . '/logs',
            $dataPath . '/cache',
        ];

        foreach ($directories as $dir) {
            if (! File::isDirectory($dir)) {
                File::makeDirectory($dir, 0755, true);
            }
        }
    }

    protected function runFirstTimeSetup(): void
    {
        $setupComplete = $this->getDataPath() . '/.setup_complete';

        if (File::exists($setupComplete)) {
            return;
        }

        // Show setup splash
        Window::open('setup')
            ->title('Setting Up Dasi Pharma...')
            ->width(400)
            ->height(300)
            ->alwaysOnTop();

        try {
            // Run migrations
            Artisan::call('migrate', ['--force' => true]);

            // Run essential seeders
            Artisan::call('db:seed', [
                '--class' => 'RoleSeeder',
                '--force' => true
            ]);
            Artisan::call('db:seed', [
                '--class' => 'PermissionSeeder',
                '--force' => true
            ]);
            Artisan::call('db:seed', [
                '--class' => 'BranchSeeder',
                '--force' => true
            ]);
            Artisan::call('db:seed', [
                '--class' => 'UserSeeder',
                '--force' => true
            ]);
            Artisan::call('db:seed', [
                '--class' => 'CategorySeeder',
                '--force' => true
            ]);

            // Create setup complete marker
            File::put($setupComplete, now()->toIso8601String());

            Window::close('setup');

        } catch (\Exception $e) {
            \Log::error('First-time setup failed: ' . $e->getMessage());
            throw $e;
        }
    }

    protected function getDataPath(): string
    {
        return NativeApp::dataPath('DasiPharma');
    }
}
```

### 3.3 Silent Installation for Enterprise

Create `scripts/silent-install.ps1` (Windows PowerShell):

```powershell
# Silent installation script for enterprise deployment
param(
    [string]$InstallPath = "C:\Program Files\DasiPharma",
    [string]$DataPath = "C:\ProgramData\DasiPharma",
    [switch]$NoShortcut,
    [switch]$Silent
)

$ErrorActionPreference = "Stop"

# Create directories
New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null
New-Item -ItemType Directory -Force -Path $DataPath | Out-Null
New-Item -ItemType Directory -Force -Path "$DataPath\backups" | Out-Null
New-Item -ItemType Directory -Force -Path "$DataPath\logs" | Out-Null

# Copy application files
Copy-Item -Path ".\*" -Destination $InstallPath -Recurse -Force

# Set environment variable for data path
[Environment]::SetEnvironmentVariable(
    "DASI_PHARMA_DATA",
    $DataPath,
    [EnvironmentVariableTarget]::Machine
)

# Create desktop shortcut
if (-not $NoShortcut) {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$env:PUBLIC\Desktop\Dasi Pharma.lnk")
    $Shortcut.TargetPath = "$InstallPath\DasiPharma.exe"
    $Shortcut.WorkingDirectory = $InstallPath
    $Shortcut.IconLocation = "$InstallPath\resources\icon.ico"
    $Shortcut.Save()
}

# Add to Windows Firewall (if needed for local server)
netsh advfirewall firewall add rule name="Dasi Pharma" `
    dir=in action=allow program="$InstallPath\DasiPharma.exe" enable=yes

Write-Host "Dasi Pharma installed successfully to $InstallPath"
```

### 3.4 Uninstallation and Cleanup

Create `scripts/uninstall.ps1`:

```powershell
param(
    [switch]$KeepData,
    [switch]$Silent
)

$InstallPath = "C:\Program Files\DasiPharma"
$DataPath = "C:\ProgramData\DasiPharma"

# Stop running processes
Stop-Process -Name "DasiPharma" -Force -ErrorAction SilentlyContinue

# Remove application files
if (Test-Path $InstallPath) {
    Remove-Item -Path $InstallPath -Recurse -Force
}

# Remove user data (optional)
if (-not $KeepData -and (Test-Path $DataPath)) {
    if (-not $Silent) {
        $confirm = Read-Host "Delete all application data including database? (y/N)"
        if ($confirm -ne 'y') {
            Write-Host "Keeping application data."
        } else {
            Remove-Item -Path $DataPath -Recurse -Force
        }
    } else {
        Remove-Item -Path $DataPath -Recurse -Force
    }
}

# Remove shortcuts
Remove-Item "$env:PUBLIC\Desktop\Dasi Pharma.lnk" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Dasi Pharma.lnk" `
    -Force -ErrorAction SilentlyContinue

# Remove environment variable
[Environment]::SetEnvironmentVariable("DASI_PHARMA_DATA", $null, [EnvironmentVariableTarget]::Machine)

# Remove firewall rule
netsh advfirewall firewall delete rule name="Dasi Pharma"

Write-Host "Dasi Pharma uninstalled successfully."
```

### 3.5 Installation Validation

```php
<?php
// app/Console/Commands/ValidateInstallation.php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;

class ValidateInstallation extends Command
{
    protected $signature = 'app:validate-installation';
    protected $description = 'Validate the desktop installation';

    public function handle(): int
    {
        $checks = [];

        // Check database connection
        try {
            DB::connection()->getPdo();
            $checks['Database Connection'] = true;
        } catch (\Exception $e) {
            $checks['Database Connection'] = false;
        }

        // Check required tables
        $requiredTables = ['users', 'roles', 'branches', 'drugs', 'sales'];
        foreach ($requiredTables as $table) {
            $checks["Table: $table"] = DB::getSchemaBuilder()->hasTable($table);
        }

        // Check storage directories
        $storageDirectories = [
            storage_path('app'),
            storage_path('framework/cache'),
            storage_path('framework/sessions'),
            storage_path('framework/views'),
            storage_path('logs'),
        ];
        foreach ($storageDirectories as $dir) {
            $checks["Dir: " . basename($dir)] = File::isWritable($dir);
        }

        // Check default user exists
        $checks['Admin User'] = \App\Models\User::where('email', 'admin@dasipharma.ng')->exists();

        // Output results
        $failed = false;
        foreach ($checks as $check => $passed) {
            if ($passed) {
                $this->info("✓ $check");
            } else {
                $this->error("✗ $check");
                $failed = true;
            }
        }

        return $failed ? Command::FAILURE : Command::SUCCESS;
    }
}
```

---

## 4. Database Migration Strategy

### 4.1 First-Run Database Initialization

Create `app/Console/Commands/InitializeDatabase.php`:

```php
<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Artisan;

class InitializeDatabase extends Command
{
    protected $signature = 'app:initialize-database
                            {--fresh : Drop all tables and re-migrate}
                            {--seed : Run seeders after migration}';

    protected $description = 'Initialize or reset the application database';

    public function handle(): int
    {
        $dbPath = database_path('database.sqlite');

        // Create database file if doesn't exist
        if (! File::exists($dbPath)) {
            File::put($dbPath, '');
            $this->info('Created new SQLite database file.');
        }

        // Run migrations
        $this->info('Running database migrations...');

        $migrateCommand = $this->option('fresh') ? 'migrate:fresh' : 'migrate';

        Artisan::call($migrateCommand, [
            '--force' => true,
            '--no-interaction' => true,
        ]);

        $this->info(Artisan::output());

        // Run seeders if requested
        if ($this->option('seed')) {
            $this->runSeeders();
        }

        // Create version marker
        $this->recordMigrationVersion();

        $this->info('Database initialization complete!');

        return Command::SUCCESS;
    }

    protected function runSeeders(): void
    {
        $this->info('Running database seeders...');

        $seeders = [
            'RoleSeeder',
            'PermissionSeeder',
            'RolePermissionSeeder',
            'BranchSeeder',
            'UserSeeder',
            'CategorySeeder',
            'SupplierSeeder',
        ];

        foreach ($seeders as $seeder) {
            $this->info("  Running $seeder...");
            Artisan::call('db:seed', [
                '--class' => $seeder,
                '--force' => true,
            ]);
        }
    }

    protected function recordMigrationVersion(): void
    {
        $version = config('app.version', '1.0.0');
        $dataPath = env('DASI_PHARMA_DATA', storage_path());

        File::put(
            $dataPath . '/.db_version',
            json_encode([
                'version' => $version,
                'migrated_at' => now()->toIso8601String(),
                'migration_batch' => DB::table('migrations')->max('batch'),
            ])
        );
    }
}
```

### 4.2 Incremental Migration Handler for Updates

Create `app/Services/DatabaseUpdateService.php`:

```php
<?php

namespace App\Services;

use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;

class DatabaseUpdateService
{
    protected string $dataPath;
    protected string $backupPath;

    public function __construct()
    {
        $this->dataPath = env('DASI_PHARMA_DATA', storage_path());
        $this->backupPath = $this->dataPath . '/backups';
    }

    public function checkPendingMigrations(): array
    {
        $output = Artisan::call('migrate:status', ['--no-ansi' => true]);
        $status = Artisan::output();

        $pending = [];
        foreach (explode("\n", $status) as $line) {
            if (str_contains($line, 'Pending')) {
                preg_match('/(\d{4}_\d{2}_\d{2}_\d{6}_\w+)/', $line, $matches);
                if ($matches) {
                    $pending[] = $matches[1];
                }
            }
        }

        return $pending;
    }

    public function runMigrations(): array
    {
        $results = [
            'success' => false,
            'migrations' => [],
            'backup_path' => null,
            'error' => null,
        ];

        try {
            // Create backup before migration
            $results['backup_path'] = $this->createBackup('pre_migration');

            // Run migrations
            Artisan::call('migrate', [
                '--force' => true,
                '--no-interaction' => true,
            ]);

            $output = Artisan::output();
            $results['migrations'] = $this->parseMigrationOutput($output);
            $results['success'] = true;

            // Update version marker
            $this->updateVersionMarker();

            Log::info('Database migrations completed', $results);

        } catch (\Exception $e) {
            $results['error'] = $e->getMessage();
            Log::error('Database migration failed', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            // Attempt rollback
            if ($results['backup_path']) {
                $this->restoreBackup($results['backup_path']);
            }
        }

        return $results;
    }

    protected function parseMigrationOutput(string $output): array
    {
        $migrations = [];
        foreach (explode("\n", $output) as $line) {
            if (preg_match('/Migrating:\s+(\S+)/', $line, $matches)) {
                $migrations[] = $matches[1];
            }
        }
        return $migrations;
    }

    protected function updateVersionMarker(): void
    {
        $versionFile = $this->dataPath . '/.db_version';

        File::put($versionFile, json_encode([
            'version' => config('app.version', '1.0.0'),
            'migrated_at' => now()->toIso8601String(),
            'migration_batch' => DB::table('migrations')->max('batch'),
        ]));
    }
}
```

### 4.3 Backup and Recovery System

Create `app/Services/DatabaseBackupService.php`:

```php
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

        $zip = new ZipArchive();
        if ($zip->open($backupFile, ZipArchive::CREATE) !== true) {
            throw new \RuntimeException("Cannot create backup archive: $backupFile");
        }

        // Add database file
        $zip->addFile($dbPath, 'database.sqlite');

        // Add metadata
        $metadata = [
            'created_at' => now()->toIso8601String(),
            'version' => config('app.version'),
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

        // Extract to temp file first
        $zip->extractTo(dirname($tempPath), 'database.sqlite');
        rename(dirname($tempPath) . '/database.sqlite', $tempPath);
        $zip->close();

        // Validate the restored database
        if (! $this->validateDatabase($tempPath)) {
            File::delete($tempPath);
            throw new \RuntimeException("Restored database failed validation");
        }

        // Replace current database
        File::delete($dbPath);
        rename($tempPath, $dbPath);

        Log::info("Database restored from: $backupFile");

        return true;
    }

    public function listBackups(): array
    {
        $backups = [];

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

        // Sort by creation date, newest first
        usort($backups, fn($a, $b) =>
            ($b['created_at'] ?? '') <=> ($a['created_at'] ?? '')
        );

        return $backups;
    }

    protected function validateDatabase(string $dbPath): bool
    {
        try {
            $pdo = new \PDO("sqlite:$dbPath");
            $pdo->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);

            // Run integrity check
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

        // Keep only the most recent backups
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
```

### 4.4 Database Corruption Detection and Repair

Create `app/Console/Commands/RepairDatabase.php`:

```php
<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;

class RepairDatabase extends Command
{
    protected $signature = 'app:repair-database
                            {--check-only : Only check for issues, do not repair}
                            {--force : Skip confirmation prompts}';

    protected $description = 'Check and repair database issues';

    public function handle(): int
    {
        $this->info('Checking database integrity...');

        $dbPath = database_path('database.sqlite');

        if (! File::exists($dbPath)) {
            $this->error('Database file not found!');
            return Command::FAILURE;
        }

        // Run SQLite integrity check
        $result = DB::select("PRAGMA integrity_check");
        $integrityOk = $result[0]->integrity_check === 'ok';

        if ($integrityOk) {
            $this->info('✓ Database integrity check passed');
        } else {
            $this->error('✗ Database integrity check failed');
            $this->line("  Result: " . $result[0]->integrity_check);
        }

        // Check foreign keys
        $fkCheck = DB::select("PRAGMA foreign_key_check");
        if (empty($fkCheck)) {
            $this->info('✓ Foreign key constraints are valid');
        } else {
            $this->warn('⚠ Foreign key violations found: ' . count($fkCheck));
        }

        // Analyze database
        $this->info('Analyzing database statistics...');
        DB::statement("ANALYZE");

        if ($this->option('check-only')) {
            return $integrityOk ? Command::SUCCESS : Command::FAILURE;
        }

        // Vacuum to reclaim space and optimize
        if ($integrityOk) {
            if ($this->option('force') || $this->confirm('Run VACUUM to optimize database?')) {
                $this->info('Running VACUUM...');
                $sizeBefore = File::size($dbPath);
                DB::statement("VACUUM");
                $sizeAfter = File::size($dbPath);

                $saved = $sizeBefore - $sizeAfter;
                $this->info("VACUUM complete. Space saved: " .
                    number_format($saved / 1024, 2) . " KB");
            }
        }

        // Reindex for performance
        if ($this->option('force') || $this->confirm('Rebuild all indexes?')) {
            $this->info('Rebuilding indexes...');
            DB::statement("REINDEX");
            $this->info('Indexes rebuilt successfully.');
        }

        return Command::SUCCESS;
    }
}
```

---

## 5. Auto-Update Implementation

### 5.1 Update Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Auto-Update Flow                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐   │
│  │ App Launch   │───►│ Check Update │───►│ Download     │   │
│  │              │    │ (Background) │    │ Update       │   │
│  └──────────────┘    └──────────────┘    └──────────────┘   │
│                             │                    │          │
│                             ▼                    ▼          │
│                      ┌──────────────┐    ┌──────────────┐   │
│                      │ Notify User  │    │ Backup DB    │   │
│                      │              │    │              │   │
│                      └──────────────┘    └──────────────┘   │
│                                                 │           │
│                                                 ▼           │
│                                          ┌──────────────┐   │
│                                          │ Apply Update │   │
│                                          │ & Restart    │   │
│                                          └──────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 NativePHP Update Configuration

Create `config/nativephp.php`:

```php
<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Application Name
    |--------------------------------------------------------------------------
    */
    'name' => env('APP_NAME', 'Dasi Pharma'),

    /*
    |--------------------------------------------------------------------------
    | Version
    |--------------------------------------------------------------------------
    */
    'version' => env('APP_VERSION', '1.0.0'),

    /*
    |--------------------------------------------------------------------------
    | Auto Updater Configuration
    |--------------------------------------------------------------------------
    */
    'updater' => [
        'enabled' => env('NATIVEPHP_UPDATER_ENABLED', true),

        // Update server URL
        'provider' => 'github',
        'github' => [
            'owner' => 'your-org',
            'repo' => 'dasi-pharma-releases',
            'private' => true,
            'token' => env('GITHUB_UPDATE_TOKEN'),
        ],

        // Alternative: Self-hosted update server
        // 'provider' => 'generic',
        // 'url' => 'https://updates.dasipharma.ng/releases',

        // Update check interval (in seconds)
        'check_interval' => 3600, // 1 hour

        // Auto download updates in background
        'auto_download' => true,

        // Auto install on quit
        'auto_install_on_quit' => false,
    ],

    /*
    |--------------------------------------------------------------------------
    | Window Configuration
    |--------------------------------------------------------------------------
    */
    'window' => [
        'width' => 1400,
        'height' => 900,
        'min_width' => 1024,
        'min_height' => 768,
        'resizable' => true,
        'fullscreenable' => true,
        'title' => 'Dasi Pharma Management System',
    ],

    /*
    |--------------------------------------------------------------------------
    | Menu Configuration
    |--------------------------------------------------------------------------
    */
    'menu' => [
        'show' => true,
    ],

    /*
    |--------------------------------------------------------------------------
    | Deep Links
    |--------------------------------------------------------------------------
    */
    'deep_links' => [
        'scheme' => 'dasipharma',
    ],

    /*
    |--------------------------------------------------------------------------
    | Database Path (for portable mode)
    |--------------------------------------------------------------------------
    */
    'database_path' => env('DASI_PHARMA_DATA'),

    /*
    |--------------------------------------------------------------------------
    | PHP Configuration
    |--------------------------------------------------------------------------
    */
    'php' => [
        'memory_limit' => '256M',
        'max_execution_time' => 300,
        'display_errors' => false,
        'error_reporting' => E_ALL & ~E_DEPRECATED & ~E_STRICT,
    ],
];
```

### 5.3 Update Service Implementation

Create `app/Services/UpdateService.php`:

```php
<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;
use Native\Laravel\Facades\Notification;
use Native\Laravel\Facades\App as NativeApp;

class UpdateService
{
    protected string $updateUrl;
    protected string $currentVersion;
    protected DatabaseBackupService $backupService;

    public function __construct(DatabaseBackupService $backupService)
    {
        $this->backupService = $backupService;
        $this->updateUrl = config('nativephp.updater.url',
            'https://updates.dasipharma.ng/releases');
        $this->currentVersion = config('nativephp.version', '1.0.0');
    }

    public function checkForUpdates(): ?array
    {
        try {
            $response = Http::timeout(30)
                ->get("{$this->updateUrl}/latest.json");

            if (! $response->successful()) {
                Log::warning('Update check failed: ' . $response->status());
                return null;
            }

            $latest = $response->json();

            if (version_compare($latest['version'], $this->currentVersion, '>')) {
                return [
                    'available' => true,
                    'version' => $latest['version'],
                    'release_date' => $latest['release_date'],
                    'changelog' => $latest['changelog'] ?? [],
                    'download_url' => $latest['download_url'],
                    'size' => $latest['size'] ?? 0,
                    'required' => $latest['required'] ?? false,
                    'min_version' => $latest['min_version'] ?? null,
                ];
            }

            return ['available' => false];

        } catch (\Exception $e) {
            Log::error('Update check error: ' . $e->getMessage());
            return null;
        }
    }

    public function downloadUpdate(array $updateInfo): ?string
    {
        $downloadPath = storage_path('app/updates');

        if (! File::isDirectory($downloadPath)) {
            File::makeDirectory($downloadPath, 0755, true);
        }

        $filename = "update-{$updateInfo['version']}.zip";
        $filePath = "{$downloadPath}/{$filename}";

        try {
            $response = Http::timeout(300)
                ->withOptions(['sink' => $filePath])
                ->get($updateInfo['download_url']);

            if (! $response->successful()) {
                Log::error('Update download failed');
                return null;
            }

            // Verify download
            if (isset($updateInfo['checksum'])) {
                $actualChecksum = hash_file('sha256', $filePath);
                if ($actualChecksum !== $updateInfo['checksum']) {
                    Log::error('Update checksum mismatch');
                    File::delete($filePath);
                    return null;
                }
            }

            Log::info("Update downloaded: {$filename}");
            return $filePath;

        } catch (\Exception $e) {
            Log::error('Update download error: ' . $e->getMessage());
            return null;
        }
    }

    public function prepareUpdate(string $updatePath): bool
    {
        // Create pre-update backup
        try {
            $backupPath = $this->backupService->createBackup('pre_update');

            // Store backup path for rollback
            File::put(
                storage_path('app/.pending_update'),
                json_encode([
                    'update_path' => $updatePath,
                    'backup_path' => $backupPath,
                    'prepared_at' => now()->toIso8601String(),
                ])
            );

            return true;
        } catch (\Exception $e) {
            Log::error('Update preparation failed: ' . $e->getMessage());
            return false;
        }
    }

    public function notifyUser(array $updateInfo): void
    {
        Notification::title('Update Available')
            ->body("Version {$updateInfo['version']} is available. Click to update.")
            ->action('Update Now', 'update://install')
            ->show();
    }
}
```

### 5.4 Update Rollback Strategy

Create `app/Console/Commands/RollbackUpdate.php`:

```php
<?php

namespace App\Console\Commands;

use App\Services\DatabaseBackupService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;

class RollbackUpdate extends Command
{
    protected $signature = 'app:rollback-update
                            {--backup= : Specific backup file to restore}';

    protected $description = 'Rollback to previous version after failed update';

    public function __construct(
        protected DatabaseBackupService $backupService
    ) {
        parent::__construct();
    }

    public function handle(): int
    {
        $pendingUpdateFile = storage_path('app/.pending_update');

        if ($this->option('backup')) {
            $backupPath = $this->option('backup');
        } elseif (File::exists($pendingUpdateFile)) {
            $pending = json_decode(File::get($pendingUpdateFile), true);
            $backupPath = $pending['backup_path'] ?? null;
        } else {
            // Find most recent pre_update backup
            $backups = $this->backupService->listBackups();
            $preUpdateBackups = array_filter($backups, fn($b) =>
                str_starts_with($b['filename'], 'pre_update_'));

            if (empty($preUpdateBackups)) {
                $this->error('No pre-update backup found.');
                return Command::FAILURE;
            }

            $backupPath = $preUpdateBackups[0]['path'];
        }

        if (! $backupPath || ! File::exists($backupPath)) {
            $this->error('Backup file not found: ' . ($backupPath ?? 'null'));
            return Command::FAILURE;
        }

        $this->warn("Rolling back to backup: " . basename($backupPath));

        if (! $this->confirm('This will restore the database. Continue?')) {
            return Command::SUCCESS;
        }

        try {
            $this->backupService->restoreBackup($backupPath);
            $this->info('Rollback completed successfully.');

            // Clean up pending update marker
            if (File::exists($pendingUpdateFile)) {
                File::delete($pendingUpdateFile);
            }

            return Command::SUCCESS;
        } catch (\Exception $e) {
            $this->error('Rollback failed: ' . $e->getMessage());
            return Command::FAILURE;
        }
    }
}
```

### 5.5 Update Server Manifest

Create update server manifest structure (`latest.json`):

```json
{
    "version": "1.2.0",
    "release_date": "2026-01-15",
    "required": false,
    "min_version": "1.0.0",
    "changelog": [
        "Added batch barcode printing",
        "Improved POS performance",
        "Fixed inventory sync issues",
        "Enhanced reporting exports"
    ],
    "platforms": {
        "win32-x64": {
            "url": "https://releases.dasipharma.ng/v1.2.0/DasiPharma-1.2.0-win-x64.exe",
            "size": 156789012,
            "checksum": "sha256:abc123..."
        },
        "darwin-x64": {
            "url": "https://releases.dasipharma.ng/v1.2.0/DasiPharma-1.2.0-mac-x64.dmg",
            "size": 145678901,
            "checksum": "sha256:def456..."
        },
        "darwin-arm64": {
            "url": "https://releases.dasipharma.ng/v1.2.0/DasiPharma-1.2.0-mac-arm64.dmg",
            "size": 142345678,
            "checksum": "sha256:ghi789..."
        },
        "linux-x64": {
            "url": "https://releases.dasipharma.ng/v1.2.0/DasiPharma-1.2.0-linux-x64.AppImage",
            "size": 134567890,
            "checksum": "sha256:jkl012..."
        }
    }
}
```

---

## 6. Security Architecture

### 6.1 Security Overview

```
┌─────────────────────────────────────────────────────────────┐
│                   Security Layers                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Layer 1: Application Signing & Integrity            │   │
│  │  - Code signing certificates (Windows/macOS)         │   │
│  │  - Checksum verification                             │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Layer 2: File System Protection                     │   │
│  │  - Sandboxed application directory                   │   │
│  │  - Restricted file access                            │   │
│  │  - Secure data storage location                      │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Layer 3: Database Security                          │   │
│  │  - SQLite encryption at rest (SQLCipher)             │   │
│  │  - Encrypted backups                                 │   │
│  │  - Secure key storage                                │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Layer 4: Application Security                       │   │
│  │  - Laravel authentication                            │   │
│  │  - Role-based access control                         │   │
│  │  - Session management                                │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 Environment Variable Security

Create `app/Services/SecureConfigService.php`:

```php
<?php

namespace App\Services;

use Illuminate\Support\Facades\File;
use Illuminate\Encryption\Encrypter;

class SecureConfigService
{
    protected string $configPath;
    protected ?Encrypter $encrypter = null;

    public function __construct()
    {
        $dataPath = env('DASI_PHARMA_DATA', storage_path());
        $this->configPath = $dataPath . '/.secure_config';
    }

    protected function getEncrypter(): Encrypter
    {
        if ($this->encrypter) {
            return $this->encrypter;
        }

        // Derive key from machine-specific identifier
        $machineId = $this->getMachineId();
        $key = hash('sha256', $machineId . config('app.key'), true);

        $this->encrypter = new Encrypter(
            substr($key, 0, 32),
            'AES-256-CBC'
        );

        return $this->encrypter;
    }

    protected function getMachineId(): string
    {
        // Windows: Use machine GUID
        if (PHP_OS_FAMILY === 'Windows') {
            $output = shell_exec('wmic csproduct get UUID');
            preg_match('/[A-F0-9-]{36}/', $output, $matches);
            return $matches[0] ?? 'default-machine-id';
        }

        // macOS: Use hardware UUID
        if (PHP_OS_FAMILY === 'Darwin') {
            $output = shell_exec("ioreg -d2 -c IOPlatformExpertDevice | awk -F\\\" '/IOPlatformUUID/{print \$(NF-1)}'");
            return trim($output) ?: 'default-machine-id';
        }

        // Linux: Use machine-id
        if (file_exists('/etc/machine-id')) {
            return trim(file_get_contents('/etc/machine-id'));
        }

        return 'default-machine-id';
    }

    public function store(string $key, mixed $value): void
    {
        $config = $this->loadConfig();
        $config[$key] = $value;
        $this->saveConfig($config);
    }

    public function get(string $key, mixed $default = null): mixed
    {
        $config = $this->loadConfig();
        return $config[$key] ?? $default;
    }

    public function remove(string $key): void
    {
        $config = $this->loadConfig();
        unset($config[$key]);
        $this->saveConfig($config);
    }

    protected function loadConfig(): array
    {
        if (! File::exists($this->configPath)) {
            return [];
        }

        try {
            $encrypted = File::get($this->configPath);
            $decrypted = $this->getEncrypter()->decrypt($encrypted);
            return json_decode($decrypted, true) ?? [];
        } catch (\Exception $e) {
            \Log::error('Failed to load secure config: ' . $e->getMessage());
            return [];
        }
    }

    protected function saveConfig(array $config): void
    {
        $encrypted = $this->getEncrypter()->encrypt(json_encode($config));
        File::put($this->configPath, $encrypted);
    }
}
```

### 6.3 SQLite Database Encryption

Create `app/Services/EncryptedDatabaseService.php`:

```php
<?php

namespace App\Services;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;

class EncryptedDatabaseService
{
    protected SecureConfigService $secureConfig;

    public function __construct(SecureConfigService $secureConfig)
    {
        $this->secureConfig = $secureConfig;
    }

    /**
     * Initialize encryption on a new or existing database
     * Note: Requires SQLCipher extension for full encryption
     */
    public function initializeEncryption(): void
    {
        $key = $this->getOrCreateDatabaseKey();

        // For SQLCipher-enabled builds
        if ($this->isSQLCipherAvailable()) {
            DB::statement("PRAGMA key = '$key'");
            DB::statement("PRAGMA cipher_compatibility = 4");
        }
    }

    protected function getOrCreateDatabaseKey(): string
    {
        $existingKey = $this->secureConfig->get('database_encryption_key');

        if ($existingKey) {
            return $existingKey;
        }

        // Generate new key
        $key = bin2hex(random_bytes(32));
        $this->secureConfig->store('database_encryption_key', $key);

        return $key;
    }

    protected function isSQLCipherAvailable(): bool
    {
        try {
            $result = DB::selectOne("PRAGMA cipher_version");
            return $result !== null;
        } catch (\Exception $e) {
            return false;
        }
    }

    /**
     * Create encrypted backup
     */
    public function createEncryptedBackup(string $outputPath): void
    {
        $tempPath = storage_path('app/temp_backup.sqlite');
        $key = $this->secureConfig->get('database_encryption_key');

        // Export to encrypted file
        if ($this->isSQLCipherAvailable()) {
            DB::statement("ATTACH DATABASE '$tempPath' AS encrypted KEY '$key'");
            DB::statement("SELECT sqlcipher_export('encrypted')");
            DB::statement("DETACH DATABASE encrypted");
        } else {
            // Fallback: Copy and encrypt with PHP
            copy(database_path('database.sqlite'), $tempPath);
            $this->encryptFile($tempPath, $outputPath, $key);
            File::delete($tempPath);
            return;
        }

        rename($tempPath, $outputPath);
    }

    protected function encryptFile(string $source, string $dest, string $key): void
    {
        $content = file_get_contents($source);
        $iv = random_bytes(16);
        $encrypted = openssl_encrypt(
            $content,
            'AES-256-CBC',
            hex2bin($key),
            OPENSSL_RAW_DATA,
            $iv
        );

        file_put_contents($dest, $iv . $encrypted);
    }
}
```

### 6.4 Application Signing Configuration

Create `build/signing-config.json`:

```json
{
    "windows": {
        "certificateFile": "${CERT_PATH}/dasipharma-codesign.pfx",
        "certificatePassword": "${CERT_PASSWORD}",
        "signAlgorithm": "sha256",
        "timestampServer": "http://timestamp.digicert.com",
        "publisher": "Dasi Pharmaceuticals Ltd",
        "publisherUrl": "https://dasipharma.ng"
    },
    "macos": {
        "identity": "Developer ID Application: Dasi Pharmaceuticals Ltd (XXXXXXXXXX)",
        "hardenedRuntime": true,
        "gatekeeperAssess": true,
        "entitlements": "build/entitlements.plist",
        "notarize": {
            "appleId": "${APPLE_ID}",
            "appleIdPassword": "${APPLE_ID_PASSWORD}",
            "teamId": "XXXXXXXXXX"
        }
    }
}
```

Create `build/entitlements.plist` (macOS):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.cs.allow-jit</key>
    <false/>
    <key>com.apple.security.cs.allow-unsigned-executable-memory</key>
    <false/>
    <key>com.apple.security.cs.disable-library-validation</key>
    <false/>
    <key>com.apple.security.network.client</key>
    <true/>
    <key>com.apple.security.files.user-selected.read-write</key>
    <true/>
</dict>
</plist>
```

### 6.5 Integrity Verification

Create `app/Console/Commands/VerifyIntegrity.php`:

```php
<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;

class VerifyIntegrity extends Command
{
    protected $signature = 'app:verify-integrity';
    protected $description = 'Verify application file integrity';

    public function handle(): int
    {
        $manifestPath = base_path('.integrity_manifest.json');

        if (! File::exists($manifestPath)) {
            $this->warn('Integrity manifest not found. Generating...');
            return $this->generateManifest();
        }

        $manifest = json_decode(File::get($manifestPath), true);
        $failures = [];

        foreach ($manifest['files'] as $file => $expectedHash) {
            $filePath = base_path($file);

            if (! File::exists($filePath)) {
                $failures[] = [
                    'file' => $file,
                    'reason' => 'File missing'
                ];
                continue;
            }

            $actualHash = hash_file('sha256', $filePath);

            if ($actualHash !== $expectedHash) {
                $failures[] = [
                    'file' => $file,
                    'reason' => 'Hash mismatch',
                    'expected' => substr($expectedHash, 0, 16) . '...',
                    'actual' => substr($actualHash, 0, 16) . '...',
                ];
            }
        }

        if (empty($failures)) {
            $this->info('✓ All files passed integrity check');
            return Command::SUCCESS;
        }

        $this->error('✗ Integrity check failed:');
        foreach ($failures as $failure) {
            $this->line("  - {$failure['file']}: {$failure['reason']}");
        }

        return Command::FAILURE;
    }

    protected function generateManifest(): int
    {
        $files = [];
        $directories = ['app', 'config', 'routes', 'resources/js', 'resources/views'];

        foreach ($directories as $dir) {
            $path = base_path($dir);
            if (! File::isDirectory($path)) continue;

            foreach (File::allFiles($path) as $file) {
                $relativePath = str_replace(base_path() . '/', '', $file->getPathname());
                $files[$relativePath] = hash_file('sha256', $file->getPathname());
            }
        }

        $manifest = [
            'generated_at' => now()->toIso8601String(),
            'version' => config('app.version'),
            'files' => $files,
        ];

        File::put(
            base_path('.integrity_manifest.json'),
            json_encode($manifest, JSON_PRETTY_PRINT)
        );

        $this->info('Integrity manifest generated with ' . count($files) . ' files');

        return Command::SUCCESS;
    }
}
```

---

## 7. Windows Packaging Guide

### 7.1 Windows Build Configuration

Create `build/windows/electron-builder.yml`:

```yaml
appId: ng.dasipharma.desktop
productName: Dasi Pharma
copyright: Copyright © 2026 Dasi Pharmaceuticals Ltd

directories:
  output: dist
  buildResources: build/resources

files:
  - "**/*"
  - "!**/*.{md,txt}"
  - "!tests/**/*"
  - "!storage/logs/*"
  - "!storage/framework/cache/data/*"

extraResources:
  - from: "php/"
    to: "php"
    filter:
      - "**/*"
  - from: "database/"
    to: "database"
    filter:
      - "migrations/**/*"
      - "seeders/**/*"

win:
  target:
    - target: nsis
      arch:
        - x64
    - target: msi
      arch:
        - x64
  icon: build/resources/icon.ico
  publisherName: Dasi Pharmaceuticals Ltd
  verifyUpdateCodeSignature: true
  signAndEditExecutable: true
  signDlls: true

nsis:
  oneClick: false
  allowToChangeInstallationDirectory: true
  perMachine: true
  createDesktopShortcut: true
  createStartMenuShortcut: true
  menuCategory: Dasi Pharma
  shortcutName: Dasi Pharma
  uninstallDisplayName: Dasi Pharma Management System
  installerIcon: build/resources/installer.ico
  uninstallerIcon: build/resources/uninstaller.ico
  installerHeaderIcon: build/resources/header.ico
  license: LICENSE.txt

  include: build/windows/installer.nsh

  # Custom installation pages
  installerSidebar: build/resources/installerSidebar.bmp
  uninstallerSidebar: build/resources/uninstallerSidebar.bmp

msi:
  createDesktopShortcut: true
  createStartMenuShortcut: true
  perMachine: true

publish:
  provider: generic
  url: https://updates.dasipharma.ng/releases
  channel: latest
```

### 7.2 NSIS Custom Installer Script

Create `build/windows/installer.nsh`:

```nsis
!macro customHeader
  !system "echo 'Dasi Pharma Installer'"
!macroend

!macro preInit
  ; Check for admin privileges
  UserInfo::GetAccountType
  Pop $0
  ${If} $0 != "admin"
    MessageBox MB_ICONSTOP "Administrator rights required!"
    SetErrorLevel 740
    Quit
  ${EndIf}
!macroend

!macro customInit
  ; Check Windows version (Windows 10+ required)
  ${IfNot} ${AtLeastWin10}
    MessageBox MB_OK|MB_ICONSTOP "Windows 10 or later is required."
    Quit
  ${EndIf}

  ; Check if application is running
  FindProcDLL::FindProc "DasiPharma.exe"
  ${If} $R0 == 1
    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
      "Dasi Pharma is currently running. Close it to continue installation." \
      IDOK closeApp IDCANCEL cancelInstall
    closeApp:
      KillProcDLL::KillProc "DasiPharma.exe"
      Sleep 2000
      Goto done
    cancelInstall:
      Quit
    done:
  ${EndIf}
!macroend

!macro customInstall
  ; Create data directories
  CreateDirectory "$LOCALAPPDATA\DasiPharma"
  CreateDirectory "$LOCALAPPDATA\DasiPharma\backups"
  CreateDirectory "$LOCALAPPDATA\DasiPharma\logs"

  ; Set environment variable
  WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" \
    "DASI_PHARMA_DATA" "$LOCALAPPDATA\DasiPharma"

  ; Add Windows Firewall exception
  nsExec::ExecToLog 'netsh advfirewall firewall add rule name="Dasi Pharma" \
    dir=in action=allow program="$INSTDIR\DasiPharma.exe" enable=yes'

  ; Register file associations (optional)
  WriteRegStr HKCR ".dpbak" "" "DasiPharma.Backup"
  WriteRegStr HKCR "DasiPharma.Backup" "" "Dasi Pharma Backup"
  WriteRegStr HKCR "DasiPharma.Backup\shell\open\command" "" '"$INSTDIR\DasiPharma.exe" --restore "%1"'
!macroend

!macro customUnInstall
  ; Remove firewall rule
  nsExec::ExecToLog 'netsh advfirewall firewall delete rule name="Dasi Pharma"'

  ; Remove environment variable
  DeleteRegValue HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" \
    "DASI_PHARMA_DATA"

  ; Ask about data removal
  MessageBox MB_YESNO|MB_ICONQUESTION \
    "Remove all application data including database and backups?" IDNO skipDataRemoval
    RMDir /r "$LOCALAPPDATA\DasiPharma"
  skipDataRemoval:

  ; Remove file associations
  DeleteRegKey HKCR ".dpbak"
  DeleteRegKey HKCR "DasiPharma.Backup"
!macroend
```

### 7.3 MSI Package Configuration

Create `build/windows/wix-config.json`:

```json
{
    "name": "DasiPharma",
    "manufacturer": "Dasi Pharmaceuticals Ltd",
    "version": "1.0.0",
    "arch": "x64",
    "ui": {
        "enabled": true,
        "chooseDirectory": true,
        "template": "WixUI_InstallDir"
    },
    "registry": [
        {
            "root": "HKLM",
            "key": "Software\\DasiPharma",
            "values": [
                {
                    "name": "InstallPath",
                    "type": "string",
                    "value": "[INSTALLDIR]"
                },
                {
                    "name": "Version",
                    "type": "string",
                    "value": "1.0.0"
                }
            ]
        }
    ],
    "environment": [
        {
            "name": "DASI_PHARMA_DATA",
            "value": "[LocalAppDataFolder]DasiPharma",
            "system": true
        }
    ],
    "shortcuts": [
        {
            "target": "[INSTALLDIR]DasiPharma.exe",
            "name": "Dasi Pharma",
            "description": "Pharmacy Management System",
            "desktop": true,
            "startMenu": true,
            "icon": "[INSTALLDIR]resources\\icon.ico"
        }
    ],
    "upgrade": {
        "majorUpgrade": {
            "schedule": "afterInstallInitialize",
            "downgradeErrorMessage": "A newer version is already installed."
        }
    },
    "features": [
        {
            "id": "MainApplication",
            "title": "Dasi Pharma Application",
            "description": "Core application files",
            "level": 1,
            "components": ["MainExecutable", "PHPRuntime", "Resources"]
        },
        {
            "id": "DesktopShortcut",
            "title": "Desktop Shortcut",
            "description": "Create desktop shortcut",
            "level": 1
        }
    ]
}
```

### 7.4 Code Signing Script

Create `build/scripts/sign-windows.ps1`:

```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath,

    [Parameter(Mandatory=$true)]
    [string]$CertificatePath,

    [Parameter(Mandatory=$true)]
    [string]$CertificatePassword,

    [string]$TimestampServer = "http://timestamp.digicert.com"
)

$ErrorActionPreference = "Stop"

# Verify file exists
if (-not (Test-Path $FilePath)) {
    throw "File not found: $FilePath"
}

# Find signtool
$signtool = Get-ChildItem -Path "C:\Program Files (x86)\Windows Kits\10\bin" `
    -Recurse -Filter "signtool.exe" |
    Where-Object { $_.FullName -match "x64" } |
    Select-Object -First 1 -ExpandProperty FullName

if (-not $signtool) {
    throw "signtool.exe not found. Install Windows SDK."
}

Write-Host "Signing: $FilePath"

# Sign with SHA-256
& $signtool sign `
    /f $CertificatePath `
    /p $CertificatePassword `
    /fd sha256 `
    /tr $TimestampServer `
    /td sha256 `
    /d "Dasi Pharma Management System" `
    /du "https://dasipharma.ng" `
    $FilePath

if ($LASTEXITCODE -ne 0) {
    throw "Signing failed with exit code: $LASTEXITCODE"
}

# Verify signature
& $signtool verify /pa $FilePath

if ($LASTEXITCODE -ne 0) {
    throw "Signature verification failed"
}

Write-Host "Successfully signed: $FilePath"
```

### 7.5 Windows Defender and Antivirus Compatibility

Create `build/scripts/submit-for-analysis.ps1`:

```powershell
<#
.SYNOPSIS
    Submit application to Microsoft for malware analysis
.DESCRIPTION
    Submits the installer to Microsoft Defender for review to
    prevent false positive detections
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$InstallerPath,

    [Parameter(Mandatory=$true)]
    [string]$CompanyName,

    [Parameter(Mandatory=$true)]
    [string]$ContactEmail
)

# Microsoft submission endpoint
$submissionUrl = "https://www.microsoft.com/en-us/wdsi/filesubmission"

Write-Host @"
================================================================================
MICROSOFT DEFENDER FALSE POSITIVE PREVENTION
================================================================================

To prevent Windows Defender from flagging your installer:

1. Code Sign the Installer
   - Use an EV (Extended Validation) code signing certificate
   - EV certificates provide immediate SmartScreen reputation
   - Standard certificates require reputation building

2. Submit for Analysis
   - Visit: $submissionUrl
   - Select "I believe this file should not be detected"
   - Upload: $InstallerPath
   - Company: $CompanyName
   - Contact: $ContactEmail

3. Apply for SmartScreen Reputation
   - With EV certificate: Immediate reputation
   - Without EV: Submit at https://www.microsoft.com/security/portal

4. Test Installation on Clean Machine
   - Use Windows Sandbox or fresh VM
   - Enable all Windows Security features
   - Document any warnings for support team

5. Antivirus Vendor Submissions
   - Submit to major AV vendors' false positive portals:
     * Norton: https://submit.norton.com/
     * McAfee: https://www.mcafee.com/enterprise/en-us/threat-center/product-security-bulletins.html
     * Kaspersky: https://virusdesk.kaspersky.com/
     * Avast/AVG: https://www.avast.com/false-positive-file-form.php

================================================================================
"@

# Generate submission package info
$info = @{
    "file" = (Get-Item $InstallerPath).Name
    "size" = (Get-Item $InstallerPath).Length
    "sha256" = (Get-FileHash $InstallerPath -Algorithm SHA256).Hash
    "company" = $CompanyName
    "contact" = $ContactEmail
    "submitted" = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

$info | ConvertTo-Json | Out-File "submission_info.json"
Write-Host "Submission info saved to submission_info.json"
```

---

## 8. Implementation Roadmap

### 8.1 Development Environment Setup

#### Prerequisites

```bash
# Required software
Node.js >= 18.x
PHP >= 8.1
Composer >= 2.x
Git

# Platform-specific
Windows: Visual Studio Build Tools, Windows SDK
macOS: Xcode Command Line Tools
Linux: build-essential, libgtk-3-dev, libwebkit2gtk-4.0-dev
```

#### Step 1: Install NativePHP

```bash
# Navigate to project directory
cd "Desktop/dasi pharma"

# Install NativePHP
composer require nativephp/electron

# Publish NativePHP configuration
php artisan vendor:publish --provider="Native\Laravel\NativeServiceProvider"

# Install npm dependencies for Electron
npm install

# Build frontend assets for production
npm run build
```

#### Step 2: Configure NativePHP

Create/update `config/nativephp.php`:

```php
<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Application ID
    |--------------------------------------------------------------------------
    */
    'app_id' => 'ng.dasipharma.desktop',

    /*
    |--------------------------------------------------------------------------
    | Application Name
    |--------------------------------------------------------------------------
    */
    'name' => 'Dasi Pharma',

    /*
    |--------------------------------------------------------------------------
    | Application Version
    |--------------------------------------------------------------------------
    */
    'version' => '1.0.0',

    /*
    |--------------------------------------------------------------------------
    | Author
    |--------------------------------------------------------------------------
    */
    'author' => 'Dasi Pharmaceuticals Ltd',

    /*
    |--------------------------------------------------------------------------
    | Default Window Dimensions
    |--------------------------------------------------------------------------
    */
    'width' => 1400,
    'height' => 900,
    'min_width' => 1024,
    'min_height' => 768,

    /*
    |--------------------------------------------------------------------------
    | Auto-Updater
    |--------------------------------------------------------------------------
    */
    'updater' => [
        'enabled' => true,
        'default' => 'github',
        'github' => [
            'owner' => 'your-organization',
            'repo' => 'dasi-pharma-releases',
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Cleanup
    |--------------------------------------------------------------------------
    */
    'cleanup_exclude' => [
        'database/database.sqlite',
        'storage/app/**',
        'storage/logs/**',
    ],
];
```

### 8.2 Project File Structure

Create the necessary build configuration files:

```
dasi-pharma/
├── app/
│   ├── Console/Commands/
│   │   ├── InitializeDatabase.php
│   │   ├── ValidateInstallation.php
│   │   ├── RepairDatabase.php
│   │   ├── RollbackUpdate.php
│   │   └── VerifyIntegrity.php
│   ├── Providers/
│   │   └── NativeAppServiceProvider.php
│   └── Services/
│       ├── DatabaseBackupService.php
│       ├── DatabaseUpdateService.php
│       ├── EncryptedDatabaseService.php
│       ├── SecureConfigService.php
│       └── UpdateService.php
├── build/
│   ├── resources/
│   │   ├── icon.ico
│   │   ├── icon.icns
│   │   ├── icon.png
│   │   ├── installer.ico
│   │   ├── installerSidebar.bmp
│   │   └── uninstallerSidebar.bmp
│   ├── scripts/
│   │   ├── sign-windows.ps1
│   │   └── submit-for-analysis.ps1
│   ├── windows/
│   │   ├── electron-builder.yml
│   │   ├── installer.nsh
│   │   └── wix-config.json
│   ├── entitlements.plist
│   └── signing-config.json
├── config/
│   └── nativephp.php
├── scripts/
│   ├── silent-install.ps1
│   └── uninstall.ps1
└── .env.desktop
```

### 8.3 Desktop Environment Configuration

Create `.env.desktop`:

```env
APP_NAME="Dasi Pharma"
APP_ENV=production
APP_DEBUG=false
APP_URL=http://127.0.0.1:8100

LOG_CHANNEL=daily
LOG_LEVEL=warning

DB_CONNECTION=sqlite

CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=480

# Desktop-specific
NATIVEPHP_UPDATER_ENABLED=true
DASI_PHARMA_DATA="${LOCALAPPDATA}/DasiPharma"
```

### 8.4 Build Automation Script

Create `build.js` in project root:

```javascript
#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const VERSION = process.env.VERSION || '1.0.0';
const PLATFORM = process.platform;

console.log(`Building Dasi Pharma v${VERSION} for ${PLATFORM}`);

// Step 1: Clean previous builds
console.log('\n📦 Cleaning previous builds...');
if (fs.existsSync('dist')) {
    fs.rmSync('dist', { recursive: true });
}

// Step 2: Install dependencies
console.log('\n📦 Installing dependencies...');
execSync('composer install --no-dev --optimize-autoloader', { stdio: 'inherit' });
execSync('npm ci', { stdio: 'inherit' });

// Step 3: Build frontend assets
console.log('\n🔨 Building frontend assets...');
execSync('npm run build', { stdio: 'inherit' });

// Step 4: Optimize Laravel
console.log('\n⚡ Optimizing Laravel...');
execSync('php artisan config:cache', { stdio: 'inherit' });
execSync('php artisan route:cache', { stdio: 'inherit' });
execSync('php artisan view:cache', { stdio: 'inherit' });

// Step 5: Generate integrity manifest
console.log('\n🔐 Generating integrity manifest...');
execSync('php artisan app:verify-integrity', { stdio: 'inherit' });

// Step 6: Build native app
console.log('\n🖥️ Building native application...');
execSync('php artisan native:build', { stdio: 'inherit' });

// Step 7: Sign the application (Windows)
if (PLATFORM === 'win32' && process.env.CERT_PATH) {
    console.log('\n✍️ Signing application...');
    const distFiles = fs.readdirSync('dist').filter(f =>
        f.endsWith('.exe') || f.endsWith('.msi')
    );

    for (const file of distFiles) {
        execSync(`powershell -File build/scripts/sign-windows.ps1 \
            -FilePath "dist/${file}" \
            -CertificatePath "${process.env.CERT_PATH}" \
            -CertificatePassword "${process.env.CERT_PASSWORD}"`,
            { stdio: 'inherit' }
        );
    }
}

console.log('\n✅ Build complete! Output in ./dist');
```

### 8.5 GitHub Actions CI/CD Pipeline

Create `.github/workflows/build-desktop.yml`:

```yaml
name: Build Desktop Application

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:
    inputs:
      version:
        description: 'Version number'
        required: true
        default: '1.0.0'

env:
  VERSION: ${{ github.event.inputs.version || github.ref_name }}

jobs:
  build-windows:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
          extensions: sqlite3, pdo_sqlite, zip

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: |
          composer install --no-dev --optimize-autoloader
          npm ci

      - name: Build frontend
        run: npm run build

      - name: Build native app
        run: php artisan native:build
        env:
          APP_ENV: production

      - name: Sign application
        if: env.CERT_BASE64 != ''
        run: |
          echo "${{ secrets.WINDOWS_CERT_BASE64 }}" | base64 -d > cert.pfx
          powershell -File build/scripts/sign-windows.ps1 `
            -FilePath "dist/*.exe" `
            -CertificatePath "cert.pfx" `
            -CertificatePassword "${{ secrets.CERT_PASSWORD }}"
        env:
          CERT_BASE64: ${{ secrets.WINDOWS_CERT_BASE64 }}

      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: windows-build
          path: dist/*.exe

  build-macos:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
          extensions: sqlite3, pdo_sqlite, zip

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: |
          composer install --no-dev --optimize-autoloader
          npm ci

      - name: Build frontend
        run: npm run build

      - name: Build native app
        run: php artisan native:build
        env:
          APP_ENV: production

      - name: Sign and notarize (macOS)
        if: env.APPLE_ID != ''
        run: |
          # Sign app
          codesign --deep --force --verify --verbose \
            --sign "${{ secrets.APPLE_SIGNING_IDENTITY }}" \
            --options runtime \
            dist/*.app

          # Create DMG
          hdiutil create -volname "Dasi Pharma" \
            -srcfolder dist/*.app \
            -ov -format UDZO \
            dist/DasiPharma-${{ env.VERSION }}.dmg

          # Notarize
          xcrun notarytool submit dist/*.dmg \
            --apple-id "${{ secrets.APPLE_ID }}" \
            --password "${{ secrets.APPLE_ID_PASSWORD }}" \
            --team-id "${{ secrets.APPLE_TEAM_ID }}" \
            --wait
        env:
          APPLE_ID: ${{ secrets.APPLE_ID }}

      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: macos-build
          path: dist/*.dmg

  build-linux:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install system dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y libgtk-3-dev libwebkit2gtk-4.0-dev

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
          extensions: sqlite3, pdo_sqlite, zip

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: |
          composer install --no-dev --optimize-autoloader
          npm ci

      - name: Build frontend
        run: npm run build

      - name: Build native app
        run: php artisan native:build --linux
        env:
          APP_ENV: production

      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: linux-build
          path: dist/*.AppImage

  release:
    needs: [build-windows, build-macos, build-linux]
    runs-on: ubuntu-latest
    if: startsWith(github.ref, 'refs/tags/')
    steps:
      - name: Download all artifacts
        uses: actions/download-artifact@v4
        with:
          path: dist

      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          files: dist/**/*
          generate_release_notes: true
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### 8.6 Testing Strategy

Create `tests/Feature/DesktopInstallationTest.php`:

```php
<?php

namespace Tests\Feature;

use App\Services\DatabaseBackupService;
use App\Services\DatabaseUpdateService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\File;
use Tests\TestCase;

class DesktopInstallationTest extends TestCase
{
    use RefreshDatabase;

    public function test_database_initialization()
    {
        $this->artisan('app:initialize-database', ['--seed' => true])
            ->assertExitCode(0);

        $this->assertDatabaseHas('users', ['email' => 'admin@dasipharma.ng']);
        $this->assertDatabaseHas('roles', ['name' => 'Super Admin']);
        $this->assertDatabaseHas('branches', []);
    }

    public function test_database_backup_creation()
    {
        $service = new DatabaseBackupService();

        $backupPath = $service->createBackup('test');

        $this->assertFileExists($backupPath);
        $this->assertStringContainsString('test_backup_', basename($backupPath));

        // Cleanup
        File::delete($backupPath);
    }

    public function test_database_backup_restoration()
    {
        $service = new DatabaseBackupService();

        // Create a user
        \App\Models\User::factory()->create(['email' => 'test@example.com']);

        // Create backup
        $backupPath = $service->createBackup('test');

        // Delete user
        \App\Models\User::where('email', 'test@example.com')->delete();
        $this->assertDatabaseMissing('users', ['email' => 'test@example.com']);

        // Restore backup
        $service->restoreBackup($backupPath);

        // User should be back
        $this->assertDatabaseHas('users', ['email' => 'test@example.com']);

        // Cleanup
        File::delete($backupPath);
    }

    public function test_database_integrity_check()
    {
        $this->artisan('app:repair-database', ['--check-only' => true])
            ->assertExitCode(0);
    }

    public function test_installation_validation()
    {
        $this->artisan('app:validate-installation')
            ->assertExitCode(0);
    }

    public function test_pending_migrations_detection()
    {
        $service = new DatabaseUpdateService();

        $pending = $service->checkPendingMigrations();

        $this->assertIsArray($pending);
    }
}
```

### 8.7 Deployment Checklist

```markdown
## Pre-Release Checklist

### Code Preparation
- [ ] Update version in `config/nativephp.php`
- [ ] Update version in `package.json`
- [ ] Update CHANGELOG.md
- [ ] Run full test suite: `php artisan test`
- [ ] Check for security vulnerabilities: `composer audit`
- [ ] Verify all migrations work on fresh database
- [ ] Test upgrade path from previous version

### Build Verification
- [ ] Build on Windows (64-bit)
- [ ] Build on macOS (Intel + Apple Silicon)
- [ ] Build on Linux (AppImage)
- [ ] Verify code signing on all platforms
- [ ] Test fresh installation on clean VMs
- [ ] Test upgrade installation from previous version
- [ ] Verify auto-update mechanism works

### Security
- [ ] Code signing certificates are valid and not expiring soon
- [ ] Submit to Windows SmartScreen if using new certificate
- [ ] macOS notarization completed
- [ ] Integrity manifest generated
- [ ] Environment variables properly secured

### Documentation
- [ ] Update user manual with new features
- [ ] Update API documentation if applicable
- [ ] Prepare release notes for users
- [ ] Update support team with known issues

### Distribution
- [ ] Upload to release server
- [ ] Update `latest.json` manifest
- [ ] Verify download URLs work
- [ ] Test auto-update from previous version
- [ ] Notify users of available update
```

### 8.8 Quick Start Commands

```bash
# Development
php artisan native:serve              # Run in development mode

# Building
php artisan native:build              # Build for current platform
php artisan native:build --win        # Build for Windows
php artisan native:build --mac        # Build for macOS
php artisan native:build --linux      # Build for Linux

# Database Management
php artisan app:initialize-database --seed    # First-time setup
php artisan app:repair-database --check-only  # Check integrity
php artisan app:validate-installation         # Verify installation

# Updates
php artisan app:rollback-update       # Rollback failed update
```

---

## Appendix A: Troubleshooting Guide

### Common Issues

#### 1. Application Won't Start

```powershell
# Windows: Check if port is in use
netstat -ano | findstr :8100

# Clear application cache
"%LOCALAPPDATA%\DasiPharma\cache" /S /Q

# Check logs
type "%LOCALAPPDATA%\DasiPharma\logs\laravel.log"
```

#### 2. Database Corruption

```bash
# Check database integrity
php artisan app:repair-database --check-only

# Repair if needed
php artisan app:repair-database --force

# Restore from backup if repair fails
php artisan app:rollback-update --backup="path/to/backup.zip"
```

#### 3. Update Failures

```bash
# Check for pending migrations
php artisan migrate:status

# Force run migrations
php artisan migrate --force

# Rollback to previous version
php artisan app:rollback-update
```

#### 4. White Screen / Blank Window

- Check if frontend assets are built: `public/build/` should contain files
- Verify Vite manifest exists: `public/build/manifest.json`
- Check browser console for JavaScript errors
- Ensure SQLite database file exists and is readable

### Log Locations

| Platform | Application Logs | Database |
|----------|-----------------|----------|
| Windows | `%LOCALAPPDATA%\DasiPharma\logs\` | `%LOCALAPPDATA%\DasiPharma\database.sqlite` |
| macOS | `~/Library/Application Support/DasiPharma/logs/` | `~/Library/Application Support/DasiPharma/database.sqlite` |
| Linux | `~/.local/share/DasiPharma/logs/` | `~/.local/share/DasiPharma/database.sqlite` |

---

## Appendix B: Version Compatibility Matrix

| App Version | Min PHP | Laravel | Node.js | Electron | SQLite |
|-------------|---------|---------|---------|----------|--------|
| 1.0.x | 8.1 | 10.x | 18.x | 28.x | 3.x |
| 1.1.x | 8.2 | 10.x | 20.x | 29.x | 3.x |
| 2.0.x | 8.3 | 11.x | 20.x | 30.x | 3.x |

---

## Appendix C: Regulatory Compliance Notes

### Pharmaceutical Data Requirements

1. **Data Integrity**: All transactions are logged with timestamps and user identification
2. **Audit Trail**: Stock movements, sales, and returns maintain complete audit history
3. **Backup Requirements**: Automatic daily backups recommended for regulatory compliance
4. **Access Control**: Role-based permissions ensure data access is restricted appropriately

### NAFDAC Compliance (Nigeria)

- Batch number tracking for all pharmaceutical products
- Expiry date monitoring with configurable alerts
- Complete inventory movement history
- Return and disposal tracking

### Data Retention

Configure in `config/app.php`:

```php
'data_retention' => [
    'logs' => 365,        // Keep logs for 1 year
    'backups' => 90,      // Keep backups for 90 days
    'audit_trail' => 2555, // Keep audit trail for 7 years
],
```

---

## Appendix D: Performance Benchmarks

### Recommended System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | Dual-core 2.0 GHz | Quad-core 2.5 GHz |
| RAM | 4 GB | 8 GB |
| Storage | 500 MB free | 2 GB free (SSD) |
| Display | 1024x768 | 1920x1080 |
| OS | Windows 10 | Windows 11 |

### Expected Performance

| Operation | Expected Time |
|-----------|---------------|
| Application startup | < 5 seconds |
| POS sale completion | < 1 second |
| Product search (1000 items) | < 500ms |
| Report generation (30 days) | < 3 seconds |
| Backup creation | < 30 seconds |
| Database migration | < 60 seconds |

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2026-01-09 | System Architect | Initial specification |

---

**End of Specification Document**
```

