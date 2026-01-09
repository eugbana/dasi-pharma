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
        $this->newLine();
        
        $dbPath = database_path('database.sqlite');
        
        if (! File::exists($dbPath)) {
            $this->error('Database file not found!');
            return Command::FAILURE;
        }

        // Display database info
        $dbSize = File::size($dbPath);
        $this->line("Database: $dbPath");
        $this->line("Size: " . number_format($dbSize / 1024, 2) . " KB");
        $this->newLine();

        // Run SQLite integrity check
        $this->info('Running integrity check...');
        $result = DB::select("PRAGMA integrity_check");
        $integrityOk = $result[0]->integrity_check === 'ok';
        
        if ($integrityOk) {
            $this->line("  <fg=green>✓</> Database integrity check passed");
        } else {
            $this->line("  <fg=red>✗</> Database integrity check failed");
            $this->line("  Result: " . $result[0]->integrity_check);
        }

        // Check foreign keys
        $fkCheck = DB::select("PRAGMA foreign_key_check");
        if (empty($fkCheck)) {
            $this->line("  <fg=green>✓</> Foreign key constraints are valid");
        } else {
            $this->line("  <fg=yellow>⚠</> Foreign key violations found: " . count($fkCheck));
            foreach (array_slice($fkCheck, 0, 5) as $violation) {
                $this->line("    - Table: {$violation->table}, RowID: {$violation->rowid}");
            }
            if (count($fkCheck) > 5) {
                $this->line("    ... and " . (count($fkCheck) - 5) . " more");
            }
        }

        // Check for orphaned records
        $this->newLine();
        $this->info('Checking for data issues...');
        
        // Example check: Sales without users
        try {
            $orphanedSales = DB::table('sales')
                ->leftJoin('users', 'sales.user_id', '=', 'users.id')
                ->whereNull('users.id')
                ->count();
            
            if ($orphanedSales > 0) {
                $this->line("  <fg=yellow>⚠</> Found $orphanedSales sales without valid user");
            } else {
                $this->line("  <fg=green>✓</> No orphaned sales records");
            }
        } catch (\Exception $e) {
            $this->line("  <fg=gray>-</> Could not check sales records");
        }

        if ($this->option('check-only')) {
            $this->newLine();
            return $integrityOk ? Command::SUCCESS : Command::FAILURE;
        }

        // Vacuum to reclaim space and optimize
        $this->newLine();
        if ($integrityOk) {
            if ($this->option('force') || $this->confirm('Run VACUUM to optimize database?', true)) {
                $this->info('Running VACUUM...');
                $sizeBefore = File::size($dbPath);
                DB::statement("VACUUM");
                clearstatcache();
                $sizeAfter = File::size($dbPath);
                
                $saved = $sizeBefore - $sizeAfter;
                if ($saved > 0) {
                    $this->line("  Space reclaimed: " . number_format($saved / 1024, 2) . " KB");
                } else {
                    $this->line("  Database is already optimized");
                }
            }
        }

        // Analyze database for better query planning
        $this->newLine();
        $this->info('Updating database statistics...');
        DB::statement("ANALYZE");
        $this->line("  Statistics updated successfully");

        // Reindex for performance
        if ($this->option('force') || $this->confirm('Rebuild all indexes?', true)) {
            $this->newLine();
            $this->info('Rebuilding indexes...');
            DB::statement("REINDEX");
            $this->line("  Indexes rebuilt successfully");
        }

        $this->newLine();
        $this->info('Database maintenance complete!');

        return Command::SUCCESS;
    }
}

