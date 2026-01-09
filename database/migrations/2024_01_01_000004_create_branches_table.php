<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the branches table for multi-branch pharmacy support.
     * Each branch represents a physical pharmacy location.
     */
    public function up(): void
    {
        Schema::create('branches', function (Blueprint $table) {
            $table->id();
            $table->string('name')->comment('Branch name');
            $table->string('code', 20)->unique()->comment('Unique branch code for internal reference');
            $table->text('address')->nullable()->comment('Physical address');
            $table->string('phone', 20)->nullable()->comment('Contact phone number');
            $table->string('email', 100)->nullable()->comment('Contact email');
            $table->boolean('is_active')->default(true)->comment('Active status flag');
            $table->timestamps();
            $table->softDeletes();
            
            // Indexes
            $table->index('code');
            $table->index(['is_active', 'deleted_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('branches');
    }
};

