@echo off
REM ============================================================
REM SKILLSWAP - COMPLETE FIX FOR DEPLOYMENT
REM ============================================================

echo.
echo ============================================================
echo STEP 1: Updating Dependencies...
echo ============================================================
call flutter clean
call flutter pub get --upgrade

echo.
echo ============================================================
echo STEP 2: Building Web Version with Fixed Dependencies...
echo ============================================================
call flutter build web --release

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Web build failed!
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo STEP 3: Committing Changes to GitHub...
echo ============================================================
git add .
git commit -m "Fix Firebase dependencies and Vercel configuration for web deployment"
git push origin main

echo.
echo ============================================================
echo STEP 4: Deploying to Vercel...
echo ============================================================
call vercel --prod

echo.
echo ============================================================
echo SUCCESS! YOUR APP IS LIVE!
echo ============================================================
echo.
echo Your app is now deployed to Vercel!
echo Check the URL shown above to access your app.
echo.
pause
