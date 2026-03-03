@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Final Build - All Errors Fixed
echo ========================================
echo.

echo Cleaning...
call flutter clean
echo.

echo Getting dependencies...
call flutter pub get
echo.

echo Building APK (final attempt)...
call flutter build apk --release 2>&1

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo SUCCESS! APK BUILT!
    echo ========================================
    echo.
    echo APK Location:
    echo build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo Ready to install on your phone!
) else (
    echo.
    echo BUILD FAILED - Check errors above
    echo.
)

pause
