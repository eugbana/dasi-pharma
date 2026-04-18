<?php

/**
 * Database Integrity Check Script
 * 
 * This script checks for orphaned records and missing relationships
 * in the sales table that could cause null pointer exceptions.
 * 
 * Usage: php database-integrity-check.php
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\Sale;
use App\Models\User;
use Illuminate\Support\Facades\DB;

echo "\n=== Database Integrity Check ===\n\n";

// 1. Check for sales with NULL user_id
echo "1. Checking for sales with NULL user_id...\n";
$nullUserSales = Sale::whereNull('user_id')->count();
echo "   Found: {$nullUserSales} sales with NULL user_id\n";

if ($nullUserSales > 0) {
    $samples = Sale::whereNull('user_id')
        ->select('id', 'sale_number', 'sale_date', 'user_id')
        ->limit(5)
        ->get();
    
    echo "   Sample records:\n";
    foreach ($samples as $sale) {
        echo "   - Sale #{$sale->sale_number} (ID: {$sale->id}) on {$sale->sale_date}\n";
    }
}

echo "\n";

// 2. Check for sales with user_id pointing to non-existent users
echo "2. Checking for sales with deleted/missing users...\n";
$orphanedSales = DB::table('sales')
    ->leftJoin('users', 'sales.user_id', '=', 'users.id')
    ->whereNotNull('sales.user_id')
    ->whereNull('users.id')
    ->count();

echo "   Found: {$orphanedSales} sales with deleted/missing users (hard delete)\n";

if ($orphanedSales > 0) {
    $samples = DB::table('sales')
        ->leftJoin('users', 'sales.user_id', '=', 'users.id')
        ->whereNotNull('sales.user_id')
        ->whereNull('users.id')
        ->select('sales.id', 'sales.sale_number', 'sales.sale_date', 'sales.user_id')
        ->limit(5)
        ->get();
    
    echo "   Sample records:\n";
    foreach ($samples as $sale) {
        echo "   - Sale #{$sale->sale_number} (ID: {$sale->id}) user_id: {$sale->user_id}\n";
    }
}

echo "\n";

// 3. Check for sales with soft-deleted users
echo "3. Checking for sales with soft-deleted users...\n";
$softDeletedUserSales = DB::table('sales')
    ->join('users', 'sales.user_id', '=', 'users.id')
    ->whereNotNull('users.deleted_at')
    ->count();

echo "   Found: {$softDeletedUserSales} sales with soft-deleted users\n";

if ($softDeletedUserSales > 0) {
    $samples = DB::table('sales')
        ->join('users', 'sales.user_id', '=', 'users.id')
        ->whereNotNull('users.deleted_at')
        ->select('sales.id', 'sales.sale_number', 'users.name as user_name', 'users.deleted_at')
        ->limit(5)
        ->get();
    
    echo "   Sample records:\n";
    foreach ($samples as $sale) {
        echo "   - Sale #{$sale->sale_number} User: {$sale->user_name} (deleted: {$sale->deleted_at})\n";
    }
}

echo "\n";

// 4. Summary and recommendations
echo "=== Summary ===\n";
$totalIssues = $nullUserSales + $orphanedSales + $softDeletedUserSales;

if ($totalIssues > 0) {
    echo "⚠️  Total sales with user relationship issues: {$totalIssues}\n\n";
    echo "Recommendations:\n";
    
    if ($nullUserSales > 0) {
        echo "✓ Fix NULL user_id: Assign to a default system user\n";
    }
    
    if ($orphanedSales > 0) {
        echo "✓ Fix orphaned records: Create a 'Deleted User' account and reassign\n";
    }
    
    if ($softDeletedUserSales > 0) {
        echo "✓ Soft-deleted users: Consider restoring or reassigning to system user\n";
    }
    
    echo "\nThe code fixes already applied handle these cases gracefully.\n";
    echo "However, for better data integrity, consider running a data migration.\n";
} else {
    echo "✅ No issues found! Database integrity is good.\n";
}

echo "\n";

// 5. Additional checks
echo "=== Additional Relationship Checks ===\n\n";

// Check approved_by_pharmacist
echo "4. Checking approved_by_pharmacist relationship...\n";
$orphanedPharmacist = DB::table('sales')
    ->leftJoin('users', 'sales.approved_by_pharmacist', '=', 'users.id')
    ->whereNotNull('sales.approved_by_pharmacist')
    ->whereNull('users.id')
    ->count();
echo "   Found: {$orphanedPharmacist} sales with missing pharmacist\n\n";

// Check discount_authorized_by
echo "5. Checking discount_authorized_by relationship...\n";
$orphanedAuthorizer = DB::table('sales')
    ->leftJoin('users', 'sales.discount_authorized_by', '=', 'users.id')
    ->whereNotNull('sales.discount_authorized_by')
    ->whereNull('users.id')
    ->count();
echo "   Found: {$orphanedAuthorizer} sales with missing discount authorizer\n\n";

echo "=== Check Complete ===\n\n";
