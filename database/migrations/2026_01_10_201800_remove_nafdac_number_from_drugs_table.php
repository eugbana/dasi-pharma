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
     * Removes the nafdac_number field from the drugs table as it's not
     * being used in the application forms and causing database errors.
     */
    public function up(): void
    {
        // Check if the column exists before trying to drop it
        if (Schema::hasColumn('drugs', 'nafdac_number')) {
            $driver = DB::getDriverName();

            if ($driver === 'sqlite') {
                // For SQLite, we need to drop all indexes related to the column first
                // Check and drop unique index
                $uniqueIndexExists = DB::select("SELECT name FROM sqlite_master WHERE type='index' AND name='drugs_nafdac_number_unique'");
                if (!empty($uniqueIndexExists)) {
                    DB::statement('DROP INDEX drugs_nafdac_number_unique');
                }

                // Check and drop regular index
                $indexExists = DB::select("SELECT name FROM sqlite_master WHERE type='index' AND name='drugs_nafdac_number_index'");
                if (!empty($indexExists)) {
                    DB::statement('DROP INDEX drugs_nafdac_number_index');
                }
            } else {
                // For other databases, attempt to drop the unique constraint
                try {
                    Schema::table('drugs', function (Blueprint $table) {
                        $table->dropUnique(['nafdac_number']);
                    });
                } catch (\Exception $e) {
                    // Index might not exist, continue
                }

                try {
                    Schema::table('drugs', function (Blueprint $table) {
                        $table->dropIndex(['nafdac_number']);
                    });
                } catch (\Exception $e) {
                    // Index might not exist, continue
                }
            }

            // Drop the column
            Schema::table('drugs', function (Blueprint $table) {
                $table->dropColumn('nafdac_number');
            });
        }
    }

    /**
     * Reverse the migrations.
     *
     * Restores the nafdac_number field in case we need it later.
     */
    public function down(): void
    {
        Schema::table('drugs', function (Blueprint $table) {
            $table->string('nafdac_number')->nullable()->unique()->after('manufacturer');
        });
    }
};

