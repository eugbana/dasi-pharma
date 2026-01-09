<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * Seeds data in the correct order to respect foreign key constraints:
     * 1. Roles
     * 2. Permissions
     * 3. Role-Permission assignments
     * 4. Branches
     * 5. Users (requires roles and branches)
     * 6. Drugs
     * 7. Suppliers
     */
    public function run(): void
    {
        $this->call([
            RoleSeeder::class,
            PermissionSeeder::class,
            RolePermissionSeeder::class,
            BranchSeeder::class,
            UserSeeder::class,
            DrugSeeder::class,
            SupplierSeeder::class,
        ]);

        $this->command->info('✅ Database seeded successfully!');
        $this->command->info('');
        $this->command->info('📧 Login credentials:');
        $this->command->info('   Email: admin@dasipharma.ng');
        $this->command->info('   Password: password');
        $this->command->info('');
        $this->command->info('🏥 Branches created: 4');
        $this->command->info('👥 Users created: 7');
        $this->command->info('💊 Drugs created: 15');
        $this->command->info('🏭 Suppliers created: 8');
        $this->command->info('🔐 Roles created: 4');
        $this->command->info('🔑 Permissions created: 31');
    }
}
