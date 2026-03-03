import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/providers/auth_provider.dart';
import 'package:provider/provider.dart';

// Screens
import 'package:skillswap/screens/auth/login_screen.dart';
import 'package:skillswap/screens/auth/signup_screen.dart';
import 'package:skillswap/screens/auth/forgot_password_screen.dart';
import 'package:skillswap/screens/home/home_screen.dart';
import 'package:skillswap/screens/home/explore_screen.dart';
import 'package:skillswap/screens/profile/profile_screen.dart';
import 'package:skillswap/screens/profile/edit_profile_screen.dart';
import 'package:skillswap/screens/connections/connections_screen.dart';
import 'package:skillswap/screens/connections/connection_requests_screen.dart';
import 'package:skillswap/screens/chat/chat_list_screen.dart';
import 'package:skillswap/screens/chat/chat_screen.dart';
import 'package:skillswap/screens/call/call_screen.dart';
import 'package:skillswap/screens/settings/settings_screen.dart';
import 'package:skillswap/screens/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final authProvider = context.read<AuthProvider>();
      final isAuthenticated = authProvider.isAuthenticated;
      final isAuthScreen = state.uri.path.startsWith('/login') ||
          state.uri.path.startsWith('/signup') ||
          state.uri.path.startsWith('/forgot-password');

      if (!isAuthenticated && !isAuthScreen) {
        return '/login';
      }

      if (isAuthenticated && isAuthScreen) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'explore',
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: 'profile/:uid',
            builder: (context, state) {
              final uid = state.pathParameters['uid']!;
              return ProfileScreen(userId: uid);
            },
          ),
          GoRoute(
            path: 'edit-profile',
            builder: (context, state) => const EditProfileScreen(),
          ),
          GoRoute(
            path: 'connections',
            builder: (context, state) => const ConnectionsScreen(),
          ),
          GoRoute(
            path: 'connection-requests',
            builder: (context, state) => const ConnectionRequestsScreen(),
          ),
          GoRoute(
            path: 'chats',
            builder: (context, state) => const ChatListScreen(),
          ),
          GoRoute(
            path: 'chat/:connectionId',
            builder: (context, state) {
              final connectionId = state.pathParameters['connectionId']!;
              return ChatScreen(connectionId: connectionId);
            },
          ),
          GoRoute(
            path: 'call/:connectionId',
            builder: (context, state) {
              final connectionId = state.pathParameters['connectionId']!;
              return CallScreen(connectionId: connectionId);
            },
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
