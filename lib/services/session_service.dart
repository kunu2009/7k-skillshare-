import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillswap/models/models.dart';

class SessionService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new skill session
  static Future<SkillSession?> createSession({
    required String connectionId,
    required String initiatorId,
    required String receiverId,
    required DateTime scheduledTime,
    required String skillBeingTaught,
    required String skillBeingLearned,
    int durationMinutes = 30,
  }) async {
    try {
      final sessionId = _firestore.collection('sessions').doc().id;
      final session = SkillSession(
        sessionId: sessionId,
        connectionId: connectionId,
        initiatorId: initiatorId,
        receiverId: receiverId,
        status: 'pending',
        scheduledTime: scheduledTime,
        durationMinutes: durationMinutes,
        skillBeingTaught: skillBeingTaught,
        skillBeingLearned: skillBeingLearned,
      );

      await _firestore.collection('sessions').doc(sessionId).set(session.toMap());
      return session;
    } catch (e) {
      print('Error creating session: $e');
      return null;
    }
  }

  // Get sessions for a user
  static Future<List<SkillSession>> getUserSessions(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('sessions')
          .where('initiatorId', isEqualTo: userId)
          .get();

      final snapshot2 = await _firestore
          .collection('sessions')
          .where('receiverId', isEqualTo: userId)
          .get();

      final allDocs = [...snapshot.docs, ...snapshot2.docs];
      return allDocs
          .map((doc) => SkillSession.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching sessions: $e');
      return [];
    }
  }

  // Accept session request
  static Future<bool> acceptSession(String sessionId) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update({
        'status': 'accepted',
      });
      return true;
    } catch (e) {
      print('Error accepting session: $e');
      return false;
    }
  }

  // Decline session request
  static Future<bool> declineSession(String sessionId) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update({
        'status': 'cancelled',
      });
      return true;
    } catch (e) {
      print('Error declining session: $e');
      return false;
    }
  }

  // Start session
  static Future<bool> startSession(String sessionId) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update({
        'status': 'in_progress',
        'startTime': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print('Error starting session: $e');
      return false;
    }
  }

  // End session
  static Future<bool> endSession(String sessionId) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update({
        'status': 'completed',
        'endTime': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print('Error ending session: $e');
      return false;
    }
  }

  // Get session details
  static Future<SkillSession?> getSession(String sessionId) async {
    try {
      final doc = await _firestore.collection('sessions').doc(sessionId).get();
      if (doc.exists) {
        return SkillSession.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching session: $e');
      return null;
    }
  }

  // Stream of pending sessions for a user
  static Stream<List<SkillSession>> getPendingSessionsStream(String userId) {
    return _firestore
        .collection('sessions')
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SkillSession.fromMap(doc.data()))
            .toList());
  }
}
