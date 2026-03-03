import 'package:flutter/material.dart';

class ConnectionRequestsScreen extends StatelessWidget {
  const ConnectionRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connection Requests'),
      ),
      body: Center(
        child: Text('Connection Requests Screen'),
      ),
    );
  }
}
