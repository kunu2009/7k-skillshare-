import 'package:flutter/material.dart';

class CallScreen extends StatelessWidget {
  final String connectionId;

  const CallScreen({
    Key? key,
    required this.connectionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call'),
      ),
      body: Center(
        child: Text('Call Screen - $connectionId'),
      ),
    );
  }
}
