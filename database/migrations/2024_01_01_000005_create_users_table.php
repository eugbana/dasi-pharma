<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the users table with role-based access control.
     * Each user is assigned to a specific branch and role.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name')->comment('Full name');
            $table->string('email')->unique()->comment('Email address for login');
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password')->comment('Hashed password');
            $table->foreignId('role_id')->constrained()->comment('User role');
            $table->foreignId('branch_id')->constrained()->comment('Primary branch assignment');
            $table->boolean('is_active')->default(true)->comment('Active status flag');
            $table->rememberToken();
            $table->timestamps();
            $table->softDeletes();
            
            // Indexes
            $table->index('email');
            $table->index(['role_id', 'branch_id']);
            $table->index('deleted_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};

