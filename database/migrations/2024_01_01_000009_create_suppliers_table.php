<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the suppliers table for vendor master data.
     */
    public function up(): void
    {
        Schema::create('suppliers', function (Blueprint $table) {
            $table->id();
            $table->string('name')->comment('Supplier/vendor name');
            $table->string('contact_person')->nullable()->comment('Primary contact person');
            $table->string('phone', 20)->nullable()->comment('Contact phone');
            $table->string('email', 100)->nullable()->comment('Contact email');
            $table->text('address')->nullable()->comment('Physical address');
            $table->string('payment_terms', 50)->default('Cash')->comment('Payment terms (Cash, Net 30, Net 60)');
            $table->integer('delivery_days')->default(7)->comment('Expected delivery time in days');
            $table->boolean('is_active')->default(true)->comment('Active status flag');
            $table->timestamps();
            $table->softDeletes();
            
            // Indexes
            $table->index('is_active');
            $table->index('name');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('suppliers');
    }
};

