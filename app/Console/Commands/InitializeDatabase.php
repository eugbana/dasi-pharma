<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;

class InitializeDatabase extends Command
{
    protected $signature = 'app:initialize-database 
                            {--fresh : Drop all tables and re-migrate}
                            {--seed : Run seeders after migration}';
                            
    protected $description = 'Initialize or reset the application database';

    public function handle(): int
    {
        $dbPath = database_path('database.sqlite');
        
        // Create database file if it doesn't exist
        if (! File::exists($dbPath)) {
            File::put($dbPath, '');
            $this->info('Created new SQLite database file.');
        }

        // Run migrations
        $this->info('Running database migrations...');
        
        $migrateCommand = $this->option('fresh') ? 'migrate:fresh' : 'migrate';
        
        try {
            Artisan::call($migrateCommand, [
                '--force' => true,
                '--no-interaction' => true,
            ]);
            
            $this->info(Artisan::output());
        } catch (\Exception $e) {
            $this->error('Migration failed: ' . $e->getMessage());
            return Command::FAILURE;
        }

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
            try {
                $this->info("  Running $seeder...");
                Artisan::call('db:seed', [
                    '--class' => $seeder,
                    '--force' => true,
                ]);
            } catch (\Exception $e) {
                $this->warn("  Seeder $seeder failed: " . $e->getMessage());
            }
        }
    }

    protected function recordMigrationVersion(): void
    {
        $version = config('app.version', '1.0.0');
        $dataPath = env('DASI_PHARMA_DATA', storage_path());
        
        if (! File::isDirectory($dataPath)) {
            File::makeDirectory($dataPath, 0755, true);
        }
        
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

