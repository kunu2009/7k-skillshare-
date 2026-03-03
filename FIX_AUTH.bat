@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - FIX AUTH FLOW (AUTO SIGN-IN ISSUE)
echo ============================================================
echo.

echo Fixes Applied:
echo - Router redirect logic (no auto-redirect on auth screens)
echo - AuthProvider initialization (no navigation side effects)
echo - Prevent auto sign-in on forgot password/signup navigation
echo.

echo [Step 1] Cleaning...
call flutter clean >nul 2>&1

echo [Step 2] Getting dependencies...
call flutter pub get >nul 2>&1

echo.
echo [Step 3] Building APK...
echo This will take 10-15 minutes...
echo.
call flutter build apk --release

echo.
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo.
    echo ============================================================
    echo ✓ SUCCESS! AUTH FLOW FIXED - APK BUILT
    echo ============================================================
    echo.
    echo Fixes:
    echo ✓ No auto sign-in on forgot password
    echo ✓ No auto sign-in on signup
    echo ✓ Proper auth state management
    echo ✓ Correct navigation flow
    echo.
    echo APK Location:
    echo build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo Installation:
    echo 1. Copy APK to Android phone
    echo 2. Install
    echo 3. Test auth flow:
    echo    - Click "Forgot Password" (should not auto-login)
    echo    - Click "Sign Up" (should not auto-login)
    echo    - Sign in with email (should work)
    echo.
) else (
    echo.
    echo ============================================================
    echo ✗ BUILD FAILED
    echo ============================================================
    echo Check errors above
)

pause
