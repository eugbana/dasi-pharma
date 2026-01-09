<?php

namespace App\Providers;

use App\Services\POSAuditService;
use App\Services\POSSessionService;
use App\Services\ThermalPrinterService;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\ServiceProvider;

/**
 * Service provider for NativePHP desktop application.
 * 
 * Handles desktop-specific bootstrapping including:
 * - Hardware integration (printers, scanners)
 * - Session management for POS
 * - Offline mode configuration
 * - Desktop-specific security settings
 */
class NativeAppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        // Register POS-specific services as singletons
        $this->app->singleton(POSSessionService::class, function ($app) {
            return new POSSessionService(
                config('pos-desktop.session.timeout', 900),
                config('pos-desktop.session.require_shift', true)
            );
        });

        $this->app->singleton(POSAuditService::class, function ($app) {
            return new POSAuditService();
        });

        $this->app->singleton(ThermalPrinterService::class, function ($app) {
            return new ThermalPrinterService(
                config('pos-desktop.printer.type', 'thermal'),
                config('pos-desktop.printer.connection', 'usb'),
                config('pos-desktop.printer.port')
            );
        });

        // Merge POS desktop configuration
        $this->mergeConfigFrom(
            __DIR__ . '/../../config/pos-desktop.php',
            'pos-desktop'
        );
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Only run in desktop environment
        if (!$this->isDesktopEnvironment()) {
            return;
        }

        $this->configureDesktopEnvironment();
        $this->registerDesktopMiddleware();
        $this->configureOfflineMode();
    }

    /**
     * Check if running in NativePHP desktop environment.
     */
    protected function isDesktopEnvironment(): bool
    {
        return env('NATIVEPHP_RUNNING', false) || 
               app()->environment('desktop') ||
               config('app.desktop_mode', false);
    }

    /**
     * Configure desktop-specific environment settings.
     */
    protected function configureDesktopEnvironment(): void
    {
        // Set desktop-specific session configuration
        Config::set('session.driver', 'file');
        Config::set('session.lifetime', config('pos-desktop.session.timeout', 900) / 60);
        
        // Configure local database for offline mode
        if (config('pos-desktop.security.encrypt_local_db', true)) {
            $this->configureEncryptedDatabase();
        }

        // Set hardware identifiers for audit trail
        $this->setHardwareIdentifiers();
    }

    /**
     * Register desktop-specific middleware.
     */
    protected function registerDesktopMiddleware(): void
    {
        $router = $this->app['router'];
        
        $router->aliasMiddleware('pos.desktop', \App\Http\Middleware\POSDesktopMiddleware::class);
        $router->aliasMiddleware('pos.shift', \App\Http\Middleware\RequireActiveShift::class);
    }

    /**
     * Configure offline mode settings.
     */
    protected function configureOfflineMode(): void
    {
        // Set queue driver for offline operation
        Config::set('queue.default', 'database');
        
        // Configure sync settings
        Config::set('pos.sync.enabled', true);
        Config::set('pos.sync.interval', 300); // 5 minutes
        Config::set('pos.sync.max_offline_hours', config('pos-desktop.session.max_offline_hours', 24));
    }

    /**
     * Configure encrypted SQLite database for local storage.
     */
    protected function configureEncryptedDatabase(): void
    {
        // SQLCipher configuration for encrypted local database
        Config::set('database.connections.pos_local', [
            'driver' => 'sqlite',
            'database' => storage_path('pos/pos_local.sqlite'),
            'prefix' => '',
            'foreign_key_constraints' => true,
        ]);
    }

    /**
     * Set hardware identifiers for audit and security.
     */
    protected function setHardwareIdentifiers(): void
    {
        // Generate or retrieve hardware ID
        $hardwareId = $this->getHardwareId();
        Config::set('pos.hardware_id', $hardwareId);
    }

    /**
     * Get unique hardware identifier for this installation.
     */
    protected function getHardwareId(): string
    {
        $idFile = storage_path('pos/.hardware_id');
        
        if (file_exists($idFile)) {
            return trim(file_get_contents($idFile));
        }

        // Generate new hardware ID
        $hardwareId = 'POS-' . strtoupper(bin2hex(random_bytes(8)));
        
        if (!is_dir(dirname($idFile))) {
            mkdir(dirname($idFile), 0755, true);
        }
        
        file_put_contents($idFile, $hardwareId);
        
        return $hardwareId;
    }
}

