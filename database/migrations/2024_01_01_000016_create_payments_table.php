<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the payments table for tracking payment methods.
     * Supports split payments (multiple payment records per sale).
     */
    public function up(): void
    {
        Schema::create('payments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('sale_id')->constrained()->onDelete('cascade')->comment('Sale reference');
            $table->enum('payment_method', ['cash', 'card', 'transfer', 'mobile_money'])->comment('Payment method');
            $table->decimal('amount', 12, 2)->comment('Payment amount');
            $table->string('reference_number', 100)->nullable()->comment('Transaction reference (for card/transfer)');
            $table->dateTime('payment_date')->comment('Payment date and time');
            $table->timestamps();
            
            // Indexes
            $table->index('sale_id');
            $table->index(['payment_method', 'payment_date']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payments');
    }
};

