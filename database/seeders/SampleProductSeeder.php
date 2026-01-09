<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Subcategory;
use App\Models\Drug;
use App\Models\StockItem;
use App\Models\Branch;
use Illuminate\Database\Seeder;

class SampleProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Get the first branch (or create one if none exists)
        $branch = Branch::first();

        if (!$branch) {
            $branch = Branch::create([
                'name' => 'Main Branch',
                'code' => 'MAIN',
                'address' => '123 Main Street',
                'phone' => '08012345678',
                'is_active' => true,
            ]);
        }

        // Get categories and subcategories
        $pharma = Category::where('slug', 'pharmaceuticals')->first();
        $vitamins = Category::where('slug', 'vitamins-supplements')->first();
        $medicalDevices = Category::where('slug', 'medical-devices')->first();
        $personalCare = Category::where('slug', 'personal-care')->first();
        $babyMother = Category::where('slug', 'baby-mother-care')->first();
        $foodBev = Category::where('slug', 'food-beverages')->first();

        $antibiotics = Subcategory::where('slug', 'antibiotics')->first();
        $painRelief = Subcategory::where('slug', 'pain-relief')->first();
        $multivitamins = Subcategory::where('slug', 'multivitamins')->first();
        $minerals = Subcategory::where('slug', 'minerals')->first();
        $diagnostic = Subcategory::where('slug', 'diagnostic-tools')->first();
        $skinCare = Subcategory::where('slug', 'skin-care')->first();
        $babyFood = Subcategory::where('slug', 'baby-food')->first();
        $healthDrinks = Subcategory::where('slug', 'health-drinks')->first();

        $products = [
            // Pharmaceuticals
            [
                'brand_name' => 'Amoxil',
                'generic_name' => 'Amoxicillin',
                'strength' => '500mg',
                'dosage_form' => 'Capsule',
                'manufacturer' => 'GlaxoSmithKline',
                'nafdac_number' => 'A4-0123',
                'barcode' => '5060340394356',
                'category_id' => $pharma?->id,
                'subcategory_id' => $antibiotics?->id,
                'is_prescription_only' => true,
                'description' => 'Antibiotic for bacterial infections',
                'stock' => [
                    'batch_number' => 'AMX2024001',
                    'manufacturing_date' => '2024-01-15',
                    'expiry_date' => '2026-01-15',
                    'purchase_price' => 1500.00,
                    'selling_price' => 2500.00,
                    'quantity_available' => 150,
                    'minimum_stock_level' => 50,
                    'reorder_point' => 75,
                ],
            ],
            [
                'brand_name' => 'Panadol',
                'generic_name' => 'Paracetamol',
                'strength' => '500mg',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'GSK Consumer Healthcare',
                'nafdac_number' => 'A4-0456',
                'barcode' => '5012345678901',
                'category_id' => $pharma?->id,
                'subcategory_id' => $painRelief?->id,
                'is_prescription_only' => false,
                'description' => 'Pain relief and fever reducer',
                'stock' => [
                    'batch_number' => 'PAN2024002',
                    'manufacturing_date' => '2024-02-01',
                    'expiry_date' => '2026-02-01',
                    'purchase_price' => 50.00,
                    'selling_price' => 100.00,
                    'quantity_available' => 500,
                    'minimum_stock_level' => 100,
                    'reorder_point' => 150,
                ],
            ],
            // Vitamins & Supplements
            [
                'brand_name' => 'Centrum',
                'generic_name' => 'Multivitamin',
                'strength' => 'Adult Formula',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'Pfizer',
                'nafdac_number' => 'A4-0789',
                'barcode' => '3574661234567',
                'category_id' => $vitamins?->id,
                'subcategory_id' => $multivitamins?->id,
                'is_prescription_only' => false,
                'description' => 'Complete multivitamin supplement',
                'stock' => [
                    'batch_number' => 'CEN2024003',
                    'manufacturing_date' => '2024-03-10',
                    'expiry_date' => '2026-03-10',
                    'purchase_price' => 3500.00,
                    'selling_price' => 5500.00,
                    'quantity_available' => 80,
                    'minimum_stock_level' => 20,
                    'reorder_point' => 30,
                ],
            ],
            [
                'brand_name' => 'Feroglobin',
                'generic_name' => 'Iron Supplement',
                'strength' => '30mg',
                'dosage_form' => 'Capsule',
                'manufacturer' => 'Vitabiotics',
                'nafdac_number' => 'A4-1012',
                'barcode' => '5021265222407',
                'category_id' => $vitamins?->id,
                'subcategory_id' => $minerals?->id,
                'is_prescription_only' => false,
                'description' => 'Iron and vitamin supplement for blood health',
                'stock' => [
                    'batch_number' => 'FER2024004',
                    'manufacturing_date' => '2024-04-05',
                    'expiry_date' => '2026-04-05',
                    'purchase_price' => 2000.00,
                    'selling_price' => 3200.00,
                    'quantity_available' => 120,
                    'minimum_stock_level' => 30,
                    'reorder_point' => 50,
                ],
            ],
            // Medical Devices
            [
                'brand_name' => 'Omron Digital Thermometer',
                'generic_name' => 'Digital Thermometer',
                'strength' => 'N/A',
                'dosage_form' => 'Device',
                'manufacturer' => 'Omron Healthcare',
                'nafdac_number' => 'A4-1345',
                'barcode' => '4015672123456',
                'category_id' => $medicalDevices?->id,
                'subcategory_id' => $diagnostic?->id,
                'is_prescription_only' => false,
                'description' => 'Digital thermometer for accurate temperature measurement',
                'stock' => [
                    'batch_number' => 'OMR2024005',
                    'manufacturing_date' => '2024-05-01',
                    'expiry_date' => '2029-05-01',
                    'purchase_price' => 1800.00,
                    'selling_price' => 2800.00,
                    'quantity_available' => 45,
                    'minimum_stock_level' => 10,
                    'reorder_point' => 15,
                ],
            ],
            [
                'brand_name' => 'Accu-Chek Blood Glucose Monitor',
                'generic_name' => 'Glucometer',
                'strength' => 'N/A',
                'dosage_form' => 'Device',
                'manufacturer' => 'Roche Diabetes Care',
                'nafdac_number' => 'A4-1678',
                'barcode' => '4015630987654',
                'category_id' => $medicalDevices?->id,
                'subcategory_id' => $diagnostic?->id,
                'is_prescription_only' => false,
                'description' => 'Blood glucose monitoring system for diabetes management',
                'stock' => [
                    'batch_number' => 'ACC2024006',
                    'manufacturing_date' => '2024-06-15',
                    'expiry_date' => '2029-06-15',
                    'purchase_price' => 8500.00,
                    'selling_price' => 12000.00,
                    'quantity_available' => 25,
                    'minimum_stock_level' => 5,
                    'reorder_point' => 10,
                ],
            ],
            // Personal Care
            [
                'brand_name' => 'Nivea Soft Moisturizing Cream',
                'generic_name' => 'Moisturizer',
                'strength' => '200ml',
                'dosage_form' => 'Cream',
                'manufacturer' => 'Beiersdorf',
                'nafdac_number' => 'A4-2001',
                'barcode' => '4005900123456',
                'category_id' => $personalCare?->id,
                'subcategory_id' => $skinCare?->id,
                'is_prescription_only' => false,
                'description' => 'Moisturizing cream for soft and smooth skin',
                'stock' => [
                    'batch_number' => 'NIV2024007',
                    'manufacturing_date' => '2024-07-01',
                    'expiry_date' => '2026-07-01',
                    'purchase_price' => 1200.00,
                    'selling_price' => 2000.00,
                    'quantity_available' => 200,
                    'minimum_stock_level' => 40,
                    'reorder_point' => 60,
                ],
            ],
            [
                'brand_name' => 'Colgate Total Toothpaste',
                'generic_name' => 'Toothpaste',
                'strength' => '150g',
                'dosage_form' => 'Paste',
                'manufacturer' => 'Colgate-Palmolive',
                'nafdac_number' => 'A4-2334',
                'barcode' => '6920354812345',
                'category_id' => $personalCare?->id,
                'subcategory_id' => Subcategory::where('slug', 'oral-care')->first()?->id,
                'is_prescription_only' => false,
                'description' => 'Complete oral care toothpaste',
                'stock' => [
                    'batch_number' => 'COL2024008',
                    'manufacturing_date' => '2024-08-10',
                    'expiry_date' => '2026-08-10',
                    'purchase_price' => 800.00,
                    'selling_price' => 1300.00,
                    'quantity_available' => 300,
                    'minimum_stock_level' => 50,
                    'reorder_point' => 80,
                ],
            ],
            // Baby & Mother Care
            [
                'brand_name' => 'SMA Gold Infant Formula',
                'generic_name' => 'Baby Formula',
                'strength' => '900g',
                'dosage_form' => 'Powder',
                'manufacturer' => 'Nestlé',
                'nafdac_number' => 'A4-2667',
                'barcode' => '5000329123456',
                'category_id' => $babyMother?->id,
                'subcategory_id' => $babyFood?->id,
                'is_prescription_only' => false,
                'description' => 'Complete nutrition for infants 0-6 months',
                'stock' => [
                    'batch_number' => 'SMA2024009',
                    'manufacturing_date' => '2024-09-05',
                    'expiry_date' => '2026-03-05',
                    'purchase_price' => 6500.00,
                    'selling_price' => 9500.00,
                    'quantity_available' => 60,
                    'minimum_stock_level' => 15,
                    'reorder_point' => 25,
                ],
            ],
            [
                'brand_name' => 'Pampers Baby Dry Diapers',
                'generic_name' => 'Disposable Diapers',
                'strength' => 'Size 3 (6-10kg)',
                'dosage_form' => 'Pack of 50',
                'manufacturer' => 'Procter & Gamble',
                'nafdac_number' => 'A4-3000',
                'barcode' => '4015400123456',
                'category_id' => $babyMother?->id,
                'subcategory_id' => Subcategory::where('slug', 'diapers-wipes')->first()?->id,
                'is_prescription_only' => false,
                'description' => 'Ultra-absorbent baby diapers',
                'stock' => [
                    'batch_number' => 'PAM2024010',
                    'manufacturing_date' => '2024-10-01',
                    'expiry_date' => '2027-10-01',
                    'purchase_price' => 4500.00,
                    'selling_price' => 6800.00,
                    'quantity_available' => 90,
                    'minimum_stock_level' => 20,
                    'reorder_point' => 35,
                ],
            ],
            // Food & Beverages
            [
                'brand_name' => 'Ensure Plus Nutrition Shake',
                'generic_name' => 'Nutritional Supplement',
                'strength' => '400g',
                'dosage_form' => 'Powder',
                'manufacturer' => 'Abbott Laboratories',
                'nafdac_number' => 'A4-3333',
                'barcode' => '8710428123456',
                'category_id' => $foodBev?->id,
                'subcategory_id' => $healthDrinks?->id,
                'is_prescription_only' => false,
                'description' => 'Complete balanced nutrition drink',
                'stock' => [
                    'batch_number' => 'ENS2024011',
                    'manufacturing_date' => '2024-11-15',
                    'expiry_date' => '2026-05-15',
                    'purchase_price' => 5200.00,
                    'selling_price' => 7500.00,
                    'quantity_available' => 70,
                    'minimum_stock_level' => 15,
                    'reorder_point' => 25,
                ],
            ],
            [
                'brand_name' => 'Glucerna Diabetic Shake',
                'generic_name' => 'Diabetic Nutritional Drink',
                'strength' => '400g',
                'dosage_form' => 'Powder',
                'manufacturer' => 'Abbott Laboratories',
                'nafdac_number' => 'A4-3666',
                'barcode' => '8710428987654',
                'category_id' => $foodBev?->id,
                'subcategory_id' => Subcategory::where('slug', 'diabetic-foods')->first()?->id,
                'is_prescription_only' => false,
                'description' => 'Specialized nutrition for diabetes management',
                'stock' => [
                    'batch_number' => 'GLU2024012',
                    'manufacturing_date' => '2024-12-01',
                    'expiry_date' => '2026-06-01',
                    'purchase_price' => 6000.00,
                    'selling_price' => 8800.00,
                    'quantity_available' => 55,
                    'minimum_stock_level' => 12,
                    'reorder_point' => 20,
                ],
            ],
        ];

        // Create products and stock items
        foreach ($products as $productData) {
            $stockData = $productData['stock'];
            unset($productData['stock']);

            // Check if drug already exists by barcode or NAFDAC number
            $drug = Drug::where('barcode', $productData['barcode'])
                ->orWhere('nafdac_number', $productData['nafdac_number'])
                ->first();

            if (!$drug) {
                $drug = Drug::create($productData);
            }

            // Check if stock item already exists for this drug and branch
            $existingStock = StockItem::where('drug_id', $drug->id)
                ->where('branch_id', $branch->id)
                ->where('batch_number', $stockData['batch_number'])
                ->first();

            if (!$existingStock) {
                $stockData['drug_id'] = $drug->id;
                $stockData['branch_id'] = $branch->id;
                StockItem::create($stockData);
            }
        }
    }
}
