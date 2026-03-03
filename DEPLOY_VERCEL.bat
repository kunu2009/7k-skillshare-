@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo DEPLOY TO VERCEL
echo ============================================================
echo.

REM Check if Vercel CLI is installed
where vercel >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Vercel CLI not found. Installing...
    call npm install -g vercel
)

echo.
echo Deploying to Vercel...
echo.
call vercel --prod

echo.
echo ============================================================
echo DEPLOYMENT COMPLETE
echo ============================================================
echo.
echo Your app is now live on Vercel!
echo.

pause
