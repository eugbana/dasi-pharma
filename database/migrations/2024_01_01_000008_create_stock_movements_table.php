<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * CRITICAL TABLE: Comprehensive audit trail of all inventory changes.
     * Every stock change must be recorded here with user, timestamp, and reason.
     * Polymorphic relationship to source transactions (sales, purchases, transfers).
     */
    public function up(): void
    {
        Schema::create('stock_movements', function (Blueprint $table) {
            $table->id();
            $table->foreignId('stock_item_id')->constrained()->comment('Stock item reference');
            $table->foreignId('user_id')->constrained()->comment('User who performed the movement');
            $table->enum('movement_type', [
                'purchase',
                'sale',
                'transfer_in',
                'transfer_out',
                'adjustment',
                'expiry',
                'return'
            ])->comment('Type of stock movement');
            $table->integer('quantity')->comment('Quantity moved (positive for increase, negative for decrease)');
            $table->decimal('unit_cost', 10, 2)->nullable()->comment('Unit cost at time of movement');
            $table->string('reference_type', 100)->nullable()->comment('Polymorphic reference type');
            $table->unsignedBigInteger('reference_id')->nullable()->comment('Polymorphic reference ID');
            $table->text('reason')->nullable()->comment('Reason for movement (required for adjustments)');
            $table->date('movement_date')->comment('Date of movement (allows backdating with authorization)');
            $table->timestamps();
            
            // Indexes for audit trail and reporting
            $table->index(['stock_item_id', 'movement_date']); // Batch history
            $table->index(['user_id', 'movement_date']); // User activity reports
            $table->index(['reference_type', 'reference_id']); // Trace source transactions
            $table->index(['movement_type', 'movement_date']); // Movement type reports
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('stock_movements');
    }
};

