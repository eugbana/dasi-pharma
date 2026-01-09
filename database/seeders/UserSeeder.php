<?php

namespace Database\Seeders;

use App\Models\Branch;
use App\Models\Role;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     * 
     * Seeds sample users for each role and branch.
     */
    public function run(): void
    {
        // Get roles
        $superAdminRole = Role::where('name', 'Super Admin')->first();
        $pharmacistRole = Role::where('name', 'Pharmacist')->first();
        $storeManagerRole = Role::where('name', 'Store Manager')->first();
        $salesStaffRole = Role::where('name', 'Sales Staff')->first();

        // Get branches
        $ikejaBranch = Branch::where('code', 'IKJ')->first();
        $viBranch = Branch::where('code', 'VI')->first();
        $abujaBranch = Branch::where('code', 'ABJ')->first();

        $users = [
            // Super Admin
            [
                'name' => 'Admin User',
                'email' => 'admin@dasipharma.ng',
                'password' => Hash::make('password'),
                'role_id' => $superAdminRole->id,
                'branch_id' => $ikejaBranch->id,
                'is_active' => true,
            ],

            // Pharmacists
            [
                'name' => 'Dr. Adebayo Okonkwo',
                'email' => 'adebayo@dasipharma.ng',
                'password' => Hash::make('password'),
                'role_id' => $pharmacistRole->id,
                'branch_id' => $ikejaBranch->id,
                'is_active' => true,
            ],
            [
                'name' => 'Pharm. Chioma Nwosu',
                'email' => 'chioma@dasipharma.ng',
                'password' => Hash::make('password'),
                'role_id' => $pharmacistRole->id,
                'branch_id' => $viBranch->id,
                'is_active' => true,
            ],

            // Store Managers
            [
                'name' => 'Ibrahim Musa',
                'email' => 'ibrahim@dasipharma.ng',
                'password' => Hash::make('password'),
                'role_id' => $storeManagerRole->id,
                'branch_id' => $ikejaBranch->id,
                'is_active' => true,
            ],
            [
                'name' => 'Ngozi Eze',
                'email' => 'ngozi@dasipharma.ng',
                'password' => Hash::make('password'),
                'role_id' => $storeManagerRole->id,
                'branch_id' => $abujaBranch->id,
                'is_active' => true,
            ],

            // Sales Staff
            [
                'name' => 'Tunde Adeyemi',
                'email' => 'tunde@dasipharma.ng',
                'password' => Hash::make('password'),
                'role_id' => $salesStaffRole->id,
                'branch_id' => $ikejaBranch->id,
                'is_active' => true,
            ],
            [
                'name' => 'Blessing Okoro',
                'email' => 'blessing@dasipharma.ng',
                'password' => Hash::make('password'),
                'role_id' => $salesStaffRole->id,
                'branch_id' => $viBranch->id,
                'is_active' => true,
            ],
        ];

        foreach ($users as $user) {
            User::create($user);
        }
    }
}

