import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skillswap/providers/auth_provider.dart';
import 'package:skillswap/providers/user_profile_provider.dart';
import 'package:skillswap/providers/connection_provider.dart';
import 'package:skillswap/config/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final authProvider = context.read<AuthProvider>();
    final userProfileProvider = context.read<UserProfileProvider>();
    final connectionProvider = context.read<ConnectionProvider>();

    if (authProvider.currentUser != null) {
      final userId = authProvider.currentUser!.uid;
      userProfileProvider.fetchUserProfile(userId);
      userProfileProvider.fetchSuggestedMatches(userId);
      connectionProvider.fetchConnections(userId);
      connectionProvider.fetchPendingRequests(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildFeedTab();
      case 1:
        return _buildExploreTab();
      case 2:
        return _buildChatsTab();
      case 3:
        return _buildProfileTab();
      default:
        return Container();
    }
  }

  Widget _buildFeedTab() {
    final userProfileProvider = context.read<UserProfileProvider>();
    final authProvider = context.read<AuthProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      authProvider.currentUser?.displayName ?? 'User',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => context.push('/home/profile/${authProvider.currentUser?.uid}'),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: authProvider.currentUser?.photoUrl != null
                        ? NetworkImage(authProvider.currentUser!.photoUrl!)
                        : null,
                    child: authProvider.currentUser?.photoUrl == null
                        ? Icon(Icons.person)
                        : null,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.xl),

            // Suggested Matches Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Suggested Matches',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _selectedIndex = 1),
                  child: Text('See All'),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.md),

            FutureBuilder(
              future: Future.value(userProfileProvider.suggestedMatches),
              builder: (context, snapshot) {
                if (userProfileProvider.suggestedMatches.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Text(
                        'No matches yet. Update your skills to see suggestions.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: userProfileProvider.suggestedMatches.length,
                  separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final user = userProfileProvider.suggestedMatches[index];
                    return _buildUserCard(user);
                  },
                );
              },
            ),

            SizedBox(height: AppSpacing.xl),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.people_outline,
                    label: 'Connections',
                    onTap: () => context.push('/home/connections'),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.notifications_active_outlined,
                    label: 'Requests',
                    onTap: () => context.push('/home/connection-requests'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Explore',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // Search Bar
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search skills or people',
                prefixIcon: Icon(Icons.search),
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            Text(
              'Popular Skills',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: AppSpacing.md),

            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                'Programming',
                'Music',
                'Languages',
                'Design',
                'Fitness',
                'Cooking',
                'Writing',
                'Photography',
              ].map((skill) => Chip(label: Text(skill))).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatsTab() {
    return SafeArea(
      child: Column(
        children: [
          AppBar(
            title: Text('Messages'),
            elevation: 0,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_outline,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final authProvider = context.read<AuthProvider>();
    final userProfileProvider = context.read<UserProfileProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Profile',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: authProvider.currentUser?.photoUrl != null
                        ? NetworkImage(authProvider.currentUser!.photoUrl!)
                        : null,
                    child: authProvider.currentUser?.photoUrl == null
                        ? Icon(Icons.person, size: 50)
                        : null,
                  ),

                  SizedBox(height: AppSpacing.lg),

                  Text(
                    authProvider.currentUser?.displayName ?? 'User',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: AppSpacing.sm),

                  Text(
                    authProvider.currentUser?.email ?? '',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () => context.push('/home/edit-profile'),
              child: Text('Edit Profile'),
            ),

            SizedBox(height: AppSpacing.xl),

            // Menu Items
            _buildMenuItemButton(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () {},
            ),

            _buildMenuItemButton(
              icon: Icons.help_outline,
              label: 'Help & Support',
              onTap: () {},
            ),

            _buildMenuItemButton(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Policy',
              onTap: () {},
            ),

            SizedBox(height: AppSpacing.xl),

            // Sign Out Button
            ElevatedButton.icon(
              onPressed: () async {
                await context.read<AuthProvider>().signOut();
                if (mounted) {
                  context.go('/login');
                }
              },
              icon: Icon(Icons.logout),
              label: Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(dynamic user) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: user.photoUrl != null
                    ? NetworkImage(user.photoUrl!)
                    : null,
                child: user.photoUrl == null ? Icon(Icons.person) : null,
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Rating: ${user.rating.toStringAsFixed(1)} ⭐',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          Text(
            'Can teach: ${user.teachSkills.join(', ')}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: AppSpacing.md),

          ElevatedButton(
            onPressed: () {},
            child: Text('Connect'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primaryColor),
            SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(label),
              ),
              Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          activeIcon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_outlined),
          activeIcon: Icon(Icons.chat),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
