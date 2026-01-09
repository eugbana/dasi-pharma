<?php

namespace Database\Seeders;

use App\Models\Role;
use Illuminate\Database\Seeder;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     * 
     * Seeds the four main system roles:
     * - Super Admin: Full system access
     * - Pharmacist: Can approve controlled substances and prescriptions
     * - Store Manager: Can manage inventory and approve transfers
     * - Sales Staff: Can process sales and view inventory
     */
    public function run(): void
    {
        $roles = [
            [
                'name' => 'Super Admin',
                'description' => 'Full system access with all permissions',
            ],
            [
                'name' => 'Pharmacist',
                'description' => 'Can approve controlled substances, prescriptions, and manage clinical operations',
            ],
            [
                'name' => 'Store Manager',
                'description' => 'Can manage inventory, approve transfers and purchase orders',
            ],
            [
                'name' => 'Sales Staff',
                'description' => 'Can process sales, view inventory, and handle customer transactions',
            ],
        ];

        foreach ($roles as $role) {
            Role::create($role);
        }
    }
}

