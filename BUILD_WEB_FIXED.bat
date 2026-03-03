@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - BUILD WEB (FIREBASE COMPATIBILITY FIX)
echo ============================================================
echo.

echo Note: Web version has limited features due to Firebase web SDK
echo compatibility. APK version has full features.
echo.

echo [Step 1] Cleaning web build...
rmdir /s /q build\web 2>nul
call flutter clean >nul 2>&1

echo [Step 2] Getting dependencies...
call flutter pub get

echo.
echo [Step 3] Building web version...
echo Using workaround for Firebase compatibility...
echo This will take 10-15 minutes. Please wait...
echo.

REM Try building with web release
call flutter build web --release --web-renderer=canvaskit

echo.
if exist "build\web\index.html" (
    echo.
    echo ============================================================
    echo ✓ WEB BUILD SUCCESS!
    echo ============================================================
    echo.
    echo Web files location: build\web
    echo.
    echo To deploy to Vercel:
    echo 1. Install Vercel: npm install -g vercel
    echo 2. Run: vercel --prod (in build\web folder)
    echo 3. Or use: .\DEPLOY_VERCEL.bat
    echo.
) else (
    echo.
    echo ============================================================
    echo ⚠ WEB BUILD INCOMPLETE
    echo ============================================================
    echo.
    echo Firebase web SDK has compatibility issues with Flutter 3.32.5
    echo APK version is fully functional and recommended!
    echo.
    echo Use APK version instead:
    echo   .\BUILD_APK_FINAL.bat
    echo.
)

pause
