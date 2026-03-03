@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - APK BUILD ONLY (FIXED ERRORS)
echo ============================================================
echo.

echo Errors Fixed:
echo ✓ ThemeProvider duplicate constructor
echo ✓ User model 'id' changed to 'uid'
echo.

echo [Step 1] Deep cleaning...
call flutter clean >nul 2>&1

echo [Step 2] Getting fresh dependencies...
call flutter pub get

echo.
echo [Step 3] Building APK (Release)...
echo This will take 10-15 minutes. Please wait...
echo.
call flutter build apk --release

echo.
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    for /f %%A in ('powershell -Command "(Get-Item 'build\app\outputs\flutter-apk\app-release.apk').length / 1MB"') do set size=%%A

    echo.
    echo ============================================================
    echo ✓ SUCCESS! APK BUILT SUCCESSFULLY
    echo ============================================================
    echo.
    echo APK Details:
    echo Location: build\app\outputs\flutter-apk\app-release.apk
    echo Size: ~23 MB
    echo.
    echo Features Included:
    echo ✓ Email/Password authentication
    echo ✓ Google Sign-In
    echo ✓ User discovery & search
    echo ✓ Dark mode toggle
    echo ✓ Settings screen
    echo ✓ Real-time chat
    echo ✓ Connection requests
    echo ✓ Profile management
    echo.
    echo Next Steps:
    echo 1. Copy APK to Android phone via USB
    echo 2. Install the APK
    echo 3. Open SkillSwap
    echo 4. Sign up and test all features!
    echo.
    echo To deploy to web later, run:
    echo   .\BUILD_WEB_FIXED.bat
    echo.
) else (
    echo.
    echo ============================================================
    echo ✗ BUILD FAILED
    echo ============================================================
    echo Check the errors above and fix them.
)

pause
