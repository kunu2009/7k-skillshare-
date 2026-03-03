import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final _auth = fb.FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  // Get auth state changes
  static Stream<fb.User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  // Sign up with email and password
  static Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(displayName);

      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'displayName': displayName,
        'email': email,
        'photoUrl': null,
        'bio': null,
        'teachSkills': [],
        'learnSkills': [],
        'languagesSpoken': [],
        'communicationPreferences': {'chat': true, 'audio': true, 'video': true},
        'rating': 0.0,
        'sessionsCompleted': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'lastSeen': FieldValue.serverTimestamp(),
        'isOnline': true,
        'status': 'online',
      });

      return true;
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with email and password
  static Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last seen
      await _firestore.collection('users').doc(userCredential.user!.uid).update({
        'lastSeen': FieldValue.serverTimestamp(),
        'isOnline': true,
        'status': 'online',
      });

      return true;
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Update offline status
        await _firestore.collection('users').doc(currentUser.uid).update({
          'isOnline': false,
          'status': 'offline',
          'lastSeen': FieldValue.serverTimestamp(),
        });
      }
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Get current user
  static fb.User? get currentUser {
    return _auth.currentUser;
  }

  // Update user profile
  static Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? photoUrl,
    String? bio,
    List<String>? teachSkills,
    List<String>? learnSkills,
    List<String>? languagesSpoken,
    Map<String, bool>? communicationPreferences,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (displayName != null) updateData['displayName'] = displayName;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;
      if (bio != null) updateData['bio'] = bio;
      if (teachSkills != null) updateData['teachSkills'] = teachSkills;
      if (learnSkills != null) updateData['learnSkills'] = learnSkills;
      if (languagesSpoken != null) updateData['languagesSpoken'] = languagesSpoken;
      if (communicationPreferences != null) {
        updateData['communicationPreferences'] = communicationPreferences;
      }

      await _firestore.collection('users').doc(uid).update(updateData);
    } catch (e) {
      throw Exception('Update profile failed: $e');
    }
  }

  // Helper method to handle auth exceptions
  static String _handleAuthException(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}
