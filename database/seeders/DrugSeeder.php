<?php

namespace Database\Seeders;

use App\Models\Drug;
use Illuminate\Database\Seeder;

class DrugSeeder extends Seeder
{
    /**
     * Run the database seeds.
     * 
     * Seeds sample pharmaceutical products with NAFDAC numbers.
     */
    public function run(): void
    {
        $drugs = [
            // Analgesics & Antipyretics
            [
                'brand_name' => 'Paracetamol',
                'generic_name' => 'Paracetamol',
                'strength' => '500mg',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'Emzor Pharmaceutical',
                'nafdac_number' => 'A4-0123',
                'is_prescription_only' => false,
                'controlled_substance_class' => null,
                'description' => 'Pain reliever and fever reducer',
            ],
            [
                'brand_name' => 'Ibuprofen',
                'generic_name' => 'Ibuprofen',
                'strength' => '400mg',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'GlaxoSmithKline',
                'nafdac_number' => 'A4-0124',
                'is_prescription_only' => false,
                'controlled_substance_class' => null,
                'description' => 'Non-steroidal anti-inflammatory drug (NSAID)',
            ],
            [
                'brand_name' => 'Tramadol',
                'generic_name' => 'Tramadol Hydrochloride',
                'strength' => '50mg',
                'dosage_form' => 'Capsule',
                'manufacturer' => 'Juhel Nigeria Limited',
                'nafdac_number' => 'A4-0125',
                'is_prescription_only' => true,
                'controlled_substance_class' => 'Schedule IV',
                'description' => 'Opioid pain medication - CONTROLLED SUBSTANCE',
            ],

            // Antibiotics
            [
                'brand_name' => 'Amoxicillin',
                'generic_name' => 'Amoxicillin',
                'strength' => '500mg',
                'dosage_form' => 'Capsule',
                'manufacturer' => 'Fidson Healthcare',
                'nafdac_number' => 'A4-0201',
                'is_prescription_only' => true,
                'controlled_substance_class' => null,
                'description' => 'Penicillin antibiotic',
            ],
            [
                'brand_name' => 'Ciprofloxacin',
                'generic_name' => 'Ciprofloxacin',
                'strength' => '500mg',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'Ranbaxy',
                'nafdac_number' => 'A4-0202',
                'is_prescription_only' => true,
                'controlled_substance_class' => null,
                'description' => 'Fluoroquinolone antibiotic',
            ],
            [
                'brand_name' => 'Azithromycin',
                'generic_name' => 'Azithromycin',
                'strength' => '250mg',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'Pfizer',
                'nafdac_number' => 'A4-0203',
                'is_prescription_only' => true,
                'controlled_substance_class' => null,
                'description' => 'Macrolide antibiotic',
            ],

            // Antimalarials
            [
                'brand_name' => 'Coartem',
                'generic_name' => 'Artemether-Lumefantrine',
                'strength' => '20/120mg',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'Novartis',
                'nafdac_number' => 'A4-0301',
                'is_prescription_only' => false,
                'controlled_substance_class' => null,
                'description' => 'Artemisinin-based combination therapy for malaria',
            ],
            [
                'brand_name' => 'Lonart',
                'generic_name' => 'Artemether-Lumefantrine',
                'strength' => '80/480mg',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'Bliss GVS Pharma',
                'nafdac_number' => 'A4-0302',
                'is_prescription_only' => false,
                'controlled_substance_class' => null,
                'description' => 'Antimalarial combination therapy',
            ],

            // Antihypertensives
            [
                'brand_name' => 'Amlodipine',
                'generic_name' => 'Amlodipine Besylate',
                'strength' => '5mg',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'Emzor Pharmaceutical',
                'nafdac_number' => 'A4-0401',
                'is_prescription_only' => true,
                'controlled_substance_class' => null,
                'description' => 'Calcium channel blocker for hypertension',
            ],
            [
                'brand_name' => 'Lisinopril',
                'generic_name' => 'Lisinopril',
                'strength' => '10mg',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'Merck',
                'nafdac_number' => 'A4-0402',
                'is_prescription_only' => true,
                'controlled_substance_class' => null,
                'description' => 'ACE inhibitor for hypertension',
            ],

            // Antidiabetics
            [
                'brand_name' => 'Metformin',
                'generic_name' => 'Metformin Hydrochloride',
                'strength' => '500mg',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'Fidson Healthcare',
                'nafdac_number' => 'A4-0501',
                'is_prescription_only' => true,
                'controlled_substance_class' => null,
                'description' => 'Oral antidiabetic medication',
            ],
            [
                'brand_name' => 'Glibenclamide',
                'generic_name' => 'Glibenclamide',
                'strength' => '5mg',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'Sanofi',
                'nafdac_number' => 'A4-0502',
                'is_prescription_only' => true,
                'controlled_substance_class' => null,
                'description' => 'Sulfonylurea for type 2 diabetes',
            ],

            // Vitamins & Supplements
            [
                'brand_name' => 'Vitamin C',
                'generic_name' => 'Ascorbic Acid',
                'strength' => '1000mg',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'Emzor Pharmaceutical',
                'nafdac_number' => 'A4-0601',
                'is_prescription_only' => false,
                'controlled_substance_class' => null,
                'description' => 'Vitamin C supplement',
            ],
            [
                'brand_name' => 'Multivitamin',
                'generic_name' => 'Multivitamin Complex',
                'strength' => 'Standard',
                'dosage_form' => 'Tablet',
                'manufacturer' => 'Vitabiotics',
                'nafdac_number' => 'A4-0602',
                'is_prescription_only' => false,
                'controlled_substance_class' => null,
                'description' => 'Daily multivitamin supplement',
            ],

            // Cough & Cold
            [
                'brand_name' => 'Benylin',
                'generic_name' => 'Dextromethorphan',
                'strength' => '100ml',
                'dosage_form' => 'Syrup',
                'manufacturer' => 'Johnson & Johnson',
                'nafdac_number' => 'A4-0701',
                'is_prescription_only' => false,
                'controlled_substance_class' => null,
                'description' => 'Cough suppressant syrup',
            ],
        ];

        foreach ($drugs as $drug) {
            Drug::create($drug);
        }
    }
}

