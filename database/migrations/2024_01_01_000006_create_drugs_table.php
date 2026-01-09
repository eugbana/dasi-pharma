<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates the drugs table - master catalog of pharmaceutical products.
     * Includes regulatory compliance fields (NAFDAC, controlled substances).
     */
    public function up(): void
    {
        Schema::create('drugs', function (Blueprint $table) {
            $table->id();
            $table->string('brand_name')->comment('Brand/trade name');
            $table->string('generic_name')->comment('Generic/chemical name');
            $table->string('strength', 50)->comment('Strength (e.g., 500mg, 10ml)');
            $table->string('dosage_form', 50)->comment('Form (tablet, capsule, syrup, etc.)');
            $table->string('manufacturer')->nullable()->comment('Manufacturer name');
            $table->string('nafdac_number', 50)->unique()->comment('NAFDAC registration number');
            $table->boolean('is_prescription_only')->default(false)->comment('Requires prescription flag');
            $table->enum('controlled_substance_class', ['Schedule II', 'Schedule III', 'Schedule IV', 'Schedule V'])
                ->nullable()
                ->comment('Controlled substance classification');
            $table->text('description')->nullable()->comment('Product description');
            $table->timestamps();
            $table->softDeletes();

            // Unique constraint: same drug with same strength and form = duplicate
            $table->unique(['brand_name', 'strength', 'dosage_form'], 'unique_drug_variant');

            // Indexes
            $table->index('nafdac_number');
            $table->index('generic_name');
            $table->index(['is_prescription_only', 'controlled_substance_class']);
        });

        // Full-text search index for product search (MySQL only)
        if (config('database.default') === 'mysql') {
            Schema::table('drugs', function (Blueprint $table) {
                $table->fullText(['brand_name', 'generic_name'], 'drug_search_fulltext');
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('drugs');
    }
};

