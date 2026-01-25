<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Adds discount authorization tracking to sales table.
     * When a discount is applied, we need to record who authorized it.
     */
    public function up(): void
    {
        Schema::table('sales', function (Blueprint $table) {
            $table->foreignId('discount_authorized_by')->nullable()
                ->after('discount_amount')
                ->constrained('users')
                ->comment('User who authorized the discount');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('sales', function (Blueprint $table) {
            $table->dropForeign(['discount_authorized_by']);
            $table->dropColumn('discount_authorized_by');
        });
    }
};

