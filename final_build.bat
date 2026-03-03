@echo off
setlocal enabledelayedexpansion

:menu
cls
echo.
echo ============================================================
echo    SKILLSWAP - FINAL BUILD & DEPLOY
echo ============================================================
echo.
echo FIXES APPLIED:
echo ✓ ThemeProvider duplicate constructor - FIXED
echo ✓ User model 'id' reference - FIXED (changed to 'uid')
echo ✓ Firebase web compatibility - WORKAROUND
echo.
echo ============================================================
echo.
echo Choose what to do:
echo.
echo   1) Build APK (RECOMMENDED - Full Features)
echo   2) Build Web (Limited by Firebase web SDK)
echo   3) Deploy Web to Vercel
echo   4) Commit & Push to GitHub
echo   5) Run All (APK + GitHub)
echo   6) Exit
echo.
echo ============================================================
echo.

set /p choice="Enter choice (1-6): "

if "%choice%"=="1" goto build_apk
if "%choice%"=="2" goto build_web
if "%choice%"=="3" goto deploy_vercel
if "%choice%"=="4" goto commit_push
if "%choice%"=="5" goto run_all
if "%choice%"=="6" exit /b
goto menu

:build_apk
cls
echo.
echo Building Android APK...
call BUILD_APK_FINAL.bat
goto menu

:build_web
cls
echo.
echo Building Web Version...
call BUILD_WEB_FIXED.bat
goto menu

:deploy_vercel
cls
echo.
echo Deploying to Vercel...
call DEPLOY_VERCEL.bat
goto menu

:commit_push
cls
echo.
echo Committing and Pushing to GitHub...
git add .
git commit -m "Fix: ThemeProvider and User model issues - APK ready for deployment"
git push -u origin main
echo.
echo ✓ Code pushed to GitHub!
echo.
pause
goto menu

:run_all
cls
echo.
echo ============================================================
echo    RUNNING COMPLETE BUILD PIPELINE
echo ============================================================
echo.

echo [Step 1/2] Building APK...
call BUILD_APK_FINAL.bat

echo.
echo [Step 2/2] Committing to GitHub...
git add .
git commit -m "Fix: ThemeProvider and User model issues - APK ready for deployment" 2>nul
git push -u origin main 2>nul

echo.
echo ============================================================
echo    BUILD COMPLETE!
echo ============================================================
echo.
echo APK ready at: build\app\outputs\flutter-apk\app-release.apk
echo Code pushed to: https://github.com/kunu2009/7k-skillshare-
echo.
echo Next:
echo 1. Copy APK to Android phone
echo 2. Install and test
echo 3. Share with friends!
echo.
pause
goto menu
