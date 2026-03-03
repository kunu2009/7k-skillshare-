import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skillswap/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  void _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF10B981),
                  ],
                ),
              ),
              child: Icon(
                Icons.swap_horiz,
                color: Colors.white,
                size: 50,
              ),
            ),
            SizedBox(height: 24),

            // App Name
            Text(
              'SkillSwap',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),

            SizedBox(height: 8),

            // Tagline
            Text(
              'Learn Anything. Teach Everything.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 48),

            // Loading Indicator
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF6366F1),
                ),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
