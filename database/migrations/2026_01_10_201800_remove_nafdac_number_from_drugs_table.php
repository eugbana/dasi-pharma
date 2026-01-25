<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

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
        Schema::table('drugs', function (Blueprint $table) {
            // Drop the unique index first if it exists
            $table->dropUnique(['nafdac_number']);
        });

        Schema::table('drugs', function (Blueprint $table) {
            // Then drop the column
            $table->dropColumn('nafdac_number');
        });
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

