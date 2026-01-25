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
    // IMPORTANT: Specific routes (/create, /edit) must be registered BEFORE dynamic routes (/{id})
    Route::middleware('permission:drugs.manage')->group(function () {
        Route::get('products/create', [DrugController::class, 'create'])->name('products.create');
        Route::post('products', [DrugController::class, 'store'])->name('products.store');
        Route::get('products/{product}/edit', [DrugController::class, 'edit'])->name('products.edit');
        Route::put('products/{product}', [DrugController::class, 'update'])->name('products.update');
        Route::delete('products/{product}', [DrugController::class, 'destroy'])->name('products.destroy');
    });
    Route::middleware('permission:drugs.view')->group(function () {
        Route::get('products', [DrugController::class, 'index'])->name('products.index');
        Route::get('products/{product}', [DrugController::class, 'show'])->name('products.show');
    });

    // Inventory Management
    // IMPORTANT: Specific routes (/create, /edit) must be registered BEFORE dynamic routes (/{id})
    Route::middleware('permission:inventory.manage')->group(function () {
        Route::get('stock-items/create', [StockItemController::class, 'create'])->name('stock-items.create');
        Route::post('stock-items', [StockItemController::class, 'store'])->name('stock-items.store');
        Route::get('stock-items/{stock_item}/edit', [StockItemController::class, 'edit'])->name('stock-items.edit');
        Route::put('stock-items/{stock_item}', [StockItemController::class, 'update'])->name('stock-items.update');
        Route::delete('stock-items/{stock_item}', [StockItemController::class, 'destroy'])->name('stock-items.destroy');
    });
    Route::middleware('permission:inventory.adjust')->group(function () {
        Route::get('stock-movements/create', [StockMovementController::class, 'create'])->name('stock-movements.create');
        Route::post('stock-movements', [StockMovementController::class, 'store'])->name('stock-movements.store');
        Route::get('stock-transfers/create', [StockTransferController::class, 'create'])->name('stock-transfers.create');
        Route::post('stock-transfers', [StockTransferController::class, 'store'])->name('stock-transfers.store');
        Route::get('stock-transfers/{stock_transfer}/edit', [StockTransferController::class, 'edit'])->name('stock-transfers.edit');
        Route::put('stock-transfers/{stock_transfer}', [StockTransferController::class, 'update'])->name('stock-transfers.update');
    });
    Route::middleware('permission:inventory.view')->group(function () {
        Route::get('stock-items', [StockItemController::class, 'index'])->name('stock-items.index');
        Route::get('stock-items/{stock_item}', [StockItemController::class, 'show'])->name('stock-items.show');
        Route::get('stock-movements', [StockMovementController::class, 'index'])->name('stock-movements.index');
        Route::get('stock-movements/{stock_movement}', [StockMovementController::class, 'show'])->name('stock-movements.show');
        Route::get('stock-transfers', [StockTransferController::class, 'index'])->name('stock-transfers.index');
        Route::get('stock-transfers/{stock_transfer}', [StockTransferController::class, 'show'])->name('stock-transfers.show');
    });
    Route::middleware('permission:inventory.approve_transfer')->group(function () {
        Route::delete('stock-transfers/{stock_transfer}', [StockTransferController::class, 'destroy'])->name('stock-transfers.destroy');
    });

    // Sales & POS
    // IMPORTANT: Specific routes (sales/create) must be registered BEFORE dynamic routes (sales/{sale})
    // to prevent Laravel from matching "create" as a {sale} parameter
    Route::middleware('permission:sales.create')->group(function () {
        Route::get('sales/create', [SaleController::class, 'create'])->name('sales.create');
        Route::post('sales', [SaleController::class, 'store'])->name('sales.store');
        Route::post('sales/validate-discount-auth', [SaleController::class, 'validateDiscountAuth'])->name('sales.validate-discount-auth');
    });
    Route::middleware('permission:sales.view')->group(function () {
        Route::get('sales', [SaleController::class, 'index'])->name('sales.index');
        Route::get('sales/{sale}', [SaleController::class, 'show'])->name('sales.show');
    });
    Route::middleware('permission:sales.process_return')->group(function () {
        Route::post('sales/{sale}/return', [SaleController::class, 'processReturn'])->name('sales.return');
        Route::post('sales/lookup-for-return', [SaleController::class, 'lookupForReturn'])->name('sales.lookup-for-return');
        Route::post('sales/validate-admin', [SaleController::class, 'validateAdminAuth'])->name('sales.validate-admin');
        Route::post('sales/process-return', [SaleController::class, 'processReturnFromPOS'])->name('sales.process-return');
    });

    // Procurement
    Route::middleware('permission:procurement.manage_suppliers')->group(function () {
        Route::resource('suppliers', SupplierController::class);
    });
    Route::middleware('permission:procurement.create_po')->group(function () {
        Route::get('purchase-orders', [PurchaseOrderController::class, 'index'])->name('purchase-orders.index');
        Route::get('purchase-orders/create', [PurchaseOrderController::class, 'create'])->name('purchase-orders.create');
        Route::post('purchase-orders', [PurchaseOrderController::class, 'store'])->name('purchase-orders.store');
        Route::get('purchase-orders/{purchase_order}', [PurchaseOrderController::class, 'show'])->name('purchase-orders.show');
        Route::post('purchase-orders/{purchaseOrder}/submit', [PurchaseOrderController::class, 'submitForApproval'])->name('purchase-orders.submit');
        Route::post('purchase-orders/{purchaseOrder}/cancel', [PurchaseOrderController::class, 'cancel'])->name('purchase-orders.cancel');
    });
    Route::middleware('permission:procurement.approve_po')->group(function () {
        Route::post('purchase-orders/{purchaseOrder}/approve', [PurchaseOrderController::class, 'approve'])->name('purchase-orders.approve');
    });
    Route::middleware('permission:procurement.receive_goods')->group(function () {
        Route::get('goods-received-notes', [GoodsReceivedNoteController::class, 'index'])->name('goods-received-notes.index');
        Route::get('goods-received-notes/create', [GoodsReceivedNoteController::class, 'create'])->name('goods-received-notes.create');
        Route::post('goods-received-notes', [GoodsReceivedNoteController::class, 'store'])->name('goods-received-notes.store');
        Route::get('goods-received-notes/{goods_received_note}', [GoodsReceivedNoteController::class, 'show'])->name('goods-received-notes.show');
    });
    Route::middleware('permission:procurement.quality_check')->group(function () {
        Route::post('goods-received-notes/{goodsReceivedNote}/approve-quality-check', [GoodsReceivedNoteController::class, 'approveQualityCheck'])->name('goods-received-notes.approve-quality-check');
    });

    // Reports & Analytics
    Route::middleware('permission:reports.view_all|sales.view_reports')->group(function () {
        Route::get('reports/sales', [ReportController::class, 'sales'])->name('reports.sales');
        Route::get('reports/sales/export', [ReportController::class, 'exportSales'])->name('reports.sales.export');
    });
    Route::middleware('permission:reports.view_all|inventory.view_reports')->group(function () {
        Route::get('reports/inventory', [ReportController::class, 'inventory'])->name('reports.inventory');
    });
    Route::middleware('permission:reports.view_all|procurement.view_reports')->group(function () {
        Route::get('reports/procurement', [ReportController::class, 'procurement'])->name('reports.procurement');
    });
    Route::middleware('permission:sales.process_return')->group(function () {
        Route::get('reports/return-receipt/{saleReturn}', [ReportController::class, 'returnReceipt'])->name('reports.return-receipt');
    });

    // Barcode Management
    Route::middleware('permission:inventory.view|sales.create')->group(function () {
        Route::get('barcodes/drugs/{drug}', [BarcodeController::class, 'generate'])->name('barcodes.drug');
        Route::get('barcodes/stock/{stockItem}', [BarcodeController::class, 'generateForStock'])->name('barcodes.stock');
        Route::post('barcodes/lookup', [BarcodeController::class, 'lookup'])->name('barcodes.lookup');
        Route::get('barcodes/print-label/{stockItem}', [BarcodeController::class, 'printLabel'])->name('barcodes.print-label');
    });

    // Product API (Autocomplete & Search) - accessible to users who can view drugs or create sales
    Route::middleware('permission:drugs.view|sales.create')->group(function () {
        Route::get('api/products/autocomplete', [ProductController::class, 'autocomplete'])->name('products.autocomplete');
        Route::get('api/products/barcode', [ProductController::class, 'getByBarcode'])->name('products.barcode');
        Route::get('api/barcode/lookup', [ProductController::class, 'lookupBarcode'])->name('api.barcode.lookup');
        Route::get('api/categories', [ProductController::class, 'getCategories'])->name('categories.index');
        Route::get('api/categories/{category}/subcategories', [ProductController::class, 'getSubcategories'])->name('categories.subcategories');
    });
    Route::middleware('permission:drugs.manage')->group(function () {
        Route::post('api/drugs', [ProductController::class, 'store'])->name('api.drugs.store');
        Route::post('api/categories', [ProductController::class, 'storeCategory'])->name('api.categories.store');
        Route::put('api/categories/{category}', [ProductController::class, 'updateCategory'])->name('api.categories.update');
        Route::delete('api/categories/{category}', [ProductController::class, 'deleteCategory'])->name('api.categories.delete');
        Route::post('api/subcategories', [ProductController::class, 'storeSubcategory'])->name('api.subcategories.store');
        Route::put('api/subcategories/{subcategory}', [ProductController::class, 'updateSubcategory'])->name('api.subcategories.update');
        Route::delete('api/subcategories/{subcategory}', [ProductController::class, 'deleteSubcategory'])->name('api.subcategories.delete');
    });

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

    // API endpoint for branch selection persistence
    Route::post('api/set-branch', [BranchController::class, 'setSelectedBranch'])->name('api.set-branch');
});
