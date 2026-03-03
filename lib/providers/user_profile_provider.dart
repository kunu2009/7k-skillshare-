import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillswap/models/models.dart';

class UserProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _userProfile;
  bool _isLoading = false;
  String? _error;
  List<User> _suggestedMatches = [];

  User? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<User> get suggestedMatches => _suggestedMatches;

  Future<void> fetchUserProfile(String uid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userProfile = User.fromMap(doc.data() as Map<String, dynamic>);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? photoUrl,
    String? bio,
    List<String>? teachSkills,
    List<String>? learnSkills,
    List<String>? languagesSpoken,
    Map<String, bool>? communicationPreferences,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

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
      await fetchUserProfile(uid);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSuggestedMatches(String uid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get current user's data
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists) return;

      final user = User.fromMap(userDoc.data() as Map<String, dynamic>);

      // Find users whose teach skills match with current user's learn skills
      final snapshot = await _firestore
          .collection('users')
          .where('teachSkills', arrayContainsAny: user.learnSkills)
          .limit(10)
          .get();

      _suggestedMatches = snapshot.docs
          .map((doc) => User.fromMap(doc.data()))
          .where((suggestedUser) => suggestedUser.uid != uid)
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  Future<List<User>> searchUsers({
    String? skillKeyword,
    List<String>? teachingSkills,
    String? language,
  }) async {
    try {
      Query query = _firestore.collection('users');

      if (teachingSkills != null && teachingSkills.isNotEmpty) {
        query = query.where('teachSkills', arrayContainsAny: teachingSkills);
      }

      final snapshot = await query.limit(20).get();
      return snapshot.docs
          .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }

  Future<void> setUserOnlineStatus(String uid, bool isOnline) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isOnline': isOnline,
        'status': isOnline ? 'online' : 'offline',
        'lastSeen': Timestamp.now(),
      });
    } catch (e) {
      _error = e.toString();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
