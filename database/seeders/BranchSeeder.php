<?php

namespace Database\Seeders;

use App\Models\Branch;
use Illuminate\Database\Seeder;

class BranchSeeder extends Seeder
{
    /**
     * Run the database seeds.
     * 
     * Seeds sample pharmacy branches across Nigeria.
     */
    public function run(): void
    {
        $branches = [
            [
                'name' => 'Dasi Pharma - Ikeja',
                'code' => 'IKJ',
                'address' => '45 Allen Avenue, Ikeja, Lagos State',
                'phone' => '+234 803 123 4567',
                'email' => 'ikeja@dasipharma.ng',
                'is_active' => true,
            ],
            [
                'name' => 'Dasi Pharma - Victoria Island',
                'code' => 'VI',
                'address' => '12 Adeola Odeku Street, Victoria Island, Lagos State',
                'phone' => '+234 803 234 5678',
                'email' => 'vi@dasipharma.ng',
                'is_active' => true,
            ],
            [
                'name' => 'Dasi Pharma - Abuja',
                'code' => 'ABJ',
                'address' => '78 Gimbiya Street, Garki, Abuja FCT',
                'phone' => '+234 803 345 6789',
                'email' => 'abuja@dasipharma.ng',
                'is_active' => true,
            ],
            [
                'name' => 'Dasi Pharma - Port Harcourt',
                'code' => 'PHC',
                'address' => '23 Aba Road, Port Harcourt, Rivers State',
                'phone' => '+234 803 456 7890',
                'email' => 'portharcourt@dasipharma.ng',
                'is_active' => true,
            ],
        ];

        foreach ($branches as $branch) {
            Branch::create($branch);
        }
    }
}

