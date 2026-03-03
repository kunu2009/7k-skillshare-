#!/usr/bin/env bash
# SkillSwap setup script for macOS/Linux

echo "========================================="
echo "SkillSwap Flutter App - Setup Script"
echo "========================================="
echo ""

echo "Step 1: Cleaning previous builds..."
flutter clean
echo "✓ Clean complete"

echo ""
echo "Step 2: Getting Flutter dependencies..."
flutter pub get
echo "✓ Dependencies installed"

echo ""
echo "Step 3: Running build runner for code generation..."
flutter pub run build_runner build --delete-conflicting-outputs
echo "✓ Code generation complete"

echo ""
echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Update lib/firebase_options.dart with your Firebase credentials"
echo "2. Update Agora App ID in lib/config/constants.dart"
echo "3. Ensure you have Android SDK and/or Xcode installed"
echo "4. Run 'flutter run' to start the app"
echo ""
echo "For web:"
echo "  flutter run -d web"
echo ""
echo "For Android:"
echo "  flutter run -d android"
echo ""
echo "For iOS:"
echo "  flutter run -d ios"
echo ""
echo "Happy coding! 🚀"
