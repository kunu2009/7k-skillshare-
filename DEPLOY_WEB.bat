@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - COMPLETE WEB DEPLOYMENT SUITE
echo ============================================================
echo.

echo Choose an option:
echo.
echo [1] BUILD web version only
echo [2] BUILD + DEPLOY to Vercel
echo [3] DEPLOY existing build
echo [4] CHECK Vercel status
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto BUILD
if "%choice%"=="2" goto BUILD_DEPLOY
if "%choice%"=="3" goto DEPLOY
if "%choice%"=="4" goto STATUS
goto END

:BUILD
echo.
echo ============================================================
echo BUILDING WEB VERSION
echo ============================================================
echo.
call flutter clean
call flutter pub get
echo.
echo Building... This takes 10-15 minutes
echo.
call flutter build web --release
if exist "build\web\index.html" (
    echo.
    echo ✓ Web build successful!
    echo Location: build\web\
) else (
    echo ✗ Build failed!
)
goto END

:BUILD_DEPLOY
echo.
echo ============================================================
echo BUILDING & DEPLOYING TO VERCEL
echo ============================================================
echo.

echo [Step 1] Building web version...
call flutter clean
call flutter pub get
call flutter build web --release

if not exist "build\web\index.html" (
    echo ✗ Build failed!
    goto END
)

echo ✓ Build successful!
echo.

echo [Step 2] Checking Vercel CLI...
vercel --version >nul 2>&1
if errorlevel 1 (
    echo ✗ Vercel CLI not installed!
    echo Install with: npm install -g vercel
    goto END
)
echo ✓ Vercel CLI ready!
echo.

echo [Step 3] Deploying to Vercel...
echo.
vercel --prod

echo.
echo ============================================================
echo ✓ DEPLOYMENT COMPLETE!
echo ============================================================
echo Your app is now live on Vercel!
echo.
goto END

:DEPLOY
echo.
echo ============================================================
echo DEPLOYING TO VERCEL
echo ============================================================
echo.

echo Checking Vercel CLI...
vercel --version >nul 2>&1
if errorlevel 1 (
    echo ✗ Vercel CLI not installed!
    echo Install with: npm install -g vercel
    goto END
)

echo ✓ Vercel CLI ready!
echo.
echo Deploying...
vercel --prod

echo.
echo ============================================================
echo ✓ DEPLOYMENT COMPLETE!
echo ============================================================
echo.
goto END

:STATUS
echo.
echo ============================================================
echo CHECKING DEPLOYMENT STATUS
echo ============================================================
echo.

vercel --version >nul 2>&1
if errorlevel 1 (
    echo ✗ Vercel CLI not installed!
    echo Install with: npm install -g vercel
) else (
    echo ✓ Vercel CLI installed
    echo.
    echo Checking web build...
    if exist "build\web\index.html" (
        echo ✓ Web build exists
        echo Location: build\web\
    ) else (
        echo ✗ Web build not found
        echo Run option [1] to build
    )
)
echo.
goto END

:END
echo.
pause
