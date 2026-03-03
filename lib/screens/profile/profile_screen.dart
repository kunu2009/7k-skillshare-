import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('User Profile Screen - $userId'),
      ),
    );
  }
}
