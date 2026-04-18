<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * This migration allows barcode reuse for soft-deleted products by:
     * 1. Dropping the existing unique constraint on barcode
     * 2. Creating a conditional unique index that only applies to active (non-deleted) records
     *
     * This enables the system to reuse barcodes from deleted products while maintaining
     * uniqueness for active products.
     */
    public function up(): void
    {
        // Drop the existing unique constraint on barcode
        Schema::table('drugs', function (Blueprint $table) {
            $table->dropUnique(['barcode']);
        });

        // Create a conditional unique index for active (non-deleted) records only
        // MySQL syntax: CREATE UNIQUE INDEX ... WHERE deleted_at IS NULL
        // Note: Laravel doesn't support partial indexes in Blueprint, so we use raw SQL
        $driver = DB::getDriverName();

        if ($driver === 'mysql') {
            // For MySQL 8.0+, we can't use partial indexes directly
            // Instead, we'll create a unique index and rely on application-level validation
            // The validation in controllers now uses Rule::unique()->whereNull('deleted_at')

            // Create a regular index for performance (non-unique)
            DB::statement('CREATE INDEX drugs_barcode_index ON drugs (barcode)');

        } elseif ($driver === 'pgsql') {
            // PostgreSQL supports partial indexes
            DB::statement('CREATE UNIQUE INDEX drugs_barcode_unique_active ON drugs (barcode) WHERE deleted_at IS NULL');

        } elseif ($driver === 'sqlite') {
            // SQLite also supports partial indexes
            DB::statement('CREATE UNIQUE INDEX drugs_barcode_unique_active ON drugs (barcode) WHERE deleted_at IS NULL');
        }
    }

    /**
     * Reverse the migrations.
     *
     * Restores the original unique constraint on barcode.
     */
    public function down(): void
    {
        $driver = DB::getDriverName();

        // Drop the conditional index
        if ($driver === 'mysql') {
            DB::statement('DROP INDEX drugs_barcode_index ON drugs');
        } elseif ($driver === 'pgsql') {
            DB::statement('DROP INDEX IF EXISTS drugs_barcode_unique_active');
        } elseif ($driver === 'sqlite') {
            DB::statement('DROP INDEX IF EXISTS drugs_barcode_unique_active');
        }

        // Restore the original unique constraint
        Schema::table('drugs', function (Blueprint $table) {
            $table->unique('barcode');
        });
    }
};
