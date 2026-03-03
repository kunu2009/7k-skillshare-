import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillswap/models/models.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of auth changes
  static Stream<User?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        return User.fromMap(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Sign up with email and password
  static Future<User?> signUpWithEmail({
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

      final newUser = User(
        uid: userCredential.user!.uid,
        displayName: displayName,
        email: email,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
      );

      await _firestore.collection('users').doc(newUser.uid).set(newUser.toMap());

      return newUser;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with email and password
  static Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (userDoc.exists) {
        final user = User.fromMap(userDoc.data() as Map<String, dynamic>);

        // Update last seen
        await _firestore.collection('users').doc(user.uid).update({
          'lastSeen': Timestamp.now(),
          'isOnline': true,
          'status': 'online',
        });

        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
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
          'lastSeen': Timestamp.now(),
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
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Get current user
  static User? get currentUser {
    final firebaseUser = _auth.currentUser;
    return firebaseUser != null ? _mapFirebaseUserToUser(firebaseUser) : null;
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
      if (communicationPreferences != null) updateData['communicationPreferences'] = communicationPreferences;

      await _firestore.collection('users').doc(uid).update(updateData);
    } catch (e) {
      throw Exception('Update profile failed: $e');
    }
  }

  // Helper method to handle auth exceptions
  static String _handleAuthException(FirebaseAuthException e) {
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

  // Helper to map Firebase user to our User model
  static User _mapFirebaseUserToUser(User firebaseUser) {
    return User(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoUrl,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      lastSeen: DateTime.now(),
    );
  }
}
