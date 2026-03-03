import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? bio;
  final List<String> teachSkills;
  final List<String> learnSkills;
  final List<String> languagesSpoken;
  final Map<String, bool> communicationPreferences; // chat, audio, video
  final double rating;
  final int sessionsCompleted;
  final DateTime createdAt;
  final DateTime lastSeen;
  final bool isOnline;
  final String status; // online, offline, away

  User({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.bio,
    this.teachSkills = const [],
    this.learnSkills = const [],
    this.languagesSpoken = const [],
    this.communicationPreferences = const {'chat': true, 'audio': true, 'video': true},
    this.rating = 0.0,
    this.sessionsCompleted = 0,
    required this.createdAt,
    required this.lastSeen,
    this.isOnline = false,
    this.status = 'offline',
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      bio: map['bio'],
      teachSkills: List<String>.from(map['teachSkills'] ?? []),
      learnSkills: List<String>.from(map['learnSkills'] ?? []),
      languagesSpoken: List<String>.from(map['languagesSpoken'] ?? []),
      communicationPreferences: Map<String, bool>.from(map['communicationPreferences'] ?? {'chat': true, 'audio': true, 'video': true}),
      rating: (map['rating'] ?? 0.0).toDouble(),
      sessionsCompleted: map['sessionsCompleted'] ?? 0,
      createdAt: map['createdAt'] is Timestamp ? map['createdAt'].toDate() : DateTime.parse(map['createdAt']),
      lastSeen: map['lastSeen'] is Timestamp ? map['lastSeen'].toDate() : DateTime.parse(map['lastSeen']),
      isOnline: map['isOnline'] ?? false,
      status: map['status'] ?? 'offline',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'teachSkills': teachSkills,
      'learnSkills': learnSkills,
      'languagesSpoken': languagesSpoken,
      'communicationPreferences': communicationPreferences,
      'rating': rating,
      'sessionsCompleted': sessionsCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSeen': Timestamp.fromDate(lastSeen),
      'isOnline': isOnline,
      'status': status,
    };
  }

  User copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    String? bio,
    List<String>? teachSkills,
    List<String>? learnSkills,
    List<String>? languagesSpoken,
    Map<String, bool>? communicationPreferences,
    double? rating,
    int? sessionsCompleted,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isOnline,
    String? status,
  }) {
    return User(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      teachSkills: teachSkills ?? this.teachSkills,
      learnSkills: learnSkills ?? this.learnSkills,
      languagesSpoken: languagesSpoken ?? this.languagesSpoken,
      communicationPreferences: communicationPreferences ?? this.communicationPreferences,
      rating: rating ?? this.rating,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
      status: status ?? this.status,
    );
  }
}

class Connection {
  final String connectionId;
  final String userId1;
  final String userId2;
  final String status; // pending, accepted, rejected, blocked
  final Map<String, bool> permissions; // chat, audio, video
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final String initiatedBy;

  Connection({
    required this.connectionId,
    required this.userId1,
    required this.userId2,
    required this.status,
    this.permissions = const {'chat': true, 'audio': true, 'video': true},
    required this.createdAt,
    this.acceptedAt,
    required this.initiatedBy,
  });

  factory Connection.fromMap(Map<String, dynamic> map) {
    return Connection(
      connectionId: map['connectionId'] ?? '',
      userId1: map['userId1'] ?? '',
      userId2: map['userId2'] ?? '',
      status: map['status'] ?? 'pending',
      permissions: Map<String, bool>.from(map['permissions'] ?? {'chat': true, 'audio': true, 'video': true}),
      createdAt: map['createdAt'] is Timestamp ? map['createdAt'].toDate() : DateTime.parse(map['createdAt']),
      acceptedAt: map['acceptedAt'] != null ? (map['acceptedAt'] is Timestamp ? map['acceptedAt'].toDate() : DateTime.parse(map['acceptedAt'])) : null,
      initiatedBy: map['initiatedBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'connectionId': connectionId,
      'userId1': userId1,
      'userId2': userId2,
      'status': status,
      'permissions': permissions,
      'createdAt': Timestamp.fromDate(createdAt),
      'acceptedAt': acceptedAt != null ? Timestamp.fromDate(acceptedAt!) : null,
      'initiatedBy': initiatedBy,
    };
  }
}

class ChatMessage {
  final String messageId;
  final String senderId;
  final String connectionId;
  final String content;
  final String messageType; // text, file, image
  final DateTime timestamp;
  final bool isRead;
  final String? fileUrl;
  final String? fileName;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.connectionId,
    required this.content,
    this.messageType = 'text',
    required this.timestamp,
    this.isRead = false,
    this.fileUrl,
    this.fileName,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      connectionId: map['connectionId'] ?? '',
      content: map['content'] ?? '',
      messageType: map['messageType'] ?? 'text',
      timestamp: map['timestamp'] is Timestamp ? map['timestamp'].toDate() : DateTime.parse(map['timestamp']),
      isRead: map['isRead'] ?? false,
      fileUrl: map['fileUrl'],
      fileName: map['fileName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'connectionId': connectionId,
      'content': content,
      'messageType': messageType,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'fileUrl': fileUrl,
      'fileName': fileName,
    };
  }
}

class SkillSession {
  final String sessionId;
  final String connectionId;
  final String initiatorId;
  final String receiverId;
  final String status; // pending, accepted, in_progress, completed, cancelled
  final DateTime scheduledTime;
  final int durationMinutes;
  final String skillBeingTaught;
  final String skillBeingLearned;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? recordingUrl;

  SkillSession({
    required this.sessionId,
    required this.connectionId,
    required this.initiatorId,
    required this.receiverId,
    this.status = 'pending',
    required this.scheduledTime,
    this.durationMinutes = 30,
    required this.skillBeingTaught,
    required this.skillBeingLearned,
    this.startTime,
    this.endTime,
    this.recordingUrl,
  });

  factory SkillSession.fromMap(Map<String, dynamic> map) {
    return SkillSession(
      sessionId: map['sessionId'] ?? '',
      connectionId: map['connectionId'] ?? '',
      initiatorId: map['initiatorId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      status: map['status'] ?? 'pending',
      scheduledTime: map['scheduledTime'] is Timestamp ? map['scheduledTime'].toDate() : DateTime.parse(map['scheduledTime']),
      durationMinutes: map['durationMinutes'] ?? 30,
      skillBeingTaught: map['skillBeingTaught'] ?? '',
      skillBeingLearned: map['skillBeingLearned'] ?? '',
      startTime: map['startTime'] != null ? (map['startTime'] is Timestamp ? map['startTime'].toDate() : DateTime.parse(map['startTime'])) : null,
      endTime: map['endTime'] != null ? (map['endTime'] is Timestamp ? map['endTime'].toDate() : DateTime.parse(map['endTime'])) : null,
      recordingUrl: map['recordingUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'connectionId': connectionId,
      'initiatorId': initiatorId,
      'receiverId': receiverId,
      'status': status,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'durationMinutes': durationMinutes,
      'skillBeingTaught': skillBeingTaught,
      'skillBeingLearned': skillBeingLearned,
      'startTime': startTime != null ? Timestamp.fromDate(startTime!) : null,
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'recordingUrl': recordingUrl,
    };
  }
}

class Review {
  final String reviewId;
  final String sessionId;
  final String reviewerId;
  final String revieweeId;
  final double rating;
  final String feedback;
  final DateTime createdAt;

  Review({
    required this.reviewId,
    required this.sessionId,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    required this.feedback,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      reviewId: map['reviewId'] ?? '',
      sessionId: map['sessionId'] ?? '',
      reviewerId: map['reviewerId'] ?? '',
      revieweeId: map['revieweeId'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      feedback: map['feedback'] ?? '',
      createdAt: map['createdAt'] is Timestamp ? map['createdAt'].toDate() : DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'sessionId': sessionId,
      'reviewerId': reviewerId,
      'revieweeId': revieweeId,
      'rating': rating,
      'feedback': feedback,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
