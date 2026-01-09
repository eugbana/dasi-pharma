#!/usr/bin/env node

/**
 * Dasi Pharma Desktop Application Build Script
 * 
 * This script automates the build process for creating desktop installers
 * for Windows, macOS, and Linux platforms.
 * 
 * Usage:
 *   node build.js              # Build for current platform
 *   node build.js --win        # Build for Windows
 *   node build.js --mac        # Build for macOS
 *   node build.js --linux      # Build for Linux
 *   node build.js --all        # Build for all platforms
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Configuration
const PLATFORM = process.platform;
const ARGS = process.argv.slice(2);
const VERSION = require('./package.json').version || '1.0.0';

// Colors for console output
const colors = {
    reset: '\x1b[0m',
    green: '\x1b[32m',
    yellow: '\x1b[33m',
    red: '\x1b[31m',
    cyan: '\x1b[36m',
};

function log(message, color = 'reset') {
    console.log(`${colors[color]}${message}${colors.reset}`);
}

function logStep(step, message) {
    log(`\n[${step}] ${message}`, 'cyan');
}

function logSuccess(message) {
    log(`✓ ${message}`, 'green');
}

function logError(message) {
    log(`✗ ${message}`, 'red');
}

function exec(command, options = {}) {
    try {
        execSync(command, { stdio: 'inherit', ...options });
        return true;
    } catch (error) {
        logError(`Command failed: ${command}`);
        return false;
    }
}

// Determine which platforms to build for
function getTargetPlatforms() {
    if (ARGS.includes('--all')) {
        return ['win', 'mac', 'linux'];
    }
    if (ARGS.includes('--win')) return ['win'];
    if (ARGS.includes('--mac')) return ['mac'];
    if (ARGS.includes('--linux')) return ['linux'];
    
    // Default to current platform
    switch (PLATFORM) {
        case 'win32': return ['win'];
        case 'darwin': return ['mac'];
        case 'linux': return ['linux'];
        default: return ['win'];
    }
}

async function build() {
    log('\n╔════════════════════════════════════════════════════╗', 'cyan');
    log('║     Dasi Pharma Desktop Build System               ║', 'cyan');
    log(`║     Version: ${VERSION.padEnd(39)}║`, 'cyan');
    log('╚════════════════════════════════════════════════════╝', 'cyan');

    const platforms = getTargetPlatforms();
    log(`\nTarget platforms: ${platforms.join(', ')}\n`);

    // Step 1: Clean previous builds
    logStep('1/7', 'Cleaning previous builds...');
    if (fs.existsSync('dist')) {
        fs.rmSync('dist', { recursive: true });
    }
    logSuccess('Clean complete');

    // Step 2: Install Composer dependencies (production)
    logStep('2/7', 'Installing PHP dependencies...');
    if (!exec('composer install --no-dev --optimize-autoloader')) {
        throw new Error('Composer install failed');
    }
    logSuccess('PHP dependencies installed');

    // Step 3: Install NPM dependencies
    logStep('3/7', 'Installing Node.js dependencies...');
    if (!exec('npm ci')) {
        throw new Error('NPM install failed');
    }
    logSuccess('Node.js dependencies installed');

    // Step 4: Build frontend assets
    logStep('4/7', 'Building frontend assets...');
    if (!exec('npm run build')) {
        throw new Error('Frontend build failed');
    }
    logSuccess('Frontend assets built');

    // Step 5: Optimize Laravel for production
    logStep('5/7', 'Optimizing Laravel...');
    exec('php artisan config:clear');
    exec('php artisan route:clear');
    exec('php artisan view:clear');
    exec('php artisan config:cache');
    exec('php artisan route:cache');
    exec('php artisan view:cache');
    logSuccess('Laravel optimized');

    // Step 6: Build native application
    logStep('6/7', 'Building native application...');
    for (const platform of platforms) {
        log(`\n  Building for ${platform}...`, 'yellow');
        // NativePHP uses positional arguments: native:build <os> [<arch>]
        const buildCommand = `php artisan native:build ${platform} x64 --no-interaction`;
        if (!exec(buildCommand)) {
            logError(`Failed to build for ${platform}`);
            continue;
        }
        logSuccess(`${platform} build complete`);
    }

    // Step 7: Sign applications (if certificates available)
    logStep('7/7', 'Signing applications...');
    if (process.env.CERT_PATH || process.env.APPLE_ID) {
        await signApplications(platforms);
    } else {
        log('  Skipping signing (no certificates configured)', 'yellow');
    }

    // Summary
    log('\n╔════════════════════════════════════════════════════╗', 'green');
    log('║           Build Complete!                          ║', 'green');
    log('╚════════════════════════════════════════════════════╝', 'green');
    
    if (fs.existsSync('dist')) {
        log('\nGenerated installers:', 'cyan');
        const files = fs.readdirSync('dist');
        files.forEach(file => {
            const filePath = path.join('dist', file);
            const stats = fs.statSync(filePath);
            const sizeMB = (stats.size / (1024 * 1024)).toFixed(2);
            log(`  • ${file} (${sizeMB} MB)`);
        });
    }
}

async function signApplications(platforms) {
    // Windows signing
    if (platforms.includes('win') && process.env.CERT_PATH) {
        log('  Signing Windows executables...', 'yellow');
        const distFiles = fs.readdirSync('dist').filter(f => 
            f.endsWith('.exe') || f.endsWith('.msi')
        );
        for (const file of distFiles) {
            exec(`powershell -File build/scripts/sign-windows.ps1 -FilePath "dist/${file}"`);
        }
    }
    
    // macOS notarization handled by afterSign hook in electron-builder
}

// Run the build
build().catch(error => {
    logError(`Build failed: ${error.message}`);
    process.exit(1);
});

