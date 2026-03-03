# 🚀 SkillSwap - Getting Started Guide

Welcome to SkillSwap! This guide will help you set up and run the application.

## 📋 Prerequisites

Before you start, make sure you have:

- **Flutter SDK**: Version 3.10.0 or higher
  - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
  - Run `flutter --version` to verify installation

- **Dart SDK**: Version 3.0.0 or higher
  - Usually comes with Flutter
  - Run `dart --version` to verify

- **IDE**: Android Studio, VS Code, or Xcode
  - Recommended: VS Code with Flutter extension

- **Firebase Account**: Create at [firebase.google.com](https://firebase.google.com)

- **Agora Account**: Create at [agora.io](https://www.agora.io)

## ⚡ Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd skillswap
```

### 2. Run Setup Script

**Windows:**
```bash
setup.bat
```

**macOS/Linux:**
```bash
chmod +x setup.sh
./setup.sh
```

This will:
- Clean previous builds
- Install dependencies
- Generate code from build runner

### 3. Configure Firebase

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project called "SkillSwap"
3. Enable Authentication (Email/Password)
4. Create a Firestore Database in production mode
5. Create a Storage bucket
6. Enable Cloud Messaging

Then update `lib/firebase_options.dart`:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: '1:YOUR_PROJECT_NUMBER:android:YOUR_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'your-project-id',
  databaseURL: 'https://your-project-id.firebaseio.com',
  storageBucket: 'your-project-id.appspot.com',
);
```

### 4. Configure Agora

1. Sign up at [Agora Console](https://console.agora.io)
2. Create a new project
3. Copy your App ID
4. Update `lib/config/constants.dart`:

```dart
static const String agoraAppId = 'YOUR_AGORA_APP_ID';
```

### 5. Run the App

```bash
# For development
flutter run

# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Web
flutter run -d web
```

## 📱 Platform-Specific Setup

### Android Setup

1. Minimum SDK: 21
2. Download `google-services.json` from Firebase Console
3. Place at: `android/app/google-services.json`
4. In Android Studio: Build → Generate Signed Bundle/APK

### iOS Setup

1. Minimum deployment target: 11.0
2. Download `GoogleService-Info.plist` from Firebase Console
3. Open `ios/Runner.xcworkspace` in Xcode
4. Add the plist file to Runner project
5. Run: `pod install` in the ios directory

### Web Setup

1. Firebase web configuration is automatic
2. Run: `flutter run -d web`
3. Built files go to: `build/web/`

## 🧪 Testing the App

### Create a Test Account

1. Launch the app
2. Click "Sign Up"
3. Enter:
   - Full name: Test User
   - Email: test@example.com
   - Password: password123

### Add Skills

1. Go to Profile → Edit Profile
2. Add teaching skills (e.g., "Programming")
3. Add learning skills (e.g., "Music")
4. Save changes

### Connect with Another User

1. Log in with a different account
2. Go to Home → Connections
3. Search for the first user
4. Send a connection request
5. Switch to first account and accept request

### Start a Chat

1. From Connections, click on a connected user
2. Click "Message"
3. Type and send a message
4. Message should appear in real-time

### Schedule a Session

1. From a connected user's profile
2. Click "Schedule Session"
3. Select date, time, and skill
4. Recipient receives notification
5. Can accept/reject session

## 🛠 Troubleshooting

### "flutter: command not found"
- Add Flutter to your PATH
- macOS/Linux: Edit `.bashrc` or `.zshrc`
- Windows: Add Flutter bin to System Path

### "Build failed" errors
```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build
```

### Firebase connection issues
- Verify internet connection
- Check Firebase project ID
- Ensure authentication is enabled
- Review Firestore security rules

### App crashes on startup
1. Check logs: `flutter logs`
2. Verify all configuration files
3. Ensure dependencies are installed

### Device not recognized
```bash
flutter devices  # List available devices
flutter run -d <device_id>
```

## 📚 Project Structure Explanation

```
lib/
├── main.dart                 # App initialization
├── config/                   # Configuration files
│   ├── app_theme.dart       # Theme & colors
│   ├── constants.dart       # App constants
│   └── routes/app_router.dart # Navigation
├── models/                   # Data models
├── services/                 # Backend services
│   ├── auth_service.dart
│   ├── notification_service.dart
│   ├── session_service.dart
│   └── review_service.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── user_profile_provider.dart
│   ├── connection_provider.dart
│   └── chat_provider.dart
├── screens/                  # UI screens
│   ├── auth/
│   ├── home/
│   ├── profile/
│   ├── connections/
│   ├── chat/
│   └── call/
└── widgets/                  # Reusable widgets
    └── custom_widgets.dart
```

## 🔑 Key Features Walkthrough

### 1. Authentication
- Email/password signup
- Email/password login
- Password reset
- Session persistence

### 2. User Profiles
- View and edit profile
- Add/remove skills
- Upload profile photo
- Set communication preferences

### 3. Skill Matching
- View suggested matches
- Search users by skills
- View user profiles
- Send connection requests

### 4. Connections
- Manage connection requests
- View connections list
- Update permissions
- Block users

### 5. Messaging
- Real-time text chat
- File sharing
- Message history
- Typing indicators

### 6. Sessions
- Schedule sessions
- Join instant calls
- Real-time audio/video
- Session recording (optional)

### 7. Reviews
- Rate users
- Leave feedback
- View rating history
- Build reputation

## 🚀 Deployment

### Build APK (Android)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-app.apk
```

### Build App Bundle (Google Play)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app.aab
```

### Build IPA (iOS)
```bash
flutter build ipa --release
# Output: build/ios/ipa/
```

### Build Web
```bash
flutter build web --release
# Output: build/web/
```

## 📖 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Flutter Guide](https://firebase.flutter.dev/)
- [Provider Pattern](https://pub.dev/packages/provider)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Agora Documentation](https://docs.agora.io)

## 💡 Tips & Best Practices

1. **Development**: Use `flutter run` with hot reload
2. **Debugging**: Use `flutter logs` to monitor logs
3. **Performance**: Profile with DevTools
4. **Testing**: Write widget tests for important features
5. **Security**: Never commit Firebase keys or secrets
6. **Storage**: Use Hive for local caching

## 🤝 Getting Help

If you encounter issues:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Review Firebase and Agora documentation
3. Check Flutter community forums
4. Open an issue on GitHub

## ✅ Checklist Before Launch

- [ ] Firebase project created and configured
- [ ] Agora account created and App ID obtained
- [ ] All dependencies installed (`flutter pub get`)
- [ ] App builds successfully (`flutter run`)
- [ ] Can create account and log in
- [ ] Can view suggested matches
- [ ] Can send and accept connection requests
- [ ] Can send messages
- [ ] Audio/video calls work
- [ ] Push notifications working

---

**Happy coding! 🎉**

For more help, refer to the [README.md](README.md) and [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
