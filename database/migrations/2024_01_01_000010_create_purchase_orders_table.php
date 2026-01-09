<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the purchase_orders table for tracking orders from suppliers.
     * Includes approval workflow and status tracking.
     */
    public function up(): void
    {
        Schema::create('purchase_orders', function (Blueprint $table) {
            $table->id();
            $table->string('order_number', 50)->unique()->comment('Auto-generated PO number (PO-YYYY-MM-NNNN)');
            $table->foreignId('supplier_id')->constrained()->comment('Supplier reference');
            $table->foreignId('branch_id')->constrained()->comment('Destination branch');
            $table->foreignId('created_by')->constrained('users')->comment('User who created the PO');
            $table->foreignId('approved_by')->nullable()->constrained('users')->comment('User who approved the PO');
            $table->date('order_date')->comment('Order date');
            $table->date('expected_delivery_date')->nullable()->comment('Expected delivery date');
            $table->enum('status', [
                'draft',
                'pending_approval',
                'approved',
                'partially_received',
                'completed',
                'cancelled'
            ])->default('draft')->comment('PO status');
            $table->decimal('total_amount', 12, 2)->default(0)->comment('Total order amount');
            $table->text('notes')->nullable()->comment('Additional notes');
            $table->timestamp('approved_at')->nullable()->comment('Approval timestamp');
            $table->timestamps();
            $table->softDeletes();
            
            // Indexes
            $table->index('order_number');
            $table->index(['supplier_id', 'status', 'order_date']);
            $table->index(['branch_id', 'status']);
            $table->index(['status', 'expected_delivery_date']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('purchase_orders');
    }
};

