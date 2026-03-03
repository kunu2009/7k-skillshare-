# ⚡ SkillSwap Quick Reference

## 🚀 Quick Start Commands

### Setup
```bash
# Windows
setup.bat

# Mac/Linux
chmod +x setup.sh
./setup.sh
```

### Run App
```bash
# Default (whatever device is connected)
flutter run

# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d web

# With verbose output
flutter run -v
```

### Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS
flutter build ipa --release

# Web
flutter build web --release
```

---

## 🛠 Common Development Tasks

### Code Generation
```bash
# Run build runner
flutter pub run build_runner build

# Clean and rebuild
flutter pub run build_runner clean
flutter pub run build_runner build

# Watch mode (auto-rebuild on changes)
flutter pub run build_runner watch
```

### Dependency Management
```bash
# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

### Cleaning & Rebuilding
```bash
# Clean project
flutter clean

# Full setup
flutter clean
flutter pub get
flutter pub run build_runner build

# Then run
flutter run
```

---

## 📱 Device Management

### List Devices
```bash
flutter devices
```

### Run on Specific Device
```bash
flutter run -d <device_id>
```

### Kill All Dart Processes
```bash
# macOS/Linux
killall dart

# Windows (PowerShell)
Get-Process dart | Stop-Process
```

---

## 🔍 Debugging & Logging

### View Logs
```bash
flutter logs
```

### Filter Logs
```bash
flutter logs -f "error"
flutter logs -f "warning"
```

### Enable Observatory (DevTools)
```bash
flutter run --debugger-module
```

### Use Flutter DevTools
```bash
flutter pub global activate devtools
devtools
```

---

## 📂 Project Structure Quick Reference

```
lib/
├── main.dart                    # Entry point
├── config/                      # Configuration
│   ├── app_theme.dart
│   ├── constants.dart
│   └── routes/
├── models/                      # Data models
├── services/                    # Backend services
├── providers/                   # State management
├── screens/                     # UI screens
└── widgets/                     # Reusable components
```

---

## 🔑 Key Files to Know

### Must Update Files
| File | Why | What |
|------|-----|------|
| `firebase_options.dart` | Firebase setup | Add your API keys |
| `constants.dart` | Agora setup | Add Agora App ID |
| `.env` | Environment | Add sensitive data |
| `pubspec.yaml` | Dependencies | Update if needed |

### Important Configuration
| File | Purpose |
|------|---------|
| `lib/config/app_theme.dart` | Colors, fonts, spacing |
| `lib/config/constants.dart` | App-wide constants |
| `lib/config/routes/app_router.dart` | Navigation routes |

### Entry Points
| File | Purpose |
|------|---------|
| `lib/main.dart` | App initialization |
| `lib/screens/splash_screen.dart` | First screen shown |
| `lib/screens/auth/login_screen.dart` | Login screen |

---

## 🎯 Navigation

### Go to Home
```dart
context.go('/home');
```

### Go to Login
```dart
context.go('/login');
```

### Push to Explore
```dart
context.push('/home/explore');
```

### Go to Profile with UID
```dart
context.push('/home/profile/user_uid_here');
```

---

## 🔒 Firebase Commands

### Install Firebase CLI
```bash
npm install -g firebase-tools
```

### Login to Firebase
```bash
firebase login
```

### Initialize Project
```bash
firebase init
```

### Deploy Functions
```bash
firebase deploy --only functions
```

### Deploy Rules
```bash
firebase deploy --only firestore:rules,storage
```

### View Logs
```bash
firebase functions:log
```

---

## 📦 Dependency Quick Reference

### Import Common Packages
```dart
// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Provider
import 'package:provider/provider.dart';

// Navigation
import 'package:go_router/go_router.dart';

// Custom
import 'package:skillswap/config/app_theme.dart';
import 'package:skillswap/models/models.dart';
```

### Common Provider Usage
```dart
// Watch provider
Consumer<AuthProvider>(
  builder: (context, authProvider, _) {
    return Text(authProvider.currentUser?.displayName ?? 'Guest');
  },
)

// Read provider
final authProvider = context.read<AuthProvider>();

// Get provider value
final user = Provider.of<AuthProvider>(context).currentUser;
```

---

## 🎨 Theme & Colors

### Primary Colors
```dart
AppColors.primaryColor       // Main brand color
AppColors.primaryLight       // Light variant
AppColors.primaryDark        // Dark variant
```

### Semantic Colors
```dart
AppColors.successColor       // Green (success)
AppColors.errorColor         // Red (error)
AppColors.warningColor       // Amber (warning)
AppColors.infoColor          // Blue (info)
```

### Neutral Colors
```dart
AppColors.textPrimary        // Main text
AppColors.textSecondary      // Secondary text
AppColors.textTertiary       // Tertiary text
AppColors.backgroundColor    // Background
AppColors.surfaceColor       // Surface/card
AppColors.borderColor        // Borders
```

### Spacing
```dart
AppSpacing.xs   // 4px
AppSpacing.sm   // 8px
AppSpacing.md   // 12px
AppSpacing.lg   // 16px
AppSpacing.xl   // 20px
AppSpacing.xxl  // 24px
AppSpacing.xxxl // 32px
```

---

## 🧪 Testing Quick Commands

### Run Tests
```bash
flutter test
```

### Run Specific Test
```bash
flutter test test/models_test.dart
```

### Generate Coverage
```bash
flutter test --coverage
```

### View Coverage
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🐛 Troubleshooting Quick Fixes

### App won't run
```bash
flutter clean
flutter pub get
flutter pub run build_runner build
flutter run
```

### Firebase connection error
- Check `firebase_options.dart`
- Verify internet connection
- Check Firebase project ID

### Agora connection error
- Check App ID in `constants.dart`
- Verify network connection
- Check Agora console for status

### Package version conflict
```bash
flutter pub get
flutter pub upgrade
flutter clean
```

### Build failed
```bash
flutter clean
flutter pub get --verbose
flutter run -v
```

---

## 📊 Common Code Snippets

### Create Provider Watcher
```dart
Consumer<AuthProvider>(
  builder: (context, auth, _) {
    if (auth.isLoading) {
      return CustomLoadingWidget();
    }
    if (auth.error != null) {
      return CustomErrorWidget(message: auth.error!);
    }
    return YourWidget();
  },
)
```

### Firestore Query
```dart
final snapshot = await FirebaseFirestore.instance
    .collection('users')
    .where('teachSkills', arrayContains: 'Programming')
    .get();
```

### Show Snackbar
```dart
CustomSnackbar.showSuccess(context, 'Success message');
CustomSnackbar.showError(context, 'Error message');
CustomSnackbar.showInfo(context, 'Info message');
```

### Navigate with Parameters
```dart
context.push('/home/profile/${userId}');
context.go('/home');
context.pop();
```

---

## 🎯 Constants & Enums

### Connection Status
```dart
'pending'   // Awaiting response
'accepted'  // Connection established
'rejected'  // Request declined
'blocked'   // User blocked
```

### Session Status
```dart
'pending'       // Awaiting response
'accepted'      // Ready to start
'in_progress'   // Currently active
'completed'     // Finished
'cancelled'     // Not happening
```

### User Status
```dart
'online'    // Currently active
'offline'   // Not active
'away'      // Away/idle
```

---

## 📝 Git Commands

### Commit Changes
```bash
git add .
git commit -m "feature: add new feature"
git push
```

### Branch Management
```bash
# Create branch
git checkout -b feature/feature-name

# Switch branch
git checkout main

# Delete branch
git branch -d feature-name
```

### Undo Changes
```bash
# Discard local changes
git checkout -- .

# Undo last commit
git revert HEAD
```

---

## 🚀 Deployment Checklist

- [ ] All tests pass: `flutter test`
- [ ] No warnings: `flutter analyze`
- [ ] App builds: `flutter build apk`
- [ ] Icons updated
- [ ] Version bumped in `pubspec.yaml`
- [ ] Changelog updated
- [ ] Credentials configured
- [ ] Privacy policy ready
- [ ] App description written
- [ ] Screenshots prepared

---

## 📞 Help Commands

### Flutter Help
```bash
flutter --help
flutter run --help
flutter build --help
```

### Pub Package Help
```bash
flutter pub --help
```

### Check Flutter Info
```bash
flutter doctor
flutter doctor -v
```

---

## ⚙️ Environment Setup

### Check Flutter Version
```bash
flutter --version
```

### Update Flutter
```bash
flutter upgrade
```

### Install Flutter on Machine
Visit: https://flutter.dev/docs/get-started/install

### Add Flutter to PATH
- **Windows**: `C:\Users\username\flutter\bin`
- **Mac/Linux**: Add to `.bashrc` or `.zshrc`

---

## 🎓 Learning Commands

### Open Documentation
```bash
# Flutter docs
flutter docs

# Pub.dev for package
pub global run pana <package_name>
```

---

## 💡 Pro Tips

1. **Use hot reload** - Press `r` in terminal after `flutter run`
2. **Use hot restart** - Press `R` in terminal for full app restart
3. **Enable logging** - Run `flutter logs` in another terminal
4. **Use DevTools** - Press `d` in terminal when app is running
5. **Check device list** - `flutter devices` before running
6. **Use verbose mode** - Add `-v` to any command for detailed output

---

## 🔗 Important Links

- **Flutter Docs**: https://flutter.dev/docs
- **Firebase Docs**: https://firebase.google.com/docs
- **Agora Docs**: https://docs.agora.io
- **Pub.dev**: https://pub.dev
- **GitHub**: https://github.com
- **Stack Overflow**: https://stackoverflow.com/questions/tagged/flutter

---

**Last Updated**: March 2026  
**Version**: 1.0.0  
**Status**: Ready to Use
