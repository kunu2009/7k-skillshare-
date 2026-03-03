import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillswap/config/app_theme.dart';
import 'package:skillswap/providers/auth_provider.dart';
import 'package:skillswap/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, authProvider, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Theme Section
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appearance',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.dark_mode),
                          title: Text('Dark Mode'),
                          trailing: Switch(
                            value: themeProvider.isDarkMode,
                            onChanged: (_) => themeProvider.toggleTheme(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(),

                // Account Section
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.email),
                              title: Text('Email'),
                              subtitle:
                                  Text(authProvider.currentUser?.email ?? 'N/A'),
                            ),
                            Divider(height: 0),
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text('Profile'),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                context.push(
                                    '/profile/${authProvider.currentUser?.uid}');
                              },
                            ),
                            Divider(height: 0),
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit Profile'),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                context.push('/profile/edit');
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(),

                // App Section
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.info),
                              title: Text('About'),
                              subtitle: Text('Version 1.0.0'),
                            ),
                            Divider(height: 0),
                            ListTile(
                              leading: Icon(Icons.help),
                              title: Text('Help & Support'),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Help & FAQ'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'How to find users?',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            'Go to Explore and search for users by name or skill.'),
                                        SizedBox(height: AppSpacing.md),
                                        Text(
                                          'How to send connection requests?',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            'Find a user and tap "Connect" button.'),
                                        SizedBox(height: AppSpacing.md),
                                        Text(
                                          'How to chat?',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            'Go to Connections and select a user to message.'),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Divider(height: 0),
                            ListTile(
                              leading: Icon(Icons.privacy_tip),
                              title: Text('Privacy Policy'),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Privacy Policy'),
                                    content: Text(
                                        'Your data is secure and encrypted. We never share your information with third parties.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(),

                // Sign Out
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Sign Out?'),
                          content:
                              Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await authProvider.signOut();
                                if (context.mounted) {
                                  context.go('/login');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.errorColor,
                              ),
                              child: Text('Sign Out'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.logout),
                    label: Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorColor,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}
