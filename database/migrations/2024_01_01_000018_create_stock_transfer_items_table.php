<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the stock_transfer_items table for transfer line items.
     * Preserves batch number for traceability.
     */
    public function up(): void
    {
        Schema::create('stock_transfer_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('stock_transfer_id')->constrained()->onDelete('cascade')->comment('Transfer reference');
            $table->foreignId('stock_item_id')->constrained()->comment('Source stock item');
            $table->foreignId('drug_id')->constrained()->comment('Drug reference (denormalized)');
            $table->string('batch_number', 100)->comment('Batch number (denormalized)');
            $table->integer('quantity')->comment('Quantity to transfer');
            $table->timestamps();
            
            // Indexes
            $table->index('stock_transfer_id');
            $table->index('stock_item_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('stock_transfer_items');
    }
};

