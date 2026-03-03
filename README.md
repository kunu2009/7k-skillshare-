# SkillSwap - Peer-to-Peer Skill Exchange Platform

A Flutter-based skill barter platform where people trade knowledge instead of money. Users can connect with others to teach and learn skills through chat, audio, and video calls.

## 🚀 Features

- **User Authentication**: Email/password sign up and login with Firebase
- **Profile Management**: Create detailed profiles with skills you teach and want to learn
- **Skill Matching**: Smart algorithm to suggest compatible users based on skill alignment
- **Connection System**: Request-based connection model with permission controls
- **Real-time Chat**: Text messaging with file sharing capabilities
- **Audio & Video Calls**: Secure communication powered by Agora
- **Session Scheduling**: Schedule or start instant skill exchange sessions
- **Rating & Reviews**: Build reputation through verified sessions
- **Push Notifications**: Real-time alerts for connection requests, calls, and messages
- **Cross-Platform**: Works on Android, iOS, and Web

## 🛠 Tech Stack

- **Frontend**: Flutter 3.10+
- **Backend**: Firebase (Auth, Firestore, Storage, Cloud Messaging)
- **Real-time Communication**: Agora RTM & RTC
- **State Management**: Provider
- **Routing**: GoRouter
- **Local Storage**: Hive, GetStorage

## 📋 Prerequisites

- Flutter 3.10.0 or higher
- Dart 3.0.0 or higher
- Android Studio / Xcode (for mobile development)
- Firebase project setup
- Agora project setup

## 🔧 Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd skillswap
```

### 2. Install Dependencies

```bash
flutter pub get
flutter pub run build_runner build
```

### 3. Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable the following services:
   - Authentication (Email/Password)
   - Firestore Database
   - Storage
   - Cloud Messaging

3. Update `lib/firebase_options.dart` with your Firebase credentials:
   ```dart
   static const FirebaseOptions android = FirebaseOptions(
     apiKey: 'YOUR_ANDROID_API_KEY',
     appId: '1:YOUR_APP_ID:android:YOUR_ANDROID_APP_ID',
     messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
     projectId: 'your-project-id',
     databaseURL: 'https://your-project-id.firebaseio.com',
     storageBucket: 'your-project-id.appspot.com',
   );
   ```

4. For Android, download `google-services.json` and place it in `android/app/`
5. For iOS, download `GoogleService-Info.plist` and add it to Xcode

### 4. Agora Setup

1. Create an Agora account at [agora.io](https://www.agora.io)
2. Create a project and get your App ID
3. Add the App ID to a config file or environment variable

### 5. Run the App

```bash
# Android
flutter run -t lib/main.dart

# iOS
flutter run -t lib/main.dart

# Web
flutter run -d web -t lib/main.dart
```

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── firebase_options.dart        # Firebase configuration
├── config/
│   ├── app_theme.dart          # Theme & color configuration
│   └── routes/
│       └── app_router.dart     # Navigation routes
├── models/
│   └── models.dart             # Data models (User, Connection, Chat, etc.)
├── services/
│   ├── auth_service.dart       # Authentication logic
│   └── notification_service.dart # Push notifications
├── providers/
│   ├── auth_provider.dart      # Auth state management
│   ├── user_profile_provider.dart
│   ├── connection_provider.dart
│   └── chat_provider.dart
└── screens/
    ├── splash_screen.dart
    ├── auth/
    │   ├── login_screen.dart
    │   ├── signup_screen.dart
    │   └── forgot_password_screen.dart
    ├── home/
    │   ├── home_screen.dart
    │   └── explore_screen.dart
    ├── profile/
    │   ├── profile_screen.dart
    │   └── edit_profile_screen.dart
    ├── connections/
    │   ├── connections_screen.dart
    │   └── connection_requests_screen.dart
    ├── chat/
    │   ├── chat_list_screen.dart
    │   └── chat_screen.dart
    └── call/
        └── call_screen.dart
```

## 🔐 Firebase Firestore Structure

### Collections

#### users
```
{
  uid: string,
  displayName: string,
  email: string,
  photoUrl: string?,
  bio: string?,
  teachSkills: string[],
  learnSkills: string[],
  languagesSpoken: string[],
  communicationPreferences: { chat: bool, audio: bool, video: bool },
  rating: number,
  sessionsCompleted: number,
  createdAt: timestamp,
  lastSeen: timestamp,
  isOnline: boolean,
  status: string (online, offline, away)
}
```

#### connections
```
{
  connectionId: string,
  userId1: string,
  userId2: string,
  status: string (pending, accepted, rejected, blocked),
  permissions: { chat: bool, audio: bool, video: bool },
  createdAt: timestamp,
  acceptedAt: timestamp?,
  initiatedBy: string
}
```

#### chats/{connectionId}/messages
```
{
  messageId: string,
  senderId: string,
  connectionId: string,
  content: string,
  messageType: string (text, file, image),
  timestamp: timestamp,
  isRead: boolean,
  fileUrl: string?,
  fileName: string?
}
```

#### sessions
```
{
  sessionId: string,
  connectionId: string,
  initiatorId: string,
  receiverId: string,
  status: string (pending, accepted, in_progress, completed, cancelled),
  scheduledTime: timestamp,
  durationMinutes: number,
  skillBeingTaught: string,
  skillBeingLearned: string,
  startTime: timestamp?,
  endTime: timestamp?,
  recordingUrl: string?
}
```

#### reviews
```
{
  reviewId: string,
  sessionId: string,
  reviewerId: string,
  revieweeId: string,
  rating: number (1-5),
  feedback: string,
  createdAt: timestamp
}
```

## 🔄 Key Workflows

### User Registration & Profile Setup
1. User signs up with email/password
2. User is directed to create initial profile
3. User adds teach/learn skills and preferences
4. Profile is saved to Firestore

### Finding & Connecting
1. User views suggested matches based on skill compatibility
2. User sends connection request
3. Recipient receives notification
4. Recipient accepts/rejects request
5. Accepted connections can communicate

### Skill Exchange Session
1. User proposes session (instant or scheduled)
2. Recipient accepts or declines
3. Session starts with audio/video via Agora
4. After session, both users can rate each other
5. Ratings update user reputation

### Real-time Communication
1. Messages are stored in Firestore
2. Changes trigger listeners for real-time updates
3. File sharing through Firebase Storage
4. Push notifications via Firebase Cloud Messaging

## 🎨 Customization

### Theme Colors
Edit `lib/config/app_theme.dart` to customize:
- Primary colors
- Text colors
- Background colors
- Border radius
- Spacing

### Skills List
Update the skills list in `lib/screens/home/explore_screen.dart` to match your platform's focus areas.

## 📱 Mobile-Specific Setup

### Android
1. Ensure `android/app/build.gradle` has minimum SDK 21+
2. Add Firebase dependencies automatically via FlutterFire
3. Enable multidex if needed

### iOS
1. Run `pod install` in the ios directory
2. Ensure iOS deployment target is 11.0+
3. Grant camera/microphone permissions in Info.plist

## 🌐 Web Deployment

```bash
flutter build web
# Deploy to Firebase Hosting
firebase deploy
```

## 🔔 Push Notifications Setup

### Android
- Service account key is automatically handled by Firebase

### iOS
- Upload APNs certificate in Firebase Console
- Ensure bundle ID matches your provisioning profile

## 🐛 Troubleshooting

### Firebase Connection Issues
- Verify Firebase credentials in `firebase_options.dart`
- Check Firestore rules allow authenticated users
- Ensure internet connectivity

### Authentication Errors
- Clear app data and try again
- Check Firebase Authentication is enabled
- Verify email format

### Call Issues
- Ensure camera/microphone permissions are granted
- Check Agora App ID is correct
- Verify network connection is stable

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Agora SDK](https://docs.agora.io/en/Video/start_live_android?platform=Android)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please follow the standard fork → create branch → commit → push → pull request workflow.

## 📧 Support

For issues and questions, please open an issue on the repository.

---

**Happy Skill Swapping!** 🔄✨

Built with ❤️ using Flutter
