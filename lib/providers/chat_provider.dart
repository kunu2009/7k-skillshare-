import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillswap/models/models.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Stream of messages for a connection
  Stream<List<ChatMessage>> getMessagesStream(String connectionId) {
    return _firestore
        .collection('chats')
        .doc(connectionId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }

  Future<void> fetchMessages(String connectionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('chats')
          .doc(connectionId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      _messages = snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendMessage({
    required String connectionId,
    required String senderId,
    required String content,
    String messageType = 'text',
    String? fileUrl,
    String? fileName,
  }) async {
    try {
      final messageId = _firestore
          .collection('chats')
          .doc(connectionId)
          .collection('messages')
          .doc()
          .id;

      final message = ChatMessage(
        messageId: messageId,
        senderId: senderId,
        connectionId: connectionId,
        content: content,
        messageType: messageType,
        timestamp: DateTime.now(),
        isRead: false,
        fileUrl: fileUrl,
        fileName: fileName,
      );

      await _firestore
          .collection('chats')
          .doc(connectionId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());

      // Update chat room last message
      await _firestore.collection('chats').doc(connectionId).update({
        'lastMessage': content,
        'lastMessageTime': Timestamp.now(),
        'lastMessageSenderId': senderId,
      });

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> markMessageAsRead({
    required String connectionId,
    required String messageId,
  }) async {
    try {
      await _firestore
          .collection('chats')
          .doc(connectionId)
          .collection('messages')
          .doc(messageId)
          .update({'isRead': true});

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  Future<bool> deleteMessage({
    required String connectionId,
    required String messageId,
  }) async {
    try {
      await _firestore
          .collection('chats')
          .doc(connectionId)
          .collection('messages')
          .doc(messageId)
          .delete();

      _messages.removeWhere((msg) => msg.messageId == messageId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  Future<List<ChatMessage>> getUnreadMessages(String userId) async {
    try {
      final snapshot = await _firestore
          .collectionGroup('messages')
          .where('isRead', isEqualTo: false)
          .get();

      return snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data()))
          .toList();
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
