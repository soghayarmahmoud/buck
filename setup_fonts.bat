@echo off
REM Download and setup fonts for Flutter app
REM This script requires PowerShell and internet connection

echo ========================================
echo  Buck App - Font Setup Script
echo ========================================
echo.

REM Check if assets/fonts directory exists
if not exist "assets\fonts" (
    echo Creating assets/fonts directory...
    mkdir assets\fonts
) else (
    echo assets/fonts directory already exists
)

echo.
echo ========================================
echo  Important Instructions:
echo ========================================
echo.
echo Since TTF files are large binary files, they need to be downloaded manually.
echo.
echo Please download the following fonts from Google Fonts:
echo.
echo 1. Cairo (https://fonts.google.com/specimen/Cairo)
echo    - Download: Cairo-Regular.ttf, Cairo-Bold.ttf
echo    - Save to: assets\fonts\
echo.
echo 2. Tajawal (https://fonts.google.com/specimen/Tajawal)
echo    - Download: Tajawal-Regular.ttf, Tajawal-Bold.ttf
echo    - Save to: assets\fonts\
echo.
echo 3. Changa (https://fonts.google.com/specimen/Changa)
echo    - Download: Changa-Regular.ttf, Changa-Bold.ttf
echo    - Save to: assets\fonts\
echo.
echo 4. Droid Arabic Naskh (https://fonts.google.com/specimen/Droid+Arabic+Naskh)
echo    - Download: DroidArabicNaskh-Regular.ttf, DroidArabicNaskh-Bold.ttf
echo    - Save to: assets\fonts\
echo.
echo ========================================
echo  Next Steps:
echo ========================================
echo.
echo 1. Open https://fonts.google.com in your browser
echo 2. Search and download each font family
echo 3. Extract TTF files and place in assets/fonts/
echo 4. Run: flutter clean
echo 5. Run: flutter pub get
echo 6. Run: flutter build apk --release
echo.
echo Once you have placed the font files, the app will work perfectly
echo without requiring an internet connection!
echo.
pause
