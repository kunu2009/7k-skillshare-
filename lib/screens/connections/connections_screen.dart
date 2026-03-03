import 'package:flutter/material.dart';

class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connections'),
      ),
      body: Center(
        child: Text('Connections Screen'),
      ),
    );
  }
}
