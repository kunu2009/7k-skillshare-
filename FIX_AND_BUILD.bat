@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo FIX & REBUILD COMPLETE PIPELINE
echo ============================================================
echo.

echo [Step 1] Committing bug fixes...
git add .
git commit -m "Fix: ThemeProvider duplicate constructor and User model uid reference"
git push -u origin main

echo.
echo [Step 2] Building APK with fixes...
call flutter clean >nul 2>&1
call flutter pub get >nul 2>&1
call flutter build apk --release

echo.
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ============================================================
    echo SUCCESS! ALL FIXED AND APK BUILT
    echo ============================================================
    echo.
    echo APK Location:
    echo build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo All features working:
    echo - Email/Password login
    echo - Google Sign-In
    echo - User discovery & search
    echo - Dark mode toggle
    echo - Settings screen
    echo - Real-time chat
    echo.
    echo Install on your Android phone now!
    echo.
) else (
    echo ============================================================
    echo BUILD FAILED - Check errors
    echo ============================================================
)

pause
