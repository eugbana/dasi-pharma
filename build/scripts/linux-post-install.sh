#!/bin/bash
# Dasi Pharma Linux Post-Installation Script
# This script runs after the .deb package is installed

set -e

APP_NAME="dasipharma"
INSTALL_DIR="/opt/DasiPharma"
DATA_DIR="$HOME/.local/share/DasiPharma"
DESKTOP_FILE="/usr/share/applications/dasipharma.desktop"

echo "Running Dasi Pharma post-installation..."

# Create data directories
mkdir -p "$DATA_DIR"/{database,logs,backups,temp}

# Set proper permissions
chmod 755 "$DATA_DIR"
chmod 700 "$DATA_DIR/database"

# Create symbolic link for CLI access
if [ -f "$INSTALL_DIR/dasipharma" ]; then
    ln -sf "$INSTALL_DIR/dasipharma" /usr/local/bin/dasipharma
fi

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database /usr/share/applications
fi

# Update icon cache
if command -v gtk-update-icon-cache &> /dev/null; then
    gtk-update-icon-cache -f -t /usr/share/icons/hicolor
fi

# Register URL handler
if command -v xdg-mime &> /dev/null; then
    xdg-mime default dasipharma.desktop x-scheme-handler/dasipharma
fi

# Create initial environment file if it doesn't exist
ENV_FILE="$DATA_DIR/.env"
if [ ! -f "$ENV_FILE" ]; then
    cat > "$ENV_FILE" << EOF
APP_NAME="Dasi Pharma"
APP_ENV=production
APP_DEBUG=false
APP_URL=http://127.0.0.1:8100

DB_CONNECTION=sqlite
DB_DATABASE=$DATA_DIR/database/database.sqlite

LOG_CHANNEL=daily
LOG_LEVEL=warning

CACHE_DRIVER=file
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=480

NATIVEPHP_UPDATER_ENABLED=true
EOF
    chmod 600 "$ENV_FILE"
fi

echo "Dasi Pharma installation complete!"
echo "You can start the application from your application menu or by running 'dasipharma'"

