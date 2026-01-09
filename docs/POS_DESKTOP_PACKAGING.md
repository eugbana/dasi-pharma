# POS Desktop Application Packaging Specification

## Overview

This document outlines the comprehensive packaging strategy for the Dasi Pharma POS system as a desktop application using NativePHP. The implementation focuses on role-based access control, barcode scanner integration, thermal printer support, and enhanced security for pharmaceutical retail operations.

## Architecture

### Technology Stack
- **Framework**: Laravel 11 with NativePHP
- **Desktop Runtime**: Electron (via NativePHP)
- **Database**: SQLite (local) with MySQL sync capability
- **Barcode**: Picqer/Barcode-Generator (Code128, EAN-13)
- **Printing**: ESC/POS protocol for thermal printers

### Application Structure
```
├── app/
│   ├── Providers/
│   │   └── NativeAppServiceProvider.php    # Desktop-specific bootstrapping
│   ├── Services/
│   │   ├── POSSessionService.php           # Session management
│   │   ├── POSAuditService.php             # Audit logging
│   │   └── ThermalPrinterService.php       # Receipt printing
│   └── Http/
│       └── Middleware/
│           └── POSDesktopMiddleware.php    # Desktop security checks
├── config/
│   ├── nativephp.php                       # NativePHP configuration
│   └── pos-desktop.php                     # POS-specific settings
└── resources/
    └── views/
        └── pos/                            # POS-specific views
```

## Role-Based Access Control

### Permission Matrix for POS Desktop

| Role | Permissions | Desktop Features |
|------|-------------|------------------|
| **Pharmacist** | sales.create, sales.approve_controlled_substance, inventory.view | Full POS, controlled substance approval |
| **Pharmacy Technician** | sales.create, inventory.view | Standard POS, no controlled substances |
| **Cashier** | sales.create, sales.view | Basic POS, no prescription drugs |
| **Branch Manager** | All sales.*, inventory.*, reports.view_all | Full access + reports |
| **Admin** | All permissions | System configuration |

### Desktop-Specific Permissions
```php
// Additional permissions for desktop app
'pos.offline_mode'           // Allow offline transactions
'pos.cash_drawer'            // Access cash drawer
'pos.void_transaction'       // Void completed sales
'pos.price_override'         // Override selling prices
'pos.reprint_receipt'        // Reprint receipts
```

## Barcode Scanner Integration

### Supported Barcode Types
- **Code128**: Primary format for internal barcodes
- **EAN-13**: Standard pharmaceutical barcodes
- **QR Code**: Extended product information

### Scanner Configuration
```php
// config/pos-desktop.php
'barcode' => [
    'scanner_mode' => 'keyboard_wedge',  // keyboard_wedge, serial, hid
    'prefix' => '',                       // Scanner prefix character
    'suffix' => "\r",                     // Scanner suffix (Enter key)
    'timeout' => 100,                     // ms between characters
    'auto_submit' => true,                // Auto-submit on scan
],
```

### Barcode Lookup Flow
1. Scanner sends barcode as keyboard input
2. JavaScript captures rapid input (< 100ms between chars)
3. API call to `/api/barcode/lookup`
4. Returns drug info + available stock items
5. Auto-adds to cart with FEFO selection

## Thermal Printer Integration

### Supported Printers
- Epson TM-T88 series
- Star TSP100 series
- Generic ESC/POS compatible

### Receipt Format
```
================================
        DASI PHARMA
      [Branch Name]
     [Branch Address]
================================
Date: [Date]     Time: [Time]
Receipt #: [Invoice Number]
Cashier: [User Name]
--------------------------------
[Item Name]
  [Qty] x [Price]        [Total]
--------------------------------
Subtotal:              [Amount]
Discount:              [Amount]
VAT (16%):             [Amount]
================================
TOTAL:                 [Amount]
================================
Payment: [Method]
--------------------------------
Thank you for your purchase!
Pharmacist: [Name] (Reg: [#])
================================
```

### Cash Drawer Integration
```php
// Trigger cash drawer via printer
$printer->pulse(0);  // Drawer kick on pin 2
```

## Security Enhancements

### Session Management
- Auto-logout after configurable inactivity (default: 15 minutes)
- Session pinning to hardware ID
- Concurrent session prevention per user
- Shift-based session tracking

### Audit Trail
All POS actions are logged with:
- User ID and role
- Timestamp (local + server)
- Action type and details
- Hardware identifier
- IP address (when online)

### Offline Security
- Encrypted local database (SQLite with SQLCipher)
- Transaction signing with device key
- Sync verification on reconnection
- Maximum offline transaction limit

## Offline Mode

### Capabilities When Offline
- Process sales (with limits)
- View local inventory
- Print receipts
- Barcode scanning

### Sync Strategy
```php
// Sync priority order
1. Pending sales transactions
2. Stock adjustments
3. Audit logs
4. Inventory updates (download)
```

### Conflict Resolution
- Server timestamp takes precedence
- Stock conflicts flagged for review
- Sales always preserved (never deleted)

## Installation & Deployment

### System Requirements
- **OS**: Windows 10/11, macOS 12+, Ubuntu 20.04+
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 500MB for app, 2GB for data
- **Display**: 1366x768 minimum
- **Peripherals**: USB barcode scanner, thermal printer

### Build Commands
```bash
# Development
php artisan native:serve

# Production builds
php artisan native:build win      # Windows .exe
php artisan native:build mac      # macOS .dmg
php artisan native:build linux    # Linux .AppImage
```

### Auto-Update Configuration
```php
// config/nativephp.php
'updater' => [
    'enabled' => true,
    'provider' => 's3',
    'bucket' => env('UPDATE_BUCKET'),
    'check_interval' => 3600,  // seconds
],
```

## Configuration Files

### NativePHP Configuration (config/nativephp.php)
```php
return [
    'app_id' => 'com.dasipharma.pos',
    'version' => env('APP_VERSION', '1.0.0'),

    'window' => [
        'width' => 1366,
        'height' => 768,
        'min_width' => 1024,
        'min_height' => 600,
        'resizable' => true,
        'fullscreen' => false,
        'kiosk' => env('POS_KIOSK_MODE', false),
    ],

    'menu' => [
        'enabled' => true,
        'items' => [
            'file' => ['logout', 'exit'],
            'pos' => ['new_sale', 'returns', 'cash_drawer'],
            'reports' => ['daily_sales', 'shift_report'],
            'help' => ['about', 'support'],
        ],
    ],
];
```

### POS Desktop Configuration (config/pos-desktop.php)
```php
return [
    'session' => [
        'timeout' => env('POS_SESSION_TIMEOUT', 900),
        'require_shift' => true,
        'max_offline_hours' => 24,
    ],

    'printer' => [
        'type' => env('POS_PRINTER_TYPE', 'thermal'),
        'connection' => env('POS_PRINTER_CONNECTION', 'usb'),
        'port' => env('POS_PRINTER_PORT'),
        'paper_width' => 80,  // mm
    ],

    'barcode' => [
        'scanner_mode' => 'keyboard_wedge',
        'suffix' => "\r",
        'timeout' => 100,
    ],

    'security' => [
        'encrypt_local_db' => true,
        'require_pin' => false,
        'max_offline_transactions' => 100,
    ],
];
```

## API Endpoints for Desktop

### POS-Specific Routes
```php
// routes/api.php - POS Desktop routes
Route::prefix('pos')->middleware(['auth:sanctum', 'pos.desktop'])->group(function () {
    // Session management
    Route::post('/shift/start', [POSController::class, 'startShift']);
    Route::post('/shift/end', [POSController::class, 'endShift']);

    // Sales operations
    Route::post('/sale', [POSController::class, 'processSale']);
    Route::post('/sale/{sale}/void', [POSController::class, 'voidSale']);
    Route::post('/sale/{sale}/return', [POSController::class, 'processReturn']);

    // Hardware integration
    Route::post('/drawer/open', [POSController::class, 'openDrawer']);
    Route::post('/receipt/print', [POSController::class, 'printReceipt']);
    Route::post('/receipt/reprint/{sale}', [POSController::class, 'reprintReceipt']);

    // Sync operations
    Route::post('/sync/upload', [POSSyncController::class, 'upload']);
    Route::get('/sync/download', [POSSyncController::class, 'download']);
    Route::get('/sync/status', [POSSyncController::class, 'status']);
});
```

## Testing Strategy

### Desktop-Specific Tests
```php
// tests/Feature/POS/
├── BarcodeIntegrationTest.php
├── OfflineModeTest.php
├── PrinterIntegrationTest.php
├── SessionManagementTest.php
└── SyncOperationsTest.php
```

### Hardware Simulation
```php
// For CI/CD testing without hardware
'testing' => [
    'simulate_scanner' => true,
    'simulate_printer' => true,
    'simulate_drawer' => true,
],
```

## Monitoring & Logging

### Desktop Logs Location
- **Windows**: `%APPDATA%/DasiPharmaPOS/logs/`
- **macOS**: `~/Library/Logs/DasiPharmaPOS/`
- **Linux**: `~/.local/share/DasiPharmaPOS/logs/`

### Log Channels
```php
// config/logging.php additions
'pos_desktop' => [
    'driver' => 'daily',
    'path' => storage_path('logs/pos-desktop.log'),
    'level' => 'debug',
    'days' => 30,
],

'pos_audit' => [
    'driver' => 'daily',
    'path' => storage_path('logs/pos-audit.log'),
    'level' => 'info',
    'days' => 90,
],
```

