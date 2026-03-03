import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillswap/models/models.dart';

class ConnectionProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Connection> _connections = [];
  List<Connection> _pendingRequests = [];
  bool _isLoading = false;
  String? _error;

  List<Connection> get connections => _connections;
  List<Connection> get pendingRequests => _pendingRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchConnections(String uid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('connections')
          .where('userId1', isEqualTo: uid)
          .get();

      final snapshot2 = await _firestore
          .collection('connections')
          .where('userId2', isEqualTo: uid)
          .get();

      final allDocs = [...snapshot.docs, ...snapshot2.docs];
      _connections = allDocs
          .map((doc) => Connection.fromMap(doc.data()))
          .where((conn) => conn.status == 'accepted')
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPendingRequests(String uid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('connections')
          .where('userId2', isEqualTo: uid)
          .where('status', isEqualTo: 'pending')
          .get();

      _pendingRequests = snapshot.docs
          .map((doc) => Connection.fromMap(doc.data()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendConnectionRequest({
    required String userId1,
    required String userId2,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final connectionId = _firestore.collection('connections').doc().id;
      final connection = Connection(
        connectionId: connectionId,
        userId1: userId1,
        userId2: userId2,
        status: 'pending',
        createdAt: DateTime.now(),
        initiatedBy: userId1,
      );

      await _firestore
          .collection('connections')
          .doc(connectionId)
          .set(connection.toMap());

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> acceptConnectionRequest(String connectionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestore.collection('connections').doc(connectionId).update({
        'status': 'accepted',
        'acceptedAt': Timestamp.now(),
      });

      _pendingRequests.removeWhere((conn) => conn.connectionId == connectionId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> rejectConnectionRequest(String connectionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestore.collection('connections').doc(connectionId).update({
        'status': 'rejected',
      });

      _pendingRequests.removeWhere((conn) => conn.connectionId == connectionId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateConnectionPermissions({
    required String connectionId,
    required Map<String, bool> permissions,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestore
          .collection('connections')
          .doc(connectionId)
          .update({'permissions': permissions});

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> blockUser({
    required String connectionId,
  }) async {
    try {
      await _firestore.collection('connections').doc(connectionId).update({
        'status': 'blocked',
      });
      _connections.removeWhere((conn) => conn.connectionId == connectionId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  Future<Connection?> getConnection(String userId1, String userId2) async {
    try {
      var snapshot = await _firestore
          .collection('connections')
          .where('userId1', isEqualTo: userId1)
          .where('userId2', isEqualTo: userId2)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Connection.fromMap(snapshot.docs.first.data());
      }

      snapshot = await _firestore
          .collection('connections')
          .where('userId1', isEqualTo: userId2)
          .where('userId2', isEqualTo: userId1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Connection.fromMap(snapshot.docs.first.data());
      }

      return null;
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
