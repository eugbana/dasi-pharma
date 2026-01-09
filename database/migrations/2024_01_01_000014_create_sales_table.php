<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the sales table for point-of-sale transactions.
     * Includes prescription tracking and pharmacist approval for controlled substances.
     */
    public function up(): void
    {
        Schema::create('sales', function (Blueprint $table) {
            $table->id();
            $table->string('sale_number', 50)->unique()->comment('Auto-generated sale number (SAL-YYYY-MM-NNNNNN)');
            $table->foreignId('branch_id')->constrained()->comment('Branch where sale occurred');
            $table->foreignId('user_id')->constrained()->comment('Sales staff who processed the sale');
            $table->dateTime('sale_date')->comment('Date and time of sale');
            $table->decimal('subtotal', 12, 2)->comment('Subtotal before tax and discount');
            $table->decimal('tax_amount', 10, 2)->default(0)->comment('Tax amount');
            $table->decimal('discount_amount', 10, 2)->default(0)->comment('Discount amount');
            $table->decimal('total_amount', 12, 2)->comment('Final total amount');
            $table->string('customer_name')->nullable()->comment('Customer name (optional)');
            $table->string('customer_phone', 20)->nullable()->comment('Customer phone (for purchase history)');
            $table->string('prescription_number', 100)->nullable()->comment('Prescription number (required for Rx-only drugs)');
            $table->foreignId('approved_by_pharmacist')->nullable()->constrained('users')->comment('Pharmacist approval for controlled substances');
            $table->enum('status', ['completed', 'returned', 'partially_returned'])->default('completed')->comment('Sale status');
            $table->timestamps();
            $table->softDeletes();
            
            // Indexes
            $table->index('sale_number');
            $table->index(['branch_id', 'sale_date']);
            $table->index(['user_id', 'sale_date']);
            $table->index('customer_phone');
            $table->index('prescription_number');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sales');
    }
};

