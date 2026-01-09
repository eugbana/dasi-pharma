<?php

namespace Database\Seeders;

use App\Models\Supplier;
use Illuminate\Database\Seeder;

class SupplierSeeder extends Seeder
{
    /**
     * Run the database seeds.
     * 
     * Seeds sample pharmaceutical suppliers in Nigeria.
     */
    public function run(): void
    {
        $suppliers = [
            [
                'name' => 'Emzor Pharmaceutical Industries Ltd',
                'contact_person' => 'Mr. Chukwuma Okafor',
                'email' => 'sales@emzor.com.ng',
                'phone' => '+234 1 234 5678',
                'address' => '3-4 Emzor Crescent, Apapa, Lagos State',
                'is_active' => true,
            ],
            [
                'name' => 'Fidson Healthcare Plc',
                'contact_person' => 'Mrs. Amina Bello',
                'email' => 'orders@fidson.com',
                'phone' => '+234 1 345 6789',
                'address' => '268 Ikorodu Road, Obanikoro, Lagos State',
                'is_active' => true,
            ],
            [
                'name' => 'GlaxoSmithKline Nigeria',
                'contact_person' => 'Dr. Oluwaseun Adeyemi',
                'email' => 'nigeria@gsk.com',
                'phone' => '+234 1 456 7890',
                'address' => '1 Industrial Avenue, Ilupeju, Lagos State',
                'is_active' => true,
            ],
            [
                'name' => 'Juhel Nigeria Limited',
                'contact_person' => 'Mr. Ibrahim Yusuf',
                'email' => 'info@juhel.com.ng',
                'phone' => '+234 1 567 8901',
                'address' => 'Plot 44, Block 2, Isolo Industrial Estate, Lagos',
                'is_active' => true,
            ],
            [
                'name' => 'Pfizer Products Limited',
                'contact_person' => 'Mrs. Ngozi Eze',
                'email' => 'nigeria.orders@pfizer.com',
                'phone' => '+234 1 678 9012',
                'address' => '4 Afribank Street, Victoria Island, Lagos',
                'is_active' => true,
            ],
            [
                'name' => 'Sanofi-Aventis Nigeria Limited',
                'contact_person' => 'Mr. Tunde Bakare',
                'email' => 'orders@sanofi.com.ng',
                'phone' => '+234 1 789 0123',
                'address' => 'Km 21, Lagos-Badagry Expressway, Ojo, Lagos',
                'is_active' => true,
            ],
            [
                'name' => 'May & Baker Nigeria Plc',
                'contact_person' => 'Dr. Fatima Mohammed',
                'email' => 'sales@maybaker.com.ng',
                'phone' => '+234 1 890 1234',
                'address' => '3/5 Sapara Street, Industrial Estate, Ikeja, Lagos',
                'is_active' => true,
            ],
            [
                'name' => 'Neimeth International Pharmaceuticals',
                'contact_person' => 'Mr. Chidi Okonkwo',
                'email' => 'info@neimeth.com',
                'phone' => '+234 1 901 2345',
                'address' => '1 Henry Carr Street, Ikeja, Lagos State',
                'is_active' => true,
            ],
        ];

        foreach ($suppliers as $supplier) {
            Supplier::create($supplier);
        }
    }
}

