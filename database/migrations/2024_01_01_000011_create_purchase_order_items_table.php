<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the purchase_order_items table for PO line items.
     */
    public function up(): void
    {
        Schema::create('purchase_order_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('purchase_order_id')->constrained()->onDelete('cascade')->comment('PO reference');
            $table->foreignId('drug_id')->constrained()->comment('Drug reference');
            $table->integer('quantity_ordered')->comment('Quantity ordered');
            $table->decimal('unit_price', 10, 2)->comment('Unit price');
            $table->decimal('subtotal', 12, 2)->comment('Line item subtotal (calculated)');
            $table->timestamps();
            
            // Indexes
            $table->index('purchase_order_id');
            $table->index('drug_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('purchase_order_items');
    }
};

