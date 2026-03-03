import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String connectionId;

  const ChatScreen({
    Key? key,
    required this.connectionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Center(
        child: Text('Chat Screen - $connectionId'),
      ),
    );
  }
}
