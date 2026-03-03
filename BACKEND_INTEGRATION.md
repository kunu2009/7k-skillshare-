# 🔌 Backend Integration Guide

## Overview

SkillSwap uses Firebase as the primary backend with Agora for real-time communication. This guide details all backend integrations and how to connect them to the Flutter app.

---

## 📊 Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Name it "SkillSwap"
4. Enable Google Analytics (optional)
5. Create project

### 2. Register Apps

#### Android
1. In Firebase Console, click Add App → Android
2. Download `google-services.json`
3. Place in `android/app/google-services.json`
4. Package name: `com.skillswap.app`

#### iOS
1. Click Add App → iOS
2. Download `GoogleService-Info.plist`
3. Open `ios/Runner.xcworkspace`
4. Drag plist into Xcode (Runner target)
5. Bundle ID: `com.skillswap.app`

#### Web
1. Click Add App → Web
2. Firebase automatically provides config
3. No manual download needed

### 3. Enable Authentication

```
Firebase Console → Authentication → Sign-in method
Enable:
✓ Email/Password
✓ Google (Optional)
✓ Apple (Optional for iOS)
```

### 4. Create Firestore Database

```
Firebase Console → Firestore Database
→ Create Database
→ Production mode
→ Select region (choose closest to users)
```

### 5. Set Up Firestore Security Rules

Go to Firestore → Rules and replace with:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Allow authenticated users to read their own profile
    match /users/{userId} {
      allow read: if request.auth != null;
      allow create: if request.auth.uid == userId;
      allow update, delete: if request.auth.uid == userId;
    }
    
    // Allow users to view profiles they're connected to
    match /users/{userId} {
      allow read: if isConnected(request.auth.uid, userId);
    }
    
    // Connections
    match /connections/{connectionId} {
      allow read: if canAccessConnection(resource.data);
      allow create: if request.auth.uid == request.resource.data.userId1;
      allow update: if canAccessConnection(resource.data);
    }
    
    // Chat messages
    match /chats/{chatId}/messages/{messageId} {
      allow read: if canAccessChat(chatId);
      allow create: if request.auth.uid == request.resource.data.senderId 
                      && canAccessChat(chatId);
      allow update: if request.auth.uid == resource.data.senderId;
      allow delete: if request.auth.uid == resource.data.senderId;
    }
    
    // Sessions
    match /sessions/{sessionId} {
      allow read: if isSessionParticipant(resource.data);
      allow create: if request.auth != null;
      allow update: if isSessionParticipant(resource.data);
    }
    
    // Reviews
    match /reviews/{reviewId} {
      allow read: if request.auth != null;
      allow create: if request.auth.uid == request.resource.data.reviewerId;
    }
    
    // Helper functions
    function isConnected(userId, otherUserId) {
      return exists(/databases/$(database)/documents/connections/
        $(userId)_$(otherUserId)) 
        || exists(/databases/$(database)/documents/connections/
        $(otherUserId)_$(userId));
    }
    
    function canAccessConnection(data) {
      return request.auth.uid == data.userId1 
          || request.auth.uid == data.userId2;
    }
    
    function canAccessChat(chatId) {
      let parts = chatId.split('_');
      return (request.auth.uid == parts[0] || request.auth.uid == parts[1]);
    }
    
    function isSessionParticipant(data) {
      return request.auth.uid == data.initiatorId 
          || request.auth.uid == data.receiverId;
    }
  }
}
```

### 6. Create Storage Bucket

```
Firebase Console → Storage
→ Create Bucket
→ Production mode
→ Select region
```

Set Storage Rules:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /uploads/{userId}/{allPaths=**} {
      allow read: if isUserOrConnected(userId);
      allow write: if request.auth.uid == userId 
                      && request.resource.size < 50 * 1024 * 1024; // 50MB limit
    }
  }
  
  function isUserOrConnected(userId) {
    return request.auth.uid == userId;
  }
}
```

### 7. Enable Cloud Messaging

```
Firebase Console → Cloud Messaging
→ Web API Key (note it)
```

---

## 📱 Cloud Functions (Optional but Recommended)

For production, create a Firebase Cloud Function to handle Agora token generation:

### Create Cloud Function

```bash
firebase init functions
cd functions
npm install agora-token
```

### Token Generation Function

```javascript
// functions/index.js
const functions = require("firebase-functions");
const {RtcTokenBuilder, RtmTokenBuilder} = require("agora-token");

exports.generateAgoraToken = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  const {channelName, uid, role} = data;
  const appID = process.env.AGORA_APP_ID;
  const appCertificate = process.env.AGORA_CERTIFICATE;

  try {
    const token = RtcTokenBuilder.buildTokenWithUid(
      appID,
      appCertificate,
      channelName,
      uid,
      role === "publisher" ? 1 : 2,
      Math.floor(Date.now() / 1000) + 3600
    );

    return {success: true, token};
  } catch (error) {
    throw new functions.https.HttpsError("internal", error.message);
  }
});
```

Deploy:
```bash
firebase deploy --only functions
```

---

## 🎥 Agora Integration

### 1. Create Agora Account

1. Go to [Agora Console](https://console.agora.io)
2. Sign up and verify email
3. Create a new project
4. Copy App ID

### 2. Update App Configuration

Update `lib/config/constants.dart`:

```dart
static const String agoraAppId = 'YOUR_AGORA_APP_ID';
```

### 3. Implement Agora Token Generation

In your backend, create the token generation endpoint (see Cloud Functions above).

### 4. Integrate in Call Screen

```dart
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class CallScreenState extends State<CallScreen> {
  late RtcEngine _rtcEngine;
  String? _token;

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    // Get token from Cloud Function
    final callable = FirebaseFunctions.instance.httpsCallable(
      'generateAgoraToken',
    );
    
    final result = await callable.call({
      'channelName': widget.connectionId,
      'uid': int.parse(currentUser.uid.hashCode.toString()),
      'role': 'publisher',
    });

    _token = result.data['token'];

    _rtcEngine = createAgoraRtcEngine();
    await _rtcEngine.initialize(
      RtcEngineContext(appId: AppConstants.agoraAppId),
    );

    await _rtcEngine.joinChannel(
      token: _token!,
      channelId: widget.connectionId,
      options: const RtcChannelMediaOptions(),
      uid: int.parse(currentUser.uid.hashCode.toString()),
    );
  }

  @override
  void dispose() {
    _rtcEngine.leaveChannel();
    _rtcEngine.release();
    super.dispose();
  }
}
```

---

## 💾 Database Schema

### Users Collection
```
/users/{userId}
├── uid: string
├── displayName: string
├── email: string
├── photoUrl: string
├── bio: string
├── teachSkills: array
├── learnSkills: array
├── languagesSpoken: array
├── communicationPreferences: {chat: bool, audio: bool, video: bool}
├── rating: number
├── sessionsCompleted: number
├── createdAt: timestamp
├── lastSeen: timestamp
├── isOnline: boolean
└── status: string
```

### Connections Collection
```
/connections/{connectionId}
├── connectionId: string
├── userId1: string
├── userId2: string
├── status: string (pending|accepted|rejected|blocked)
├── permissions: {chat: bool, audio: bool, video: bool}
├── createdAt: timestamp
├── acceptedAt: timestamp
└── initiatedBy: string
```

### Chats Collection
```
/chats/{connectionId}
├── messages
│   └── {messageId}
│       ├── messageId: string
│       ├── senderId: string
│       ├── content: string
│       ├── messageType: string (text|file|image)
│       ├── timestamp: timestamp
│       ├── isRead: boolean
│       ├── fileUrl: string
│       └── fileName: string
└── lastMessage: string
```

### Sessions Collection
```
/sessions/{sessionId}
├── sessionId: string
├── connectionId: string
├── initiatorId: string
├── receiverId: string
├── status: string (pending|accepted|in_progress|completed|cancelled)
├── scheduledTime: timestamp
├── durationMinutes: number
├── skillBeingTaught: string
├── skillBeingLearned: string
├── startTime: timestamp
├── endTime: timestamp
└── recordingUrl: string
```

### Reviews Collection
```
/reviews/{reviewId}
├── reviewId: string
├── sessionId: string
├── reviewerId: string
├── revieweeId: string
├── rating: number (1-5)
├── feedback: string
└── createdAt: timestamp
```

---

## 🔐 API Endpoints (If Using Custom Backend)

If you prefer a custom backend instead of/in addition to Firebase:

### Authentication
```
POST /api/auth/signup
POST /api/auth/login
POST /api/auth/logout
POST /api/auth/refresh
POST /api/auth/reset-password
```

### Users
```
GET /api/users/{userId}
PUT /api/users/{userId}
GET /api/users/search?skill=&language=
GET /api/users/{userId}/matches
```

### Connections
```
POST /api/connections/request
GET /api/connections
GET /api/connections/pending
PUT /api/connections/{connectionId}/accept
PUT /api/connections/{connectionId}/reject
DELETE /api/connections/{connectionId}
```

### Chat
```
GET /api/chats/{connectionId}/messages
POST /api/chats/{connectionId}/messages
GET /api/messages/unread
```

### Sessions
```
POST /api/sessions
GET /api/sessions/{userId}
PUT /api/sessions/{sessionId}/accept
PUT /api/sessions/{sessionId}/start
PUT /api/sessions/{sessionId}/end
GET /api/sessions/{sessionId}/history
```

### Reviews
```
POST /api/reviews
GET /api/reviews/{userId}
GET /api/reviews/{userId}/average
```

---

## 📡 Real-time Communication Setup

### Firebase Realtime Database (Alternative to Firestore)

For lower latency real-time updates:

```
Firebase Console → Realtime Database
→ Create Database
→ Production mode
```

Rules:
```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "auth.uid === $uid || root.child('connections').child(auth.uid).child($uid).exists()",
        ".write": "auth.uid === $uid"
      }
    },
    "messages": {
      "$connectionId": {
        ".read": "auth.uid === $connectionId.split('_')[0] || auth.uid === $connectionId.split('_')[1]",
        ".write": "auth.uid === query.limitToChild('senderId').val() && (auth.uid === $connectionId.split('_')[0] || auth.uid === $connectionId.split('_')[1])"
      }
    }
  }
}
```

---

## 🧪 Testing Backend Integration

### 1. Test Firebase Connection

```dart
void testFirebase() async {
  try {
    // Test auth
    final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password123',
    );
    print('Auth test passed: ${user.user?.email}');

    // Test Firestore
    await FirebaseFirestore.instance.collection('test').doc('test').set(
      {'test': true},
    );
    print('Firestore test passed');

    // Test Storage
    final ref = FirebaseStorage.instance.ref().child('test.txt');
    await ref.putString('test');
    print('Storage test passed');
  } catch (e) {
    print('Firebase test failed: $e');
  }
}
```

### 2. Test Agora Connection

```dart
void testAgora() async {
  try {
    final engine = createAgoraRtcEngine();
    await engine.initialize(
      RtcEngineContext(appId: AppConstants.agoraAppId),
    );
    print('Agora test passed');
  } catch (e) {
    print('Agora test failed: $e');
  }
}
```

---

## 🚀 Deployment Checklist

- [ ] Firebase project created
- [ ] All services enabled (Auth, Firestore, Storage, Messaging)
- [ ] Security rules deployed
- [ ] Firebase credentials configured
- [ ] Agora App ID configured
- [ ] Cloud Functions deployed (if using)
- [ ] Email verification enabled
- [ ] Password reset flow tested
- [ ] Database indexes created
- [ ] Backup plan established

---

## 📖 Helpful Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Agora SDK Documentation](https://docs.agora.io/)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [Cloud Functions Guide](https://firebase.google.com/docs/functions)

---

**Last Updated**: March 2026  
**Status**: Complete Integration Guide
