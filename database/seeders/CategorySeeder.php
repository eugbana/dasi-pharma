<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Subcategory;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            [
                'name' => 'Pharmaceuticals',
                'description' => 'Prescription and over-the-counter medications',
                'sort_order' => 1,
                'subcategories' => [
                    ['name' => 'Antibiotics', 'description' => 'Antibacterial medications'],
                    ['name' => 'Pain Relief', 'description' => 'Analgesics and pain management'],
                    ['name' => 'Cardiovascular', 'description' => 'Heart and blood pressure medications'],
                    ['name' => 'Respiratory', 'description' => 'Asthma, cough, and cold medications'],
                    ['name' => 'Gastrointestinal', 'description' => 'Digestive system medications'],
                ],
            ],
            [
                'name' => 'Vitamins & Supplements',
                'description' => 'Nutritional supplements and vitamins',
                'sort_order' => 2,
                'subcategories' => [
                    ['name' => 'Multivitamins', 'description' => 'Complete vitamin formulations'],
                    ['name' => 'Minerals', 'description' => 'Calcium, iron, zinc supplements'],
                    ['name' => 'Herbal Supplements', 'description' => 'Natural and herbal products'],
                    ['name' => 'Protein & Fitness', 'description' => 'Sports nutrition and protein'],
                ],
            ],
            [
                'name' => 'Medical Devices',
                'description' => 'Medical equipment and devices',
                'sort_order' => 3,
                'subcategories' => [
                    ['name' => 'Diagnostic Tools', 'description' => 'Thermometers, blood pressure monitors'],
                    ['name' => 'First Aid', 'description' => 'Bandages, gauze, wound care'],
                    ['name' => 'Mobility Aids', 'description' => 'Crutches, walkers, wheelchairs'],
                ],
            ],
            [
                'name' => 'Personal Care',
                'description' => 'Personal hygiene and care products',
                'sort_order' => 4,
                'subcategories' => [
                    ['name' => 'Skin Care', 'description' => 'Lotions, creams, sunscreen'],
                    ['name' => 'Oral Care', 'description' => 'Toothpaste, mouthwash, dental products'],
                    ['name' => 'Hair Care', 'description' => 'Shampoo, conditioner, hair treatments'],
                ],
            ],
            [
                'name' => 'Baby & Mother Care',
                'description' => 'Products for babies and mothers',
                'sort_order' => 5,
                'subcategories' => [
                    ['name' => 'Baby Food', 'description' => 'Infant formula and baby food'],
                    ['name' => 'Diapers & Wipes', 'description' => 'Baby diapers and wet wipes'],
                    ['name' => 'Maternal Health', 'description' => 'Prenatal vitamins and care'],
                ],
            ],
            [
                'name' => 'Food & Beverages',
                'description' => 'Health foods and beverages',
                'sort_order' => 6,
                'subcategories' => [
                    ['name' => 'Health Drinks', 'description' => 'Nutritional drinks and shakes'],
                    ['name' => 'Diabetic Foods', 'description' => 'Sugar-free and diabetic products'],
                    ['name' => 'Organic Foods', 'description' => 'Organic and natural foods'],
                ],
            ],
        ];

        foreach ($categories as $categoryData) {
            $subcategories = $categoryData['subcategories'];
            unset($categoryData['subcategories']);

            $category = Category::create($categoryData);

            foreach ($subcategories as $index => $subcategoryData) {
                $subcategoryData['category_id'] = $category->id;
                $subcategoryData['sort_order'] = $index + 1;
                Subcategory::create($subcategoryData);
            }
        }
    }
}
