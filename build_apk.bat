@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Building SkillSwap APK for Android
echo ========================================
echo.

echo Step 0: Cleaning duplicate Gradle files...
cd android
if exist settings.gradle.kts del /f /q settings.gradle.kts
if exist build.gradle.kts del /f /q build.gradle.kts
cd ..
echo.

echo Step 1: Cleaning previous builds...
call flutter clean
echo.

echo Step 2: Getting dependencies...
call flutter pub get
echo.

echo Step 3: Building APK (this takes 5-10 minutes)...
echo Please wait...
echo.

REM Set Dart VM options for better compilation
set DART_VM_OPTIONS=-Xmx4g

call flutter build apk --release
echo.

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo.
    echo Please check the error messages above.
    echo.
    pause
    exit /b 1
)

echo ========================================
echo BUILD COMPLETE!
echo ========================================
echo.
echo Your APK is ready at:
echo build\app\outputs\flutter-apk\app-release.apk
echo.
echo File size: approximately 25-40 MB
echo.
echo To install on your phone:
echo 1. Copy the APK file to your phone
echo 2. Open the APK file on your phone
echo 3. Allow "Install from unknown sources" if prompted
echo 4. Install and enjoy!
echo.
pause
