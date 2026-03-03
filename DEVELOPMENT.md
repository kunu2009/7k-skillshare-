# 📋 SkillSwap Development Roadmap & Architecture

## Project Overview

SkillSwap is a peer-to-peer skill exchange platform built with Flutter. It allows users to teach and learn skills without monetary transactions, using a reputation-based system.

## 🏗 Architecture Overview

### Layers

```
┌─────────────────────────────────────┐
│         UI/Screens Layer            │
│  (Authentication, Home, Chat, Call) │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│    State Management Layer (Provider) │
│  (Auth, User, Connection, Chat)     │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│      Services Layer                  │
│  (Auth, Notification, Session,      │
│   Review, Chat, Real-time Comms)    │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│      Backend (Firebase + Agora)      │
│  (Auth, Firestore, Storage, RTM/RTC)│
└─────────────────────────────────────┘
```

## 📦 Key Components

### 1. Authentication (`services/auth_service.dart`)
- Email/password signup and login
- Password reset functionality
- Session persistence
- User status tracking

### 2. User Profiles (`providers/user_profile_provider.dart`)
- Profile creation and editing
- Skill management
- Profile search and filtering
- Suggested matches algorithm

### 3. Connections (`providers/connection_provider.dart`)
- Connection requests management
- Permission settings (chat, audio, video)
- Block/unblock users
- Connection status tracking

### 4. Real-time Chat (`providers/chat_provider.dart`)
- Text messaging
- File sharing
- Message history
- Typing indicators
- Unread message tracking

### 5. Sessions (`services/session_service.dart`)
- Schedule sessions
- Instant calls
- Session status management
- Call history

### 6. Reviews (`services/review_service.dart`)
- Rate users
- Leave feedback
- Aggregate ratings
- Review history

## 🎯 Current Phase: MVP (Minimum Viable Product)

### Completed Features
- [x] User authentication
- [x] Profile management
- [x] Connection requests
- [x] Skill matching
- [x] Real-time chat infrastructure
- [x] Session scheduling structure
- [x] Review system structure
- [x] Notification service setup

### In Progress
- [ ] Full chat UI implementation
- [ ] Audio/video call UI with Agora
- [ ] Session scheduling UI
- [ ] Review UI

### Phase 2: Core Features
- [ ] Push notifications UI
- [ ] User search and filtering
- [ ] Advanced matching algorithm
- [ ] Session reminders
- [ ] Skill badges

### Phase 3: Enhancement
- [ ] Video call recording
- [ ] Group skill sessions
- [ ] Skill verification
- [ ] Advanced analytics
- [ ] AI recommendations

## 📐 Data Models

### User
```dart
{
  uid: String,
  displayName: String,
  email: String,
  photoUrl: String?,
  bio: String?,
  teachSkills: List<String>,
  learnSkills: List<String>,
  languagesSpoken: List<String>,
  communicationPreferences: Map<String, bool>,
  rating: double,
  sessionsCompleted: int,
  createdAt: DateTime,
  lastSeen: DateTime,
  isOnline: bool,
  status: String
}
```

### Connection
```dart
{
  connectionId: String,
  userId1: String,
  userId2: String,
  status: String (pending|accepted|rejected|blocked),
  permissions: Map<String, bool>,
  createdAt: DateTime,
  acceptedAt: DateTime?,
  initiatedBy: String
}
```

### ChatMessage
```dart
{
  messageId: String,
  senderId: String,
  connectionId: String,
  content: String,
  messageType: String (text|file|image),
  timestamp: DateTime,
  isRead: bool,
  fileUrl: String?,
  fileName: String?
}
```

### SkillSession
```dart
{
  sessionId: String,
  connectionId: String,
  initiatorId: String,
  receiverId: String,
  status: String (pending|accepted|in_progress|completed|cancelled),
  scheduledTime: DateTime,
  durationMinutes: int,
  skillBeingTaught: String,
  skillBeingLearned: String,
  startTime: DateTime?,
  endTime: DateTime?,
  recordingUrl: String?
}
```

### Review
```dart
{
  reviewId: String,
  sessionId: String,
  reviewerId: String,
  revieweeId: String,
  rating: double (1-5),
  feedback: String,
  createdAt: DateTime
}
```

## 🔄 User Flows

### User Registration Flow
```
SignUp Screen
    ↓
Email Validation → Firebase Auth
    ↓
Create User Profile in Firestore
    ↓
Set Initial Skills
    ↓
Home Screen
```

### Connection Flow
```
View User Profile
    ↓
Send Connection Request
    ↓
Create Connection Document (status: pending)
    ↓
Send Notification to Recipient
    ↓
Recipient Accepts/Rejects
    ↓
Update Connection Status
    ↓
Both Users Can Communicate
```

### Chat Flow
```
Open Chat
    ↓
Load Message History
    ↓
Listen to Firestore Updates
    ↓
Real-time Messages
    ↓
Send Message → Save to Firestore
    ↓
Broadcast to Other User
    ↓
Mark as Read
```

### Session Flow
```
Propose Session
    ↓
Create Session Document (status: pending)
    ↓
Send Notification
    ↓
User Accepts/Declines
    ↓
If Accepted: Generate Agora Token
    ↓
Initialize Call
    ↓
Both Users Join Video/Audio
    ↓
End Session
    ↓
Both Users Rate Each Other
    ↓
Update Ratings
```

## 🔐 Security & Privacy

### Authentication
- Firebase Authentication handles secure credential storage
- Tokens managed automatically by Firebase SDK
- No plaintext passwords stored

### Data Access Control
- Firestore security rules enforce access control
- Users can only see profiles of connected users
- Messages only visible to participants
- Sessions only accessible to involved parties

### Notification Privacy
- FCM tokens stored securely
- No sensitive data in notification payloads
- User can disable notifications anytime

### Agora Integration
- App ID never exposed in client code
- Token generation on backend recommended
- Temporary access tokens
- Encrypted communication channels

## 🛠 Development Practices

### Code Organization
- **Screens**: UI only, no business logic
- **Providers**: State management, coordination
- **Services**: Backend integration, data operations
- **Models**: Data structures, serialization
- **Widgets**: Reusable UI components
- **Config**: App configuration, theme, routes

### Naming Conventions
- Classes: PascalCase (e.g., `UserProfile`)
- Functions/variables: camelCase (e.g., `getUserProfile`)
- Constants: UPPER_SNAKE_CASE (e.g., `DEFAULT_TIMEOUT`)
- Files: snake_case (e.g., `user_profile.dart`)

### Error Handling
- All async operations wrapped in try-catch
- User-friendly error messages
- Logging for debugging
- Graceful fallbacks

### Testing Strategy
- Unit tests for models and utilities
- Widget tests for UI components
- Integration tests for features
- Firebase emulator for testing

## 🚀 Performance Optimization

### Caching
- User profiles cached locally with Hive
- Chat messages paginated
- Images cached with cached_network_image

### Database Optimization
- Firestore indexes for common queries
- Pagination for large result sets
- Selective field loading

### Network Optimization
- Connection timeout: 30 seconds
- Lazy loading of images
- Compression for file uploads
- Efficient data structures

## 📊 Analytics & Monitoring

### Key Metrics to Track
- User registration funnel
- Connection request acceptance rate
- Session completion rate
- User rating distribution
- Feature usage

### Firebase Analytics
- Custom events for key actions
- User properties (skills, language)
- Session tracking
- Crash reporting

## 🔔 Notification Strategy

### Push Notifications
- Connection requests
- Session reminders (30 min before)
- Message notifications
- New match suggestions

### In-App Notifications
- Snackbars for immediate feedback
- Dialog boxes for important messages
- Toast notifications for confirmations

## 📱 Platform Considerations

### Android
- Minimum SDK: 21
- Target SDK: Latest (34+)
- Material Design 3
- Gesture navigation support

### iOS
- Minimum deployment: 11.0
- Safe area handling
- App Transport Security
- Privacy manifest

### Web
- Responsive design
- Progressive Web App ready
- Keyboard navigation
- Accessibility (WCAG 2.1)

## 🎓 Learning Resources

### Flutter
- [Official Documentation](https://flutter.dev/docs)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Awesome Flutter](https://github.com/Solido/awesome-flutter)

### Firebase
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com)

### Real-time Communication
- [Agora Documentation](https://docs.agora.io/)
- [WebRTC Fundamentals](https://www.html5rocks.com/en/tutorials/webrtc/basics/)

## 🐛 Known Issues & Limitations

### Current Limitations
1. Agora integration is UI-ready but needs token generation backend
2. File sharing UI needs completion
3. Advanced search/filtering not implemented
4. Offline mode not supported
5. No call recording implementation yet

### Future Improvements
1. End-to-end encryption for messages
2. Peer-to-peer messaging option
3. Session transcription
4. AI skill recommendations
5. Verified skill badges
6. Gamification features

## 📝 Contributing Guidelines

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/feature-name`
3. Follow the code style and architecture
4. Write tests for new features
5. Commit with clear messages
6. Push and create a Pull Request

## 📄 License

MIT License - Feel free to use for personal and commercial projects.

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check existing documentation
- Review the troubleshooting guide

---

**Last Updated**: March 2026
**Version**: 1.0.0 (MVP)
**Status**: Active Development
