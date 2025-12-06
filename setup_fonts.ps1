# Flutter App Font Setup Script
# This script helps you set up fonts for the Buck app

param(
    [switch]$Download,
    [switch]$Verify,
    [switch]$Help
)

function Show-Help {
    Write-Host @"
========================================
     Buck App - Font Setup Helper
========================================

This script helps you set up the required fonts.

Usage:
  .\setup_fonts.ps1 -Verify    # Check if fonts are installed
  .\setup_fonts.ps1 -Help      # Show this help

Required Fonts:
  1. Cairo
  2. Tajawal  
  3. Changa
  4. Droid Arabic Naskh

Each font needs Regular and Bold versions.

How to download:
  1. Go to https://fonts.google.com
  2. Search for each font by name
  3. Download the font family
  4. Extract TTF files
  5. Place in assets/fonts/ directory

File Structure Expected:
  assets/fonts/
  ├── Cairo-Regular.ttf
  ├── Cairo-Bold.ttf
  ├── Tajawal-Regular.ttf
  ├── Tajawal-Bold.ttf
  ├── Changa-Regular.ttf
  ├── Changa-Bold.ttf
  ├── DroidArabicNaskh-Regular.ttf
  └── DroidArabicNaskh-Bold.ttf

Next Steps:
  1. Run: flutter clean
  2. Run: flutter pub get
  3. Run: flutter build apk --release

========================================
"@
}

function Verify-Fonts {
    Write-Host "`n========================================`n" -ForegroundColor Cyan
    Write-Host "Checking Font Installation..." -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan

    $requiredFonts = @(
        "Cairo-Regular.ttf",
        "Cairo-Bold.ttf",
        "Tajawal-Regular.ttf",
        "Tajawal-Bold.ttf",
        "Changa-Regular.ttf",
        "Changa-Bold.ttf",
        "DroidArabicNaskh-Regular.ttf",
        "DroidArabicNaskh-Bold.ttf"
    )

    $fontsPath = ".\assets\fonts"
    $missingFonts = @()
    $foundFonts = @()

    foreach ($font in $requiredFonts) {
        $fontPath = Join-Path $fontsPath $font
        if (Test-Path $fontPath) {
            $fileSize = (Get-Item $fontPath).Length / 1MB
            Write-Host "✓ $font" -ForegroundColor Green
            $foundFonts += $font
        } else {
            Write-Host "✗ $font" -ForegroundColor Red
            $missingFonts += $font
        }
    }

    Write-Host "`n========================================`n" -ForegroundColor Cyan
    Write-Host "Summary:" -ForegroundColor Cyan
    Write-Host "Found: $($foundFonts.Count) / 8 fonts" -ForegroundColor Yellow
    
    if ($missingFonts.Count -eq 0) {
        Write-Host "`n✓ All fonts are installed! You can proceed with building the app." -ForegroundColor Green
        Write-Host "`nNext steps:`n" -ForegroundColor Cyan
        Write-Host "  1. flutter clean" -ForegroundColor White
        Write-Host "  2. flutter pub get" -ForegroundColor White
        Write-Host "  3. flutter build apk --release`n" -ForegroundColor White
    } else {
        Write-Host "`n✗ Missing $($missingFonts.Count) fonts:`n" -ForegroundColor Red
        foreach ($font in $missingFonts) {
            Write-Host "  - $font" -ForegroundColor Yellow
        }
        Write-Host "`nPlease download these fonts from Google Fonts:" -ForegroundColor Cyan
        Write-Host "  https://fonts.google.com`n" -ForegroundColor White
    }
}

# Main script
if ($Help) {
    Show-Help
}
elseif ($Verify) {
    Verify-Fonts
}
else {
    Write-Host "`nFlutter App Font Setup Tool`n" -ForegroundColor Cyan
    Write-Host "Usage: .\setup_fonts.ps1 -Verify`n" -ForegroundColor Yellow
    Show-Help
}
