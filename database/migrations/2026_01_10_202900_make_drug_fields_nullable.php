<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

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
        Schema::table('drugs', function (Blueprint $table) {
            $table->string('generic_name')->nullable()->change();
            $table->string('strength', 50)->nullable()->change();
            $table->string('dosage_form', 50)->nullable()->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('drugs', function (Blueprint $table) {
            $table->string('generic_name')->nullable(false)->change();
            $table->string('strength', 50)->nullable(false)->change();
            $table->string('dosage_form', 50)->nullable(false)->change();
        });
    }
};

