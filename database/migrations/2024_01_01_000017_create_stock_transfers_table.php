<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the stock_transfers table for inter-branch stock transfers.
     * Includes approval workflow and status tracking.
     */
    public function up(): void
    {
        Schema::create('stock_transfers', function (Blueprint $table) {
            $table->id();
            $table->string('transfer_number', 50)->unique()->comment('Auto-generated transfer number (TRF-YYYY-MM-NNNN)');
            $table->foreignId('from_branch_id')->constrained('branches')->comment('Source branch');
            $table->foreignId('to_branch_id')->constrained('branches')->comment('Destination branch');
            $table->foreignId('requested_by')->constrained('users')->comment('User who requested the transfer');
            $table->foreignId('approved_by')->nullable()->constrained('users')->comment('User who approved the transfer');
            $table->date('transfer_date')->comment('Transfer date');
            $table->enum('status', [
                'pending',
                'approved',
                'in_transit',
                'received',
                'cancelled'
            ])->default('pending')->comment('Transfer status');
            $table->text('notes')->nullable()->comment('Transfer notes');
            $table->timestamp('approved_at')->nullable()->comment('Approval timestamp');
            $table->timestamps();
            
            // Indexes
            $table->index('transfer_number');
            $table->index(['from_branch_id', 'status']);
            $table->index(['to_branch_id', 'status']);
            $table->index(['status', 'transfer_date']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('stock_transfers');
    }
};

