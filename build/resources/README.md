# Dasi Pharma Build Resources

This directory contains the icons and images required for building desktop installers.

## Required Files

### Windows
- `icon.ico` - Main application icon (256x256, multi-resolution ICO)
- `installer.ico` - Installer icon
- `uninstaller.ico` - Uninstaller icon
- `header.ico` - Installer header icon
- `installerSidebar.bmp` - Installer sidebar image (164x314 pixels)
- `uninstallerSidebar.bmp` - Uninstaller sidebar image (164x314 pixels)

### macOS
- `icon.icns` - macOS application icon (1024x1024, ICNS format)

### Linux
- `icons/` - Directory containing PNG icons at various sizes:
  - `16x16.png`
  - `32x32.png`
  - `48x48.png`
  - `64x64.png`
  - `128x128.png`
  - `256x256.png`
  - `512x512.png`

## Creating Icons

### From a source PNG (1024x1024 recommended):

**Windows ICO:**
```bash
# Using ImageMagick
convert icon.png -define icon:auto-resize=256,128,64,48,32,16 icon.ico
```

**macOS ICNS:**
```bash
# Using iconutil (macOS only)
mkdir icon.iconset
sips -z 16 16 icon.png --out icon.iconset/icon_16x16.png
sips -z 32 32 icon.png --out icon.iconset/icon_16x16@2x.png
sips -z 32 32 icon.png --out icon.iconset/icon_32x32.png
sips -z 64 64 icon.png --out icon.iconset/icon_32x32@2x.png
sips -z 128 128 icon.png --out icon.iconset/icon_128x128.png
sips -z 256 256 icon.png --out icon.iconset/icon_128x128@2x.png
sips -z 256 256 icon.png --out icon.iconset/icon_256x256.png
sips -z 512 512 icon.png --out icon.iconset/icon_256x256@2x.png
sips -z 512 512 icon.png --out icon.iconset/icon_512x512.png
sips -z 1024 1024 icon.png --out icon.iconset/icon_512x512@2x.png
iconutil -c icns icon.iconset
```

**Linux PNGs:**
```bash
mkdir -p icons
for size in 16 32 48 64 128 256 512; do
    sips -z $size $size icon.png --out icons/${size}x${size}.png
done
```

## Notes

- All icons should use the Dasi Pharma brand colors
- Icons should be clear and recognizable at small sizes
- Include transparency where appropriate

