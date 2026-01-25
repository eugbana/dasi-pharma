<?php

namespace Database\Seeders;

use App\Models\Permission;
use App\Models\Role;
use Illuminate\Database\Seeder;

class RolePermissionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     * 
     * Assigns permissions to roles based on their responsibilities.
     */
    public function run(): void
    {
        // Get all roles
        $superAdmin = Role::where('name', 'Super Admin')->first();
        $pharmacist = Role::where('name', 'Pharmacist')->first();
        $storeManager = Role::where('name', 'Store Manager')->first();
        $salesStaff = Role::where('name', 'Sales Staff')->first();
        $cashier = Role::where('name', 'Cashier')->first();

        // Super Admin gets all permissions
        $allPermissions = Permission::all();
        $superAdmin->permissions()->sync($allPermissions->pluck('id'));

        // Pharmacist permissions
        $pharmacistPermissions = Permission::whereIn('name', [
            // Dashboard
            'dashboard.view',

            // Inventory
            'inventory.view',
            'inventory.manage',
            'inventory.view_reports',

            // Sales - including controlled substances
            'sales.create',
            'sales.view',
            'sales.approve_controlled_substance',
            'sales.process_return',
            'sales.apply_discount',
            'sales.view_reports',

            // Procurement
            'procurement.create_po',
            'procurement.receive_goods',
            'procurement.quality_check',
            'procurement.view_reports',

            // Drugs
            'drugs.view',
            'drugs.manage',

            // Reports
            'reports.view_all',
            'reports.export',
        ])->get();
        $pharmacist->permissions()->sync($pharmacistPermissions->pluck('id'));

        // Store Manager permissions
        $storeManagerPermissions = Permission::whereIn('name', [
            // Dashboard
            'dashboard.view',

            // Inventory
            'inventory.view',
            'inventory.manage',
            'inventory.adjust',
            'inventory.approve_transfer',
            'inventory.view_reports',

            // Sales
            'sales.create',
            'sales.view',
            'sales.process_return',
            'sales.apply_discount',
            'sales.view_reports',

            // Procurement
            'procurement.create_po',
            'procurement.approve_po',
            'procurement.receive_goods',
            'procurement.quality_check',
            'procurement.manage_suppliers',
            'procurement.view_reports',

            // Drugs
            'drugs.view',
            'drugs.manage',

            // Users (limited)
            'users.view',

            // Branches
            'branches.view',

            // Reports
            'reports.view_all',
            'reports.export',
            'reports.financial',
        ])->get();
        $storeManager->permissions()->sync($storeManagerPermissions->pluck('id'));

        // Sales Staff permissions
        $salesStaffPermissions = Permission::whereIn('name', [
            // Dashboard
            'dashboard.view',

            // Inventory (view only)
            'inventory.view',

            // Sales (basic)
            'sales.create',
            'sales.view',

            // Drugs (view only)
            'drugs.view',
        ])->get();
        $salesStaff->permissions()->sync($salesStaffPermissions->pluck('id'));

        // Cashier permissions
        $cashierPermissions = Permission::whereIn('name', [
            // Dashboard
            'dashboard.view',

            // Sales (basic)
            'sales.create',
            'sales.view',

            // POS operations
            'pos.cash_drawer',
            'pos.reprint_receipt',
            'pos.start_shift',
            'pos.end_shift',
            'pos.view_shift_report',
        ])->get();
        $cashier->permissions()->sync($cashierPermissions->pluck('id'));
    }
}

