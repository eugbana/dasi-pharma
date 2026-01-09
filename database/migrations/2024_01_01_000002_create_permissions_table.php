<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the permissions table for granular access control.
     * Permissions follow convention: module.action (e.g., 'sales.approve_controlled_substance')
     */
    public function up(): void
    {
        Schema::create('permissions', function (Blueprint $table) {
            $table->id();
            $table->string('name')->unique()->comment('Permission name (e.g., inventory.manage)');
            $table->text('description')->nullable()->comment('Permission description');
            $table->string('module', 50)->comment('Module grouping (inventory, sales, procurement, reports)');
            $table->timestamps();
            
            // Indexes
            $table->index('name');
            $table->index('module');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('permissions');
    }
};

