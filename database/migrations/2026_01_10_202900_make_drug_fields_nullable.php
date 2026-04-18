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
     * Makes optional drug fields nullable to allow creating drugs
     * without all fields filled in from the quick-add modal.
     */
    public function up(): void
    {
        $driver = DB::getDriverName();

        if ($driver === 'sqlite') {
            // For SQLite, temporarily disable foreign key constraints
            DB::statement('PRAGMA foreign_keys = OFF');

            Schema::table('drugs', function (Blueprint $table) {
                $table->string('generic_name')->nullable()->change();
                $table->string('strength', 50)->nullable()->change();
                $table->string('dosage_form', 50)->nullable()->change();
            });

            // Re-enable foreign key constraints
            DB::statement('PRAGMA foreign_keys = ON');
        } else {
            Schema::table('drugs', function (Blueprint $table) {
                $table->string('generic_name')->nullable()->change();
                $table->string('strength', 50)->nullable()->change();
                $table->string('dosage_form', 50)->nullable()->change();
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        $driver = DB::getDriverName();

        if ($driver === 'sqlite') {
            // For SQLite, temporarily disable foreign key constraints
            DB::statement('PRAGMA foreign_keys = OFF');

            Schema::table('drugs', function (Blueprint $table) {
                $table->string('generic_name')->nullable(false)->change();
                $table->string('strength', 50)->nullable(false)->change();
                $table->string('dosage_form', 50)->nullable(false)->change();
            });

            // Re-enable foreign key constraints
            DB::statement('PRAGMA foreign_keys = ON');
        } else {
            Schema::table('drugs', function (Blueprint $table) {
                $table->string('generic_name')->nullable(false)->change();
                $table->string('strength', 50)->nullable(false)->change();
                $table->string('dosage_form', 50)->nullable(false)->change();
            });
        }
    }
};

