@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - BUILD WEB VERSION FOR VERCEL
echo ============================================================
echo.

echo [Step 1] Cleaning previous builds...
rmdir /s /q build\web 2>nul
call flutter clean >nul 2>&1

echo [Step 2] Getting dependencies...
call flutter pub get

echo.
echo [Step 3] Building web version...
echo This may take 5-10 minutes...
echo.
call flutter build web --release

echo.
if exist "build\web\index.html" (
    echo ============================================================
    echo SUCCESS! WEB BUILD COMPLETE
    echo ============================================================
    echo.
    echo Web files location: build\web
    echo.
    echo To deploy to Vercel:
    echo 1. Install Vercel CLI: npm install -g vercel
    echo 2. Run: vercel --prod
    echo 3. Choose "build/web" as output directory
    echo.
    echo Or use the deploy script:
    echo   deploy_vercel.bat
    echo.
) else (
    echo ============================================================
    echo BUILD FAILED
    echo ============================================================
)

pause
