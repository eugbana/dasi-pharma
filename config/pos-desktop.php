<?php

/**
 * POS Desktop Configuration for Dasi Pharma.
 * 
 * This configuration defines POS-specific settings including session management,
 * hardware integration, barcode scanning, and security settings.
 */

return [
    /*
    |--------------------------------------------------------------------------
    | Session Configuration
    |--------------------------------------------------------------------------
    |
    | Settings for POS session management including timeouts and shift requirements.
    |
    */
    'session' => [
        // Session timeout in seconds (default: 15 minutes)
        'timeout' => (int) env('POS_SESSION_TIMEOUT', 900),
        
        // Require an active shift for sales operations
        'require_shift' => env('POS_REQUIRE_SHIFT', true),
        
        // Maximum hours allowed in offline mode
        'max_offline_hours' => (int) env('POS_MAX_OFFLINE_HOURS', 24),
        
        // Warn user before session timeout (seconds before timeout)
        'timeout_warning' => 60,
    ],

    /*
    |--------------------------------------------------------------------------
    | Printer Configuration
    |--------------------------------------------------------------------------
    |
    | Settings for thermal receipt printer integration.
    |
    */
    'printer' => [
        // Printer type: thermal, laser, pdf
        'type' => env('POS_PRINTER_TYPE', 'thermal'),
        
        // Connection type: usb, network, bluetooth
        'connection' => env('POS_PRINTER_CONNECTION', 'usb'),
        
        // Printer port or IP address
        'port' => env('POS_PRINTER_PORT'),
        
        // Paper width in mm (58 or 80)
        'paper_width' => (int) env('POS_PAPER_WIDTH', 80),
        
        // Auto-cut after printing
        'auto_cut' => env('POS_PRINTER_AUTO_CUT', true),
        
        // Open cash drawer after sale
        'open_drawer_on_sale' => env('POS_OPEN_DRAWER_ON_SALE', true),
        
        // Number of receipt copies
        'copies' => (int) env('POS_RECEIPT_COPIES', 1),
    ],

    /*
    |--------------------------------------------------------------------------
    | Barcode Scanner Configuration
    |--------------------------------------------------------------------------
    |
    | Settings for barcode scanner integration.
    |
    */
    'barcode' => [
        // Scanner mode: keyboard_wedge, serial, hid
        'scanner_mode' => env('POS_SCANNER_MODE', 'keyboard_wedge'),
        
        // Prefix character sent by scanner (if any)
        'prefix' => env('POS_SCANNER_PREFIX', ''),
        
        // Suffix character sent by scanner (usually Enter)
        'suffix' => env('POS_SCANNER_SUFFIX', "\r"),
        
        // Maximum time between characters (ms) to detect scan vs typing
        'timeout' => (int) env('POS_SCANNER_TIMEOUT', 100),
        
        // Automatically submit form after scan
        'auto_submit' => env('POS_SCANNER_AUTO_SUBMIT', true),
        
        // Supported barcode types
        'supported_types' => ['CODE128', 'EAN13', 'EAN8', 'UPCA', 'UPCE', 'QR'],
    ],

    /*
    |--------------------------------------------------------------------------
    | Security Configuration
    |--------------------------------------------------------------------------
    |
    | Security settings for the POS desktop application.
    |
    */
    'security' => [
        // Encrypt local SQLite database
        'encrypt_local_db' => env('POS_ENCRYPT_DB', true),
        
        // Require PIN for certain operations
        'require_pin' => env('POS_REQUIRE_PIN', false),
        
        // Maximum offline transactions before requiring sync
        'max_offline_transactions' => (int) env('POS_MAX_OFFLINE_TX', 100),
        
        // Lock screen after timeout
        'lock_on_timeout' => env('POS_LOCK_ON_TIMEOUT', true),
        
        // Require manager approval for discounts above this percentage
        'discount_approval_threshold' => (float) env('POS_DISCOUNT_THRESHOLD', 10.0),
        
        // Require pharmacist approval for prescription drugs
        'require_pharmacist_approval' => env('POS_REQUIRE_PHARMACIST', true),
    ],

    /*
    |--------------------------------------------------------------------------
    | Sync Configuration
    |--------------------------------------------------------------------------
    |
    | Settings for data synchronization with the central server.
    |
    */
    'sync' => [
        // Enable automatic sync
        'enabled' => env('POS_SYNC_ENABLED', true),
        
        // Sync interval in seconds
        'interval' => (int) env('POS_SYNC_INTERVAL', 300),
        
        // Sync on startup
        'sync_on_startup' => env('POS_SYNC_ON_STARTUP', true),
        
        // Sync on shutdown
        'sync_on_shutdown' => env('POS_SYNC_ON_SHUTDOWN', true),
        
        // Server URL for sync
        'server_url' => env('POS_SYNC_SERVER_URL', env('APP_URL')),
        
        // Retry attempts for failed sync
        'retry_attempts' => (int) env('POS_SYNC_RETRIES', 3),
    ],

    /*
    |--------------------------------------------------------------------------
    | Testing Configuration
    |--------------------------------------------------------------------------
    |
    | Settings for testing without actual hardware.
    |
    */
    'testing' => [
        'simulate_scanner' => env('POS_SIMULATE_SCANNER', false),
        'simulate_printer' => env('POS_SIMULATE_PRINTER', false),
        'simulate_drawer' => env('POS_SIMULATE_DRAWER', false),
    ],
];

