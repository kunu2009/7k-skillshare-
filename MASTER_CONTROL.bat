@echo off
setlocal enabledelayedexpansion

:menu
cls
echo.
echo ============================================================
echo     SKILLSWAP - MASTER CONTROL PANEL
echo ============================================================
echo.
echo Choose what to do:
echo.
echo   1) Build Android APK
echo   2) Build Web Version
echo   3) Deploy to Vercel
echo   4) Commit and Push to GitHub
echo   5) View Documentation
echo   6) Run All (APK + Web + Deploy + Push)
echo   7) Exit
echo.
echo ============================================================
echo.

set /p choice="Enter choice (1-7): "

if "%choice%"=="1" goto build_apk
if "%choice%"=="2" goto build_web
if "%choice%"=="3" goto deploy_vercel
if "%choice%"=="4" goto commit_push
if "%choice%"=="5" goto view_docs
if "%choice%"=="6" goto run_all
if "%choice%"=="7" exit /b
goto menu

:build_apk
cls
echo.
echo Building Android APK...
call BUILD_APK_NOW.bat
goto menu

:build_web
cls
echo.
echo Building Web Version...
call BUILD_WEB.bat
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
echo Committing and Pushing...
call COMMIT_PUSH.bat
goto menu

:view_docs
cls
echo.
echo Opening documentation...
start README_FINAL.md
start DEPLOYMENT_GUIDE.md
goto menu

:run_all
cls
echo.
echo ============================================================
echo   RUNNING COMPLETE DEPLOYMENT PIPELINE
echo ============================================================
echo.

echo Step 1: Building APK...
call BUILD_APK_NOW.bat

echo.
echo Step 2: Building Web...
call BUILD_WEB.bat

echo.
echo Step 3: Committing to GitHub...
call COMMIT_PUSH.bat

echo.
echo Step 4: Ready to Deploy to Vercel...
echo   Run: DEPLOY_VERCEL.bat
echo.
echo ============================================================
echo   DEPLOYMENT COMPLETE!
echo ============================================================
echo.
pause
goto menu
