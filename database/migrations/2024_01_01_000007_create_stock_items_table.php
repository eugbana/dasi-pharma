<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * CRITICAL TABLE: Tracks specific batches of drugs at each branch.
     * Each batch is a separate record for precise expiry tracking and FEFO compliance.
     * quantity_available is updated via stock_movements, never directly.
     */
    public function up(): void
    {
        Schema::create('stock_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('drug_id')->constrained()->comment('Drug reference');
            $table->foreignId('branch_id')->constrained()->comment('Branch location');
            $table->string('batch_number', 100)->comment('Manufacturer batch/lot number');
            $table->date('manufacturing_date')->nullable()->comment('Manufacturing date');
            $table->date('expiry_date')->comment('Expiry date - CRITICAL for FEFO');
            $table->decimal('purchase_price', 10, 2)->comment('Unit purchase price');
            $table->decimal('selling_price', 10, 2)->comment('Unit selling price');
            $table->integer('quantity_available')->default(0)->comment('Current available quantity');
            $table->integer('minimum_stock_level')->default(0)->comment('Minimum stock alert threshold');
            $table->integer('reorder_point')->default(0)->comment('Reorder point threshold');
            $table->timestamps();
            $table->softDeletes();
            
            // Unique constraint: prevent duplicate batch entries per branch
            $table->unique(['drug_id', 'branch_id', 'batch_number'], 'unique_batch_per_branch');
            
            // Indexes for FEFO and stock management
            $table->index(['branch_id', 'expiry_date']); // Expiry alerts and FEFO selection
            $table->index(['drug_id', 'quantity_available']); // Stock availability checks
            $table->index('expiry_date'); // Daily expiry check jobs
        });

        // Check constraints (MySQL/PostgreSQL only)
        if (in_array(config('database.default'), ['mysql', 'pgsql'])) {
            Schema::table('stock_items', function (Blueprint $table) {
                // Check constraint: quantity cannot be negative
                $table->check('quantity_available >= 0', 'check_quantity_non_negative');

                // Check constraint: expiry after manufacturing
                $table->check('expiry_date > manufacturing_date', 'check_expiry_after_manufacturing');
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('stock_items');
    }
};

