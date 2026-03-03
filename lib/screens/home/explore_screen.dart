import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:skillswap/config/app_theme.dart';
import 'package:skillswap/providers/auth_provider.dart';
import 'package:skillswap/models/models.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'all'; // all, teach, learn
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Users'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or skill...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                FilterChip(
                  label: Text('All Users'),
                  selected: _selectedFilter == 'all',
                  onSelected: (selected) =>
                      setState(() => _selectedFilter = 'all'),
                ),
                SizedBox(width: AppSpacing.sm),
                FilterChip(
                  label: Text('Teachers'),
                  selected: _selectedFilter == 'teach',
                  onSelected: (selected) =>
                      setState(() => _selectedFilter = 'teach'),
                ),
                SizedBox(width: AppSpacing.sm),
                FilterChip(
                  label: Text('Learners'),
                  selected: _selectedFilter == 'learn',
                  onSelected: (selected) =>
                      setState(() => _selectedFilter = 'learn'),
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // User List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildQuery(currentUser?.uid ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No users found'));
                }

                final users = snapshot.data!.docs
                    .map((doc) =>
                        User.fromMap(doc.data() as Map<String, dynamic>))
                    .where((user) => user.uid != currentUser?.uid)
                    .toList();

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return _buildUserCard(user);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _buildQuery(String currentUserId) {
    Query query = _firestore.collection('users');

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      query = query.where('displayName',
          isGreaterThanOrEqualTo: searchTerm)
          .where('displayName',
              isLessThan: searchTerm + 'z');
    }

    return query.snapshots();
  }

  Widget _buildUserCard(User user) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.photoUrl != null
              ? NetworkImage(user.photoUrl!)
              : null,
          child: user.photoUrl == null
              ? Icon(Icons.person)
              : null,
        ),
        title: Text(user.displayName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.xs),
            if (user.teachSkills.isNotEmpty)
              Text(
                '👨‍🏫 Teaches: ${user.teachSkills.join(', ')}',
                style: TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (user.learnSkills.isNotEmpty)
              Text(
                '👨‍🎓 Learns: ${user.learnSkills.join(', ')}',
                style: TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: ElevatedButton.icon(
          onPressed: () {
            // Show connection options
            _showConnectionOptions(user);
          },
          icon: Icon(Icons.add),
          label: Text('Connect'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
          ),
        ),
      ),
    );
  }

  void _showConnectionOptions(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connect with ${user.displayName}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Teach Skills: ${user.teachSkills.join(", ")}'),
            SizedBox(height: AppSpacing.sm),
            Text('Learn Skills: ${user.learnSkills.join(", ")}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Send connection request
              context.read<AuthProvider>();
              // TODO: Implement connection request logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Connection request sent!')),
              );
            },
            child: Text('Send Request'),
          ),
        ],
      ),
    );
  }
}
