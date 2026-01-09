<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Adds authorization_code field to users table for quick admin approvals.
     * This provides an alternative to password-based authorization for
     * sensitive operations like returns, discounts, and void transactions.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('authorization_code', 6)->nullable()->after('password')
                ->comment('6-digit PIN for quick authorization of sensitive operations');
            $table->boolean('can_authorize')->default(false)->after('authorization_code')
                ->comment('Whether this user can authorize sensitive operations');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['authorization_code', 'can_authorize']);
        });
    }
};

