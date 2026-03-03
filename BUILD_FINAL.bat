@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - FINAL APK BUILD
echo ============================================================
echo.
echo All errors have been fixed. Building your app now...
echo.

REM Step 1: Deep clean
echo [Step 1/4] Cleaning build directories...
rmdir /s /q build 2>nul
rmdir /s /q .dart_tool 2>nul
call flutter clean >nul 2>&1

REM Step 2: Get dependencies
echo [Step 2/4] Downloading dependencies...
call flutter pub get

REM Step 3: Build APK
echo [Step 3/4] Building APK (this may take 10-15 minutes)...
echo Please be patient...
echo.
call flutter build apk --release

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================================
    echo SUCCESS! YOUR APK IS READY!
    echo ============================================================
    echo.
    echo APK Location:
    echo build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo Next steps:
    echo 1. Copy the APK file to your Android phone
    echo 2. Open the file and install it
    echo 3. Allow "Install from unknown sources" if prompted
    echo 4. Open SkillSwap and sign up!
    echo.
    echo Enjoy your app!
    echo ============================================================
    echo.
) else (
    echo.
    echo ============================================================
    echo BUILD FAILED
    echo ============================================================
    echo Please check the error messages above.
    echo.
)

pause
