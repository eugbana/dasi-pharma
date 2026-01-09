# Dasi Pharma Windows Code Signing Script
# Signs Windows executables and MSI installers with a code signing certificate

param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath,
    
    [Parameter(Mandatory=$false)]
    [string]$CertificatePath = $env:CERT_PATH,
    
    [Parameter(Mandatory=$false)]
    [string]$CertificatePassword = $env:CERT_PASSWORD,
    
    [Parameter(Mandatory=$false)]
    [string]$TimestampServer = "http://timestamp.digicert.com"
)

# Verify signtool exists
$signtool = Get-Command signtool -ErrorAction SilentlyContinue
if (-not $signtool) {
    # Try to find signtool in Windows SDK
    $sdkPaths = @(
        "${env:ProgramFiles(x86)}\Windows Kits\10\bin\*\x64\signtool.exe",
        "${env:ProgramFiles}\Windows Kits\10\bin\*\x64\signtool.exe"
    )
    
    foreach ($path in $sdkPaths) {
        $found = Get-ChildItem $path -ErrorAction SilentlyContinue | Sort-Object -Descending | Select-Object -First 1
        if ($found) {
            $signtool = $found.FullName
            break
        }
    }
    
    if (-not $signtool) {
        Write-Error "signtool.exe not found. Please install Windows SDK."
        exit 1
    }
}

# Verify certificate exists
if (-not (Test-Path $CertificatePath)) {
    Write-Error "Certificate not found at: $CertificatePath"
    exit 1
}

# Verify file exists
if (-not (Test-Path $FilePath)) {
    Write-Error "File not found: $FilePath"
    exit 1
}

Write-Host "Signing: $FilePath" -ForegroundColor Cyan
Write-Host "Certificate: $CertificatePath" -ForegroundColor Gray

# Build signtool arguments
$args = @(
    "sign",
    "/f", $CertificatePath,
    "/p", $CertificatePassword,
    "/tr", $TimestampServer,
    "/td", "sha256",
    "/fd", "sha256",
    "/d", "Dasi Pharma Management System",
    "/du", "https://dasipharma.ng",
    $FilePath
)

# Execute signing
try {
    & $signtool $args
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully signed: $FilePath" -ForegroundColor Green
        
        # Verify the signature
        Write-Host "Verifying signature..." -ForegroundColor Gray
        & $signtool verify /pa $FilePath
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Signature verified successfully" -ForegroundColor Green
        } else {
            Write-Warning "Signature verification failed"
        }
    } else {
        Write-Error "Signing failed with exit code: $LASTEXITCODE"
        exit 1
    }
} catch {
    Write-Error "Signing error: $_"
    exit 1
}

