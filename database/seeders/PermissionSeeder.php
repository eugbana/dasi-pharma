<?php

namespace Database\Seeders;

use App\Models\Permission;
use Illuminate\Database\Seeder;

class PermissionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     * 
     * Seeds all system permissions grouped by module.
     */
    public function run(): void
    {
        $permissions = [
            // Dashboard Module
            ['name' => 'dashboard.view', 'description' => 'Access dashboard', 'module' => 'dashboard'],

            // Inventory Module
            ['name' => 'inventory.view', 'description' => 'View inventory and stock levels', 'module' => 'inventory'],
            ['name' => 'inventory.manage', 'description' => 'Add, edit, and delete inventory items', 'module' => 'inventory'],
            ['name' => 'inventory.adjust', 'description' => 'Perform stock adjustments', 'module' => 'inventory'],
            ['name' => 'inventory.approve_transfer', 'description' => 'Approve stock transfers', 'module' => 'inventory'],
            ['name' => 'inventory.view_reports', 'description' => 'View inventory reports', 'module' => 'inventory'],

            // Sales Module
            ['name' => 'sales.create', 'description' => 'Process sales transactions', 'module' => 'sales'],
            ['name' => 'sales.view', 'description' => 'View sales records', 'module' => 'sales'],
            ['name' => 'sales.approve_controlled_substance', 'description' => 'Approve sales of controlled substances', 'module' => 'sales'],
            ['name' => 'sales.process_return', 'description' => 'Process sales returns', 'module' => 'sales'],
            ['name' => 'sales.apply_discount', 'description' => 'Apply discounts to sales', 'module' => 'sales'],
            ['name' => 'sales.view_reports', 'description' => 'View sales reports', 'module' => 'sales'],

            // Procurement Module
            ['name' => 'procurement.create_po', 'description' => 'Create purchase orders', 'module' => 'procurement'],
            ['name' => 'procurement.approve_po', 'description' => 'Approve purchase orders', 'module' => 'procurement'],
            ['name' => 'procurement.receive_goods', 'description' => 'Receive goods and create GRN', 'module' => 'procurement'],
            ['name' => 'procurement.quality_check', 'description' => 'Perform quality checks on received goods', 'module' => 'procurement'],
            ['name' => 'procurement.manage_suppliers', 'description' => 'Add, edit, and delete suppliers', 'module' => 'procurement'],
            ['name' => 'procurement.view_reports', 'description' => 'View procurement reports', 'module' => 'procurement'],

            // Drugs Module
            ['name' => 'drugs.view', 'description' => 'View drug catalog', 'module' => 'drugs'],
            ['name' => 'drugs.manage', 'description' => 'Add, edit, and delete drugs', 'module' => 'drugs'],

            // Users Module
            ['name' => 'users.view', 'description' => 'View user accounts', 'module' => 'users'],
            ['name' => 'users.manage', 'description' => 'Add, edit, and delete user accounts', 'module' => 'users'],
            ['name' => 'users.assign_roles', 'description' => 'Assign roles to users', 'module' => 'users'],

            // Branches Module
            ['name' => 'branches.view', 'description' => 'View branch information', 'module' => 'branches'],
            ['name' => 'branches.manage', 'description' => 'Add, edit, and delete branches', 'module' => 'branches'],

            // Reports Module
            ['name' => 'reports.view_all', 'description' => 'View all system reports', 'module' => 'reports'],
            ['name' => 'reports.export', 'description' => 'Export reports to PDF/Excel', 'module' => 'reports'],
            ['name' => 'reports.financial', 'description' => 'View financial reports', 'module' => 'reports'],

            // Settings Module
            ['name' => 'settings.view', 'description' => 'View system settings', 'module' => 'settings'],
            ['name' => 'settings.manage', 'description' => 'Modify system settings', 'module' => 'settings'],

            // POS Desktop Module
            ['name' => 'pos.offline_mode', 'description' => 'Allow offline transactions', 'module' => 'pos'],
            ['name' => 'pos.cash_drawer', 'description' => 'Access cash drawer', 'module' => 'pos'],
            ['name' => 'pos.void_transaction', 'description' => 'Void completed sales', 'module' => 'pos'],
            ['name' => 'pos.price_override', 'description' => 'Override selling prices', 'module' => 'pos'],
            ['name' => 'pos.reprint_receipt', 'description' => 'Reprint receipts', 'module' => 'pos'],
            ['name' => 'pos.start_shift', 'description' => 'Start a POS shift', 'module' => 'pos'],
            ['name' => 'pos.end_shift', 'description' => 'End a POS shift', 'module' => 'pos'],
            ['name' => 'pos.view_shift_report', 'description' => 'View shift reports', 'module' => 'pos'],
        ];

        foreach ($permissions as $permission) {
            Permission::updateOrCreate(
                ['name' => $permission['name']],
                $permission
            );
        }
    }
}

