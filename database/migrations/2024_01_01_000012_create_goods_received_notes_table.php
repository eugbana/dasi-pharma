<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the goods_received_notes table for recording actual receipt of goods.
     * Supports partial deliveries and quality control workflow.
     */
    public function up(): void
    {
        Schema::create('goods_received_notes', function (Blueprint $table) {
            $table->id();
            $table->string('grn_number', 50)->unique()->comment('Auto-generated GRN number (GRN-YYYY-MM-NNNN)');
            $table->foreignId('purchase_order_id')->constrained()->comment('Related PO');
            $table->foreignId('branch_id')->constrained()->comment('Receiving branch');
            $table->foreignId('received_by')->constrained('users')->comment('User who received the goods');
            $table->date('received_date')->comment('Date goods were received');
            $table->enum('status', [
                'pending_quality_check',
                'approved',
                'rejected'
            ])->default('pending_quality_check')->comment('GRN status');
            $table->text('notes')->nullable()->comment('Receiving notes');
            $table->timestamps();
            
            // Indexes
            $table->index('grn_number');
            $table->index(['purchase_order_id', 'received_date']);
            $table->index(['branch_id', 'status']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('goods_received_notes');
    }
};

