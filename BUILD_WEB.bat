@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - BUILD WEB VERSION FOR VERCEL DEPLOYMENT
echo ============================================================
echo.

echo [Step 1] Cleaning old builds...
call flutter clean >nul 2>&1

echo [Step 2] Getting dependencies...
call flutter pub get >nul 2>&1

echo.
echo [Step 3] Building web version (this takes 10-15 minutes)...
echo Please wait...
echo.
call flutter build web --release

echo.
echo ============================================================
if exist "build\web\index.html" (
    echo ✓ SUCCESS! WEB VERSION BUILT
    echo ============================================================
    echo.
    echo Web files location: build\web\
    echo.
    echo Next Steps for Vercel Deployment:
    echo.
    echo Option 1: Deploy via Command Line
    echo   1. Install Vercel CLI: npm install -g vercel
    echo   2. Run: vercel --prod
    echo.
    echo Option 2: Deploy via GitHub
    echo   1. Push to GitHub: git push
    echo   2. Go to Vercel Dashboard
    echo   3. Import from GitHub
    echo   4. Deploy
    echo.
    echo Your app will be live on a Vercel domain!
    echo.
) else (
    echo ✗ BUILD FAILED
    echo ============================================================
    echo Check error messages above.
    echo.
)

pause
