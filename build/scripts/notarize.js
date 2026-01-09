/**
 * Dasi Pharma macOS Notarization Script
 * 
 * This script is called by electron-builder after signing to notarize
 * the macOS application with Apple's notarization service.
 */

const { notarize } = require('@electron/notarize');
const path = require('path');

exports.default = async function notarizing(context) {
    const { electronPlatformName, appOutDir } = context;
    
    // Only notarize macOS builds
    if (electronPlatformName !== 'darwin') {
        console.log('Skipping notarization: not a macOS build');
        return;
    }

    // Check for required environment variables
    const appleId = process.env.APPLE_ID;
    const appleIdPassword = process.env.APPLE_ID_PASSWORD;
    const teamId = process.env.APPLE_TEAM_ID;

    if (!appleId || !appleIdPassword || !teamId) {
        console.log('Skipping notarization: Apple credentials not configured');
        console.log('Set APPLE_ID, APPLE_ID_PASSWORD, and APPLE_TEAM_ID environment variables');
        return;
    }

    const appName = context.packager.appInfo.productFilename;
    const appPath = path.join(appOutDir, `${appName}.app`);

    console.log(`Notarizing ${appPath}...`);
    console.log('This may take several minutes...');

    try {
        await notarize({
            appBundleId: 'ng.dasipharma.pos',
            appPath: appPath,
            appleId: appleId,
            appleIdPassword: appleIdPassword,
            teamId: teamId,
        });

        console.log('Notarization complete!');
    } catch (error) {
        console.error('Notarization failed:', error.message);
        // Don't fail the build, just warn
        console.warn('Continuing without notarization...');
    }
};

