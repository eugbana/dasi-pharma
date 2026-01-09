<?php

/**
 * NativePHP Configuration for Dasi Pharma POS Desktop Application.
 * 
 * This configuration defines the desktop application settings including
 * window properties, menu structure, and update mechanisms.
 */

return [
    /*
    |--------------------------------------------------------------------------
    | Application Identifier
    |--------------------------------------------------------------------------
    |
    | Unique identifier for the desktop application used by the OS.
    |
    */
    'app_id' => env('NATIVEPHP_APP_ID', 'com.dasipharma.pos'),

    /*
    |--------------------------------------------------------------------------
    | Application Version
    |--------------------------------------------------------------------------
    |
    | Current version of the desktop application.
    |
    */
    'version' => env('APP_VERSION', '1.0.0'),

    /*
    |--------------------------------------------------------------------------
    | Window Configuration
    |--------------------------------------------------------------------------
    |
    | Default window settings for the desktop application.
    |
    */
    'window' => [
        'width' => (int) env('NATIVEPHP_WINDOW_WIDTH', 1366),
        'height' => (int) env('NATIVEPHP_WINDOW_HEIGHT', 768),
        'min_width' => 1024,
        'min_height' => 600,
        'max_width' => null,
        'max_height' => null,
        'resizable' => true,
        'movable' => true,
        'minimizable' => true,
        'maximizable' => true,
        'closable' => true,
        'focusable' => true,
        'fullscreen' => false,
        'kiosk' => env('POS_KIOSK_MODE', false),
        'always_on_top' => false,
        'title' => 'Dasi Pharma POS',
        'show_title_bar' => true,
        'title_bar_style' => 'default', // default, hidden, hiddenInset
    ],

    /*
    |--------------------------------------------------------------------------
    | Application Menu
    |--------------------------------------------------------------------------
    |
    | Menu structure for the desktop application.
    |
    */
    'menu' => [
        'enabled' => true,
        'items' => [
            'file' => [
                'label' => 'File',
                'submenu' => [
                    ['label' => 'New Sale', 'accelerator' => 'CmdOrCtrl+N', 'action' => 'pos.new_sale'],
                    ['type' => 'separator'],
                    ['label' => 'Logout', 'accelerator' => 'CmdOrCtrl+L', 'action' => 'auth.logout'],
                    ['type' => 'separator'],
                    ['label' => 'Exit', 'accelerator' => 'CmdOrCtrl+Q', 'action' => 'app.quit'],
                ],
            ],
            'pos' => [
                'label' => 'POS',
                'submenu' => [
                    ['label' => 'Start Shift', 'action' => 'pos.start_shift'],
                    ['label' => 'End Shift', 'action' => 'pos.end_shift'],
                    ['type' => 'separator'],
                    ['label' => 'Open Cash Drawer', 'accelerator' => 'F8', 'action' => 'pos.open_drawer'],
                    ['label' => 'Reprint Last Receipt', 'accelerator' => 'F9', 'action' => 'pos.reprint'],
                    ['type' => 'separator'],
                    ['label' => 'Returns', 'accelerator' => 'F7', 'action' => 'pos.returns'],
                ],
            ],
            'reports' => [
                'label' => 'Reports',
                'submenu' => [
                    ['label' => 'Daily Sales', 'action' => 'reports.daily_sales'],
                    ['label' => 'Shift Report', 'action' => 'reports.shift'],
                    ['type' => 'separator'],
                    ['label' => 'Stock Levels', 'action' => 'reports.stock'],
                ],
            ],
            'help' => [
                'label' => 'Help',
                'submenu' => [
                    ['label' => 'About', 'action' => 'app.about'],
                    ['label' => 'Check for Updates', 'action' => 'app.check_updates'],
                    ['type' => 'separator'],
                    ['label' => 'Support', 'action' => 'app.support'],
                ],
            ],
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Auto-Update Configuration
    |--------------------------------------------------------------------------
    |
    | Settings for automatic application updates.
    | Supported drivers: 's3', 'spaces', 'github'
    |
    */
    'updater' => [
        'enabled' => env('NATIVEPHP_UPDATER_ENABLED', false),
        'default' => env('NATIVEPHP_UPDATER_PROVIDER', 'github'),
        'providers' => [
            'github' => [
                'driver' => 'github',
                'owner' => env('GITHUB_OWNER', ''),
                'repo' => env('GITHUB_REPO', ''),
                'token' => env('GITHUB_TOKEN', ''),
                'vPrefixedTagName' => true,
                'private' => false,
                'channel' => 'latest',
                'releaseType' => 'release',
            ],
            's3' => [
                'driver' => 's3',
                'bucket' => env('NATIVEPHP_UPDATER_BUCKET'),
                'region' => env('NATIVEPHP_UPDATER_REGION', 'us-east-1'),
                'key' => env('AWS_ACCESS_KEY_ID'),
                'secret' => env('AWS_SECRET_ACCESS_KEY'),
            ],
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Tray Configuration
    |--------------------------------------------------------------------------
    |
    | System tray icon and menu settings.
    |
    */
    'tray' => [
        'enabled' => true,
        'icon' => 'resources/icons/tray.png',
        'tooltip' => 'Dasi Pharma POS',
    ],

    /*
    |--------------------------------------------------------------------------
    | Deep Links
    |--------------------------------------------------------------------------
    |
    | URL scheme for deep linking into the application.
    |
    */
    'deep_links' => [
        'scheme' => 'dasipharma',
    ],
];

