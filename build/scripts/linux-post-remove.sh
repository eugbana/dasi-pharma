#!/bin/bash
# Dasi Pharma Linux Post-Removal Script
# This script runs after the .deb package is removed

set -e

echo "Running Dasi Pharma post-removal cleanup..."

# Remove symbolic link
if [ -L /usr/local/bin/dasipharma ]; then
    rm -f /usr/local/bin/dasipharma
fi

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database /usr/share/applications
fi

# Note: We don't remove user data by default
# Users can manually remove ~/.local/share/DasiPharma if needed

echo "Dasi Pharma has been removed."
echo "User data is preserved at ~/.local/share/DasiPharma"
echo "To completely remove all data, run: rm -rf ~/.local/share/DasiPharma"

