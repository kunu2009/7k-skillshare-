@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - BUILD APK (CLEAN START)
echo ============================================================
echo.

REM Deep clean
echo [Step 1] Deep cleaning...
rmdir /s /q build 2>nul
rmdir /s /q .dart_tool 2>nul
call flutter clean >nul 2>&1
echo Clean complete!
echo.

REM Get dependencies
echo [Step 2] Getting dependencies...
call flutter pub get

REM Build APK
echo.
echo [Step 3] Building APK...
echo This will take 10-15 minutes. Please wait...
echo.
call flutter build apk --release

REM Check if successful
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo.
    echo ============================================================
    echo SUCCESS! APK CREATED
    echo ============================================================
    echo.
    echo APK Location:
    echo build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo APK Size: Check file properties
    echo.
    echo To install on your phone:
    echo 1. Connect Android phone to computer
    echo 2. Copy APK to phone
    echo 3. Open file and install
    echo 4. Or use: adb install build\app\outputs\flutter-apk\app-release.apk
    echo.
) else (
    echo.
    echo ============================================================
    echo BUILD FAILED - APK NOT CREATED
    echo ============================================================
    echo Check errors above
    echo.
)

pause
