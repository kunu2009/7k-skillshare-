@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - COMMIT AUTH FIXES & BUILD
echo ============================================================
echo.

echo Fixes being committed:
echo ✓ Router redirect logic (no auto-redirect on auth screens)
echo ✓ AuthProvider initialization (clean state management)
echo ✓ Proper navigation flow for forgot password and signup
echo.

echo [Step 1] Committing fixes to GitHub...
git add .
git commit -m "Fix: Auth flow - prevent auto-redirect on forgot password and signup. Proper navigation state management."
git push -u origin main

echo.
echo [Step 2] Cleaning build directory...
call flutter clean >nul 2>&1

echo [Step 3] Getting dependencies...
call flutter pub get >nul 2>&1

echo.
echo [Step 4] Building APK (Auth Flow Fixed)...
echo This will take 10-15 minutes. Please wait...
echo.
call flutter build apk --release

echo.
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo.
    echo ============================================================
    echo ✓ SUCCESS! APK BUILT WITH AUTH FIXES
    echo ============================================================
    echo.
    echo Code committed to: https://github.com/kunu2009/7k-skillshare-
    echo.
    echo APK Location:
    echo build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo Auth Flow Fixes:
    echo ✓ No auto sign-in on "Forgot Password" click
    echo ✓ No auto sign-in on "Sign Up" click
    echo ✓ Proper navigation state management
    echo ✓ Clean auth provider initialization
    echo.
    echo Installation:
    echo 1. Copy APK to Android phone
    echo 2. Install the APK
    echo 3. Test auth flow:
    echo    - Click "Forgot Password" (should stay on that screen)
    echo    - Click "Sign Up" (should stay on that screen)
    echo    - Sign in with email (should go to home)
    echo.
) else (
    echo.
    echo ============================================================
    echo ✗ BUILD FAILED
    echo ============================================================
    echo Check errors above
)

pause
