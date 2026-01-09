<?php

use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\BarcodeController;
use App\Http\Controllers\BranchController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\DrugController;
use App\Http\Controllers\GoodsReceivedNoteController;
use App\Http\Controllers\PermissionController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\PurchaseOrderController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\SaleController;
use App\Http\Controllers\StockItemController;
use App\Http\Controllers\StockMovementController;
use App\Http\Controllers\StockTransferController;
use App\Http\Controllers\SupplierController;
use App\Http\Controllers\SystemConfigController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

// Redirect root to login or dashboard
Route::get('/', function () {
    return auth()->check() ? redirect()->route('dashboard') : redirect()->route('login');
});

// Authentication Routes
Route::middleware('guest')->group(function () {
    Route::get('/login', [LoginController::class, 'create'])->name('login');
    Route::post('/login', [LoginController::class, 'store']);
});

Route::middleware('auth')->group(function () {
    Route::post('/logout', [LoginController::class, 'destroy'])->name('logout');

    // Dashboard
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

    // User Profile
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::put('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::post('/profile/authorization-code', [ProfileController::class, 'updateAuthorizationCode'])->name('profile.authorization-code');

    // Product Management
    Route::resource('products', DrugController::class);

    // Inventory Management
    Route::resource('stock-items', StockItemController::class);
    Route::resource('stock-movements', StockMovementController::class)->only(['index', 'create', 'store', 'show']);
    Route::resource('stock-transfers', StockTransferController::class);

    // Sales & POS
    Route::resource('sales', SaleController::class)->only(['index', 'create', 'store', 'show']);
    Route::post('sales/{sale}/return', [SaleController::class, 'processReturn'])->name('sales.return');

    // POS Return API
    Route::post('sales/lookup-for-return', [SaleController::class, 'lookupForReturn'])->name('sales.lookup-for-return');
    Route::post('sales/validate-admin', [SaleController::class, 'validateAdminAuth'])->name('sales.validate-admin');
    Route::post('sales/process-return', [SaleController::class, 'processReturnFromPOS'])->name('sales.process-return');

    // Procurement
    Route::resource('suppliers', SupplierController::class);
    Route::resource('purchase-orders', PurchaseOrderController::class)->only(['index', 'create', 'store', 'show']);
    Route::post('purchase-orders/{purchaseOrder}/submit', [PurchaseOrderController::class, 'submitForApproval'])->name('purchase-orders.submit');
    Route::post('purchase-orders/{purchaseOrder}/approve', [PurchaseOrderController::class, 'approve'])->name('purchase-orders.approve');
    Route::post('purchase-orders/{purchaseOrder}/cancel', [PurchaseOrderController::class, 'cancel'])->name('purchase-orders.cancel');
    Route::resource('goods-received-notes', GoodsReceivedNoteController::class)->only(['index', 'create', 'store', 'show']);
    Route::post('goods-received-notes/{goodsReceivedNote}/approve-quality-check', [GoodsReceivedNoteController::class, 'approveQualityCheck'])->name('goods-received-notes.approve-quality-check');

    // Reports & Analytics
    Route::get('reports/sales', [ReportController::class, 'sales'])->name('reports.sales');
    Route::get('reports/inventory', [ReportController::class, 'inventory'])->name('reports.inventory');
    Route::get('reports/procurement', [ReportController::class, 'procurement'])->name('reports.procurement');
    Route::get('reports/sales/export', [ReportController::class, 'exportSales'])->name('reports.sales.export');
    Route::get('reports/return-receipt/{saleReturn}', [ReportController::class, 'returnReceipt'])->name('reports.return-receipt');

    // Barcode Management
    Route::get('barcodes/drugs/{drug}', [BarcodeController::class, 'generate'])->name('barcodes.drug');
    Route::get('barcodes/stock/{stockItem}', [BarcodeController::class, 'generateForStock'])->name('barcodes.stock');
    Route::post('barcodes/lookup', [BarcodeController::class, 'lookup'])->name('barcodes.lookup');
    Route::get('barcodes/print-label/{stockItem}', [BarcodeController::class, 'printLabel'])->name('barcodes.print-label');

    // Product API (Autocomplete & Search)
    Route::get('api/products/autocomplete', [ProductController::class, 'autocomplete'])->name('products.autocomplete');
    Route::get('api/products/barcode', [ProductController::class, 'getByBarcode'])->name('products.barcode');
    Route::post('api/drugs', [ProductController::class, 'store'])->name('api.drugs.store');
    Route::get('api/barcode/lookup', [ProductController::class, 'lookupBarcode'])->name('api.barcode.lookup');
    Route::get('api/categories', [ProductController::class, 'getCategories'])->name('categories.index');
    Route::post('api/categories', [ProductController::class, 'storeCategory'])->name('api.categories.store');
    Route::get('api/categories/{category}/subcategories', [ProductController::class, 'getSubcategories'])->name('categories.subcategories');
    Route::post('api/subcategories', [ProductController::class, 'storeSubcategory'])->name('api.subcategories.store');

    // User Management (Super Admin Only)
    Route::middleware('super.admin')->group(function () {
        Route::resource('users', UserController::class);
        Route::post('users/{user}/toggle-status', [UserController::class, 'toggleStatus'])->name('users.toggle-status');

        // Role Management
        Route::resource('roles', RoleController::class);

        // Permission API endpoints
        Route::get('api/permissions', [PermissionController::class, 'index'])->name('api.permissions.index');
        Route::get('api/permissions/{module}', [PermissionController::class, 'byModule'])->name('api.permissions.by-module');

        // Admin Routes
        Route::prefix('admin')->name('admin.')->group(function () {
            // System Configuration
            Route::get('system-config', [SystemConfigController::class, 'index'])->name('system-config.index');
            Route::put('system-config', [SystemConfigController::class, 'update'])->name('system-config.update');

            // Branch Management
            Route::resource('branches', BranchController::class);
        });
    });

    // API endpoints for VAT and receipt config (accessible to all authenticated users)
    Route::get('api/vat-rate', [SystemConfigController::class, 'getVatRate'])->name('api.vat-rate');
    Route::get('api/receipt-config', [SystemConfigController::class, 'getReceiptConfig'])->name('api.receipt-config');
});
