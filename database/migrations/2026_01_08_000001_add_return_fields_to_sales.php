<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Adds return tracking fields to sale_items and creates sale_returns table
     * for comprehensive return/refund audit trail with admin authorization.
     */
    public function up(): void
    {
        // Add quantity_returned to sale_items for tracking partial returns
        Schema::table('sale_items', function (Blueprint $table) {
            $table->integer('quantity_returned')->default(0)->after('quantity')
                ->comment('Quantity of this item that has been returned');
        });

        // Create sale_returns table for comprehensive return tracking
        Schema::create('sale_returns', function (Blueprint $table) {
            $table->id();
            $table->string('return_number', 50)->unique()->comment('Unique return reference number');
            $table->foreignId('sale_id')->constrained()->comment('Original sale being returned');
            $table->foreignId('branch_id')->constrained()->comment('Branch where return was processed');
            $table->foreignId('processed_by')->constrained('users')->comment('Staff who processed the return');
            $table->foreignId('authorized_by')->constrained('users')->comment('Admin who authorized the return');
            $table->dateTime('return_date')->comment('Date and time of return');
            $table->decimal('refund_amount', 12, 2)->comment('Total refund amount');
            $table->string('refund_method', 50)->comment('Refund payment method: cash, original_payment, store_credit');
            $table->text('reason')->comment('Reason for return');
            $table->enum('status', ['completed', 'voided'])->default('completed');
            $table->timestamps();
            
            $table->index(['sale_id', 'return_date']);
            $table->index('return_number');
        });

        // Create sale_return_items table for individual return line items
        Schema::create('sale_return_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('sale_return_id')->constrained()->onDelete('cascade');
            $table->foreignId('sale_item_id')->constrained()->comment('Original sale item');
            $table->foreignId('stock_item_id')->constrained()->comment('Stock item to return to');
            $table->integer('quantity')->comment('Quantity being returned');
            $table->decimal('unit_price', 10, 2)->comment('Unit price at time of sale');
            $table->decimal('refund_amount', 10, 2)->comment('Refund for this item');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sale_return_items');
        Schema::dropIfExists('sale_returns');
        
        Schema::table('sale_items', function (Blueprint $table) {
            $table->dropColumn('quantity_returned');
        });
    }
};

