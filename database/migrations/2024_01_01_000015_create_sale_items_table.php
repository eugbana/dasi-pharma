<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the sale_items table for sale line items.
     * Links to specific stock_item for batch traceability (FEFO compliance).
     * Batch number denormalized for reporting even if stock_item is deleted.
     */
    public function up(): void
    {
        Schema::create('sale_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('sale_id')->constrained()->onDelete('cascade')->comment('Sale reference');
            $table->foreignId('stock_item_id')->constrained()->comment('Specific batch sold (FEFO)');
            $table->foreignId('drug_id')->constrained()->comment('Drug reference (denormalized)');
            $table->string('batch_number', 100)->comment('Batch number (denormalized for reporting)');
            $table->integer('quantity')->comment('Quantity sold');
            $table->decimal('unit_price', 10, 2)->comment('Unit selling price');
            $table->decimal('subtotal', 12, 2)->comment('Line item subtotal');
            $table->timestamps();
            
            // Indexes
            $table->index('sale_id');
            $table->index('stock_item_id');
            $table->index('drug_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sale_items');
    }
};

