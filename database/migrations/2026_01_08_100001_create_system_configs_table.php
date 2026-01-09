<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 
     * Creates system_configs table for key-value configuration storage
     * and adds VAT-related columns to stock_items and sale_items.
     */
    public function up(): void
    {
        // Create system_configs table for key-value storage
        Schema::create('system_configs', function (Blueprint $table) {
            $table->id();
            $table->string('key', 100)->unique()->comment('Configuration key');
            $table->text('value')->nullable()->comment('Configuration value');
            $table->string('type', 20)->default('string')->comment('Value type: string, number, boolean, json');
            $table->string('group', 50)->default('general')->comment('Configuration group');
            $table->text('description')->nullable()->comment('Description of the setting');
            $table->timestamps();
            
            $table->index('group');
        });

        // Add VAT applicable field to stock_items
        Schema::table('stock_items', function (Blueprint $table) {
            $table->boolean('vat_applicable')->default(false)->after('selling_price')
                ->comment('Whether VAT applies to this item');
        });

        // Add VAT tracking fields to sale_items for historical accuracy
        Schema::table('sale_items', function (Blueprint $table) {
            $table->decimal('vat_rate', 5, 2)->default(0)->after('subtotal')
                ->comment('VAT rate applied at time of sale');
            $table->decimal('vat_amount', 10, 2)->default(0)->after('vat_rate')
                ->comment('VAT amount for this line item');
        });

        // Insert default configuration values
        DB::table('system_configs')->insert([
            [
                'key' => 'receipt_business_name',
                'value' => '',
                'type' => 'string',
                'group' => 'receipt',
                'description' => 'Business name displayed on receipts (uses branch name if empty)',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'key' => 'receipt_header_title',
                'value' => 'SALES RECEIPT',
                'type' => 'string',
                'group' => 'receipt',
                'description' => 'Main title displayed on receipts',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'key' => 'receipt_footer_message',
                'value' => 'Thank you for your business',
                'type' => 'string',
                'group' => 'receipt',
                'description' => 'Footer message on receipts',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'key' => 'vat_rate',
                'value' => '0',
                'type' => 'number',
                'group' => 'tax',
                'description' => 'VAT percentage rate (e.g., 7.5 for 7.5%)',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'key' => 'vat_display_text',
                'value' => 'VAT',
                'type' => 'string',
                'group' => 'tax',
                'description' => 'Label for VAT on receipts and invoices',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('sale_items', function (Blueprint $table) {
            $table->dropColumn(['vat_rate', 'vat_amount']);
        });

        Schema::table('stock_items', function (Blueprint $table) {
            $table->dropColumn('vat_applicable');
        });

        Schema::dropIfExists('system_configs');
    }
};

