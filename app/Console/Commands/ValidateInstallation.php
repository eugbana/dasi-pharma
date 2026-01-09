<?php

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
        $requiredTables = ['users', 'roles', 'branches', 'drugs', 'sales', 'permissions'];
        foreach ($requiredTables as $table) {
            try {
                $checks["Table: $table"] = DB::getSchemaBuilder()->hasTable($table);
            } catch (\Exception $e) {
                $checks["Table: $table"] = false;
            }
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
            $dirName = basename(dirname($dir)) . '/' . basename($dir);
            if (File::isDirectory($dir)) {
                $checks["Dir: $dirName"] = File::isWritable($dir);
            } else {
                $checks["Dir: $dirName"] = false;
            }
        }

        // Check default admin user exists
        try {
            $checks['Admin User'] = \App\Models\User::where('email', 'admin@dasipharma.ng')->exists();
        } catch (\Exception $e) {
            $checks['Admin User'] = false;
        }

        // Check database file exists and is readable
        $dbPath = database_path('database.sqlite');
        $checks['Database File'] = File::exists($dbPath) && File::isReadable($dbPath);

        // Check public build assets
        $manifestPath = public_path('build/manifest.json');
        $checks['Frontend Assets'] = File::exists($manifestPath);

        // Output results
        $failed = false;
        $this->newLine();
        $this->info('=== Installation Validation Results ===');
        $this->newLine();

        foreach ($checks as $check => $passed) {
            if ($passed) {
                $this->line("  <fg=green>✓</> $check");
            } else {
                $this->line("  <fg=red>✗</> $check");
                $failed = true;
            }
        }

        $this->newLine();
        
        if ($failed) {
            $this->error('Some validation checks failed. Please review and fix the issues above.');
            return Command::FAILURE;
        }

        $this->info('All validation checks passed!');
        return Command::SUCCESS;
    }
}

