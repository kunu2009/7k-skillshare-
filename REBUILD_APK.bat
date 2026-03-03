@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - REBUILD APK (ERRORS FIXED)
echo ============================================================
echo.

echo Errors fixed:
echo - ThemeProvider duplicate constructor
echo - User model 'id' changed to 'uid'
echo.

echo [Step 1] Cleaning...
call flutter clean >nul 2>&1

echo [Step 2] Getting dependencies...
call flutter pub get

echo [Step 3] Building APK...
echo This will take 10-15 minutes. Please wait...
echo.
call flutter build apk --release

echo.
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo.
    echo ============================================================
    echo SUCCESS! APK BUILT SUCCESSFULLY
    echo ============================================================
    echo.
    echo APK Location:
    echo build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo Next steps:
    echo 1. Copy APK to your Android phone
    echo 2. Install it
    echo 3. Sign up and test all features!
    echo.
) else (
    echo.
    echo ============================================================
    echo BUILD FAILED - Check errors above
    echo ============================================================
)

pause
