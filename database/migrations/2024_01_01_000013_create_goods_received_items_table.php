<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the goods_received_items table for GRN line items.
     * Captures batch number and expiry date at receipt.
     * Creates stock_item and stock_movement when quality check passes.
     */
    public function up(): void
    {
        Schema::create('goods_received_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('grn_id')->constrained('goods_received_notes')->onDelete('cascade')->comment('GRN reference');
            $table->foreignId('drug_id')->constrained()->comment('Drug reference');
            $table->string('batch_number', 100)->comment('Batch/lot number from supplier');
            $table->date('manufacturing_date')->nullable()->comment('Manufacturing date');
            $table->date('expiry_date')->comment('Expiry date');
            $table->integer('quantity_received')->comment('Quantity received');
            $table->decimal('unit_price', 10, 2)->comment('Unit price');
            $table->boolean('quality_check_passed')->default(false)->comment('Quality check status');
            $table->text('quality_notes')->nullable()->comment('Quality check notes');
            $table->timestamps();
            
            // Indexes
            $table->index('grn_id');
            $table->index(['drug_id', 'batch_number']);
            $table->index('expiry_date');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('goods_received_items');
    }
};

