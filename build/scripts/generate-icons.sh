#!/bin/bash
# Generate all required icons for Dasi Pharma desktop application
# This script requires a source PNG file at 1024x1024 resolution

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_DIR="$(dirname "$SCRIPT_DIR")/resources"
SOURCE_PNG="${1:-$RESOURCES_DIR/icon-source.png}"

if [ ! -f "$SOURCE_PNG" ]; then
    echo "Error: Source PNG not found at $SOURCE_PNG"
    echo "Usage: $0 [path-to-1024x1024-png]"
    echo ""
    echo "Please provide a 1024x1024 PNG file as the source icon."
    echo "You can convert the SVG at build/resources/icon.svg using:"
    echo "  - Online: svgtopng.com, cloudconvert.com"
    echo "  - Inkscape: inkscape icon.svg -o icon-source.png -w 1024 -h 1024"
    echo "  - GIMP: Open SVG > Export as PNG at 1024x1024"
    exit 1
fi

echo "Generating icons from: $SOURCE_PNG"
echo "Output directory: $RESOURCES_DIR"

# Create icons directory for Linux
mkdir -p "$RESOURCES_DIR/icons"

# Generate Linux PNGs
echo "Generating Linux PNG icons..."
for size in 16 32 48 64 128 256 512; do
    sips -z $size $size "$SOURCE_PNG" --out "$RESOURCES_DIR/icons/${size}x${size}.png" 2>/dev/null
    echo "  Created ${size}x${size}.png"
done

# Generate macOS ICNS
echo "Generating macOS ICNS..."
ICONSET_DIR="$RESOURCES_DIR/icon.iconset"
mkdir -p "$ICONSET_DIR"

sips -z 16 16 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_16x16.png" 2>/dev/null
sips -z 32 32 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_16x16@2x.png" 2>/dev/null
sips -z 32 32 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_32x32.png" 2>/dev/null
sips -z 64 64 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_32x32@2x.png" 2>/dev/null
sips -z 128 128 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_128x128.png" 2>/dev/null
sips -z 256 256 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_128x128@2x.png" 2>/dev/null
sips -z 256 256 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_256x256.png" 2>/dev/null
sips -z 512 512 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_256x256@2x.png" 2>/dev/null
sips -z 512 512 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_512x512.png" 2>/dev/null
sips -z 1024 1024 "$SOURCE_PNG" --out "$ICONSET_DIR/icon_512x512@2x.png" 2>/dev/null

iconutil -c icns "$ICONSET_DIR" -o "$RESOURCES_DIR/icon.icns"
rm -rf "$ICONSET_DIR"
echo "  Created icon.icns"

# For Windows ICO, we need ImageMagick or a different approach
echo ""
echo "Note: Windows ICO generation requires ImageMagick."
echo "If ImageMagick is installed, run:"
echo "  convert $SOURCE_PNG -define icon:auto-resize=256,128,64,48,32,16 $RESOURCES_DIR/icon.ico"
echo ""
echo "Alternatively, use an online converter:"
echo "  - https://icoconvert.com"
echo "  - https://convertico.com"
echo ""

# Check if ImageMagick is available
if command -v convert &> /dev/null; then
    echo "ImageMagick found, generating Windows ICO files..."
    convert "$SOURCE_PNG" -define icon:auto-resize=256,128,64,48,32,16 "$RESOURCES_DIR/icon.ico"
    convert "$SOURCE_PNG" -define icon:auto-resize=256,128,64,48,32,16 "$RESOURCES_DIR/installer.ico"
    convert "$SOURCE_PNG" -define icon:auto-resize=256,128,64,48,32,16 "$RESOURCES_DIR/uninstaller.ico"
    convert "$SOURCE_PNG" -define icon:auto-resize=256,128,64,48,32,16 "$RESOURCES_DIR/header.ico"
    echo "  Created icon.ico, installer.ico, uninstaller.ico, header.ico"
    
    # Create sidebar BMPs
    convert "$SOURCE_PNG" -resize 164x314 -background white -gravity center -extent 164x314 "$RESOURCES_DIR/installerSidebar.bmp"
    convert "$SOURCE_PNG" -resize 164x314 -background white -gravity center -extent 164x314 "$RESOURCES_DIR/uninstallerSidebar.bmp"
    echo "  Created installer sidebar BMPs"
fi

echo ""
echo "Icon generation complete!"
echo "Files created in: $RESOURCES_DIR"
ls -la "$RESOURCES_DIR"

