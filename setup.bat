@echo off
echo ===============================================
echo SkillSwap Flutter App - Setup Script
echo ===============================================
echo.

echo Step 1: Cleaning previous builds...
call flutter clean
echo ✓ Clean complete

echo.
echo Step 2: Getting Flutter dependencies...
call flutter pub get
echo ✓ Dependencies installed

echo.
echo Step 3: Running build runner for code generation...
call flutter pub run build_runner build --delete-conflicting-outputs
echo ✓ Code generation complete

echo.
echo ===============================================
echo Setup Complete!
echo ===============================================
echo.
echo Next steps:
echo 1. Update lib/firebase_options.dart with your Firebase credentials
echo 2. Update Agora App ID in the appropriate config file
echo 3. Ensure you have Android SDK and/or Xcode installed
echo 4. Run 'flutter run' to start the app
echo.
echo For web:
echo   flutter run -d web
echo.
echo For Android:
echo   flutter run -d android
echo.
echo For iOS:
echo   flutter run -d ios
echo.
pause
