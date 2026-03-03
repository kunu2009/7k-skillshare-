@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - COMPLETE FIX & DEPLOYMENT
echo ============================================================
echo.

REM Step 1: Add web support
echo [Step 1] Adding web support for Chrome...
call flutter create . --platforms=web >nul 2>&1
echo Web support added!
echo.

REM Step 2: Clean and rebuild
echo [Step 2] Cleaning and rebuilding APK...
call flutter clean >nul
call flutter pub get >nul
echo.

echo [Step 3] Building APK with fixes...
call flutter build apk --release
echo.

REM Check if build succeeded
if %ERRORLEVEL% EQU 0 (
    echo APK built successfully!
    echo.

    REM Step 4: Commit and push
    echo [Step 4] Committing and pushing to GitHub...
    git add .
    git commit -m "Fix: Black screen issue - Add Firebase error handling and web support"
    git push -u origin main
    echo.

    echo ============================================================
    echo SUCCESS! APK BUILT & CODE PUSHED
    echo ============================================================
    echo.
    echo Your APK is ready:
    echo build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo Next steps:
    echo 1. Install APK on your Android phone
    echo 2. Or run: flutter run -d chrome (for web version)
    echo 3. Sign up and test the app!
    echo.
) else (
    echo Build failed. Check errors above.
)

pause
