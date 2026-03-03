# SkillSwap Firebase Configuration

## Android Configuration

1. Download `google-services.json` from Firebase Console
2. Place it at: `android/app/google-services.json`

## iOS Configuration

1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to Xcode under: Runner → Targets → Runner
3. Ensure it's included in the Copy Bundle Resources build phase

## Web Configuration

Firebase is configured automatically via `firebase_options.dart`

## Environment Variables

Create a `.env` file in the root directory:

```
AGORA_APP_ID=your_agora_app_id_here
```

## Firestore Security Rules

Copy these rules to your Firestore console:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow create: if request.auth.uid == userId;
      allow update: if request.auth.uid == userId;
      allow delete: if request.auth.uid == userId;
    }
    
    // Connections collection
    match /connections/{connectionId} {
      allow read: if request.auth != null && 
                     (resource.data.userId1 == request.auth.uid || 
                      resource.data.userId2 == request.auth.uid);
      allow create: if request.auth != null && 
                       request.auth.uid == request.resource.data.userId1;
      allow update: if request.auth != null && 
                       (resource.data.userId1 == request.auth.uid || 
                        resource.data.userId2 == request.auth.uid);
    }
    
    // Chats and messages
    match /chats/{chatId}/messages/{messageId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                       request.auth.uid == request.resource.data.senderId;
      allow update: if request.auth != null && 
                       request.auth.uid == resource.data.senderId;
      allow delete: if request.auth != null && 
                       request.auth.uid == resource.data.senderId;
    }
    
    // Sessions
    match /sessions/{sessionId} {
      allow read: if request.auth != null && 
                     (resource.data.initiatorId == request.auth.uid || 
                      resource.data.receiverId == request.auth.uid);
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
                       (resource.data.initiatorId == request.auth.uid || 
                        resource.data.receiverId == request.auth.uid);
    }
    
    // Reviews
    match /reviews/{reviewId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                       request.auth.uid == request.resource.data.reviewerId;
      allow update: if request.auth != null && 
                       request.auth.uid == resource.data.reviewerId;
    }
  }
}
```

## Firebase Storage Rules

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Allow authenticated users to upload and download
    match /uploads/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Firebase Authentication

Enable the following authentication methods:
- Email/Password

## Firebase Cloud Messaging (FCM)

1. Upload your server key from FCM to Firebase Console
2. For iOS, upload your APNs certificate
3. For Android, google-services.json automatically handles FCM setup

## Agora Configuration

1. Get your Agora App ID from [Agora Console](https://console.agora.io)
2. Update it in `lib/config/constants.dart`:
   ```dart
   static const String agoraAppId = 'YOUR_ACTUAL_APP_ID';
   ```

## Testing

After configuration:

```bash
# Test Firebase connection
flutter run

# Run on specific device
flutter run -d <device_id>

# Enable verbose logging
flutter run -v
```

## Troubleshooting

### Firebase Connection Failed
- Verify internet connectivity
- Check Firebase project ID is correct
- Ensure Android/iOS apps are registered in Firebase Console
- For web, verify domain is added to Firebase Console

### Authentication Issues
- Clear app data: `flutter clean`
- Rebuild: `flutter pub get && flutter run`
- Check Firebase Authentication is enabled for Email/Password

### Agora Connection Issues
- Verify Agora App ID is correct
- Ensure you have API calls enabled in Agora Console
- Check network firewall allows Agora ports (UDP 1024-65535)

### Push Notifications Not Working
- Verify FCM token generation (check logs)
- For Android, ensure google-services.json is correct
- For iOS, ensure APNs certificate is uploaded
- Check Firestore has notification documents with correct format

## Next Steps

1. Update `lib/firebase_options.dart` with your Firebase project details
2. Update `lib/config/constants.dart` with your Agora App ID
3. Run the app: `flutter run`
4. Create a user account and test the features
