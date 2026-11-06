import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/widgets/app_widgets.dart';
import '../core/widgets/bottom_navigation_bar.dart';
import '../data/repositories/auth_repository.dart';
import 'edit_profile_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthRepository();

  Future<void> _signOut() async {
    await _auth.signOut();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Signed out')));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black87),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: 'edit_profile'),
                builder: (_) => const EditProfileScreen(),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: _auth.userChanges,
        initialData: _auth.currentUser,
        builder: (context, snapshot) {
          final user = snapshot.data;
          final name = (user?.displayName?.trim().isNotEmpty ?? false)
              ? user!.displayName!
              : 'User';
          final email = user?.email ?? '';
          final photo = user?.photoURL;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const SizedBox(height: 12),
                CircleAvatar(
                  radius: 48,
                  backgroundColor: const Color(0xFFEFE7F8),
                  backgroundImage: (photo != null && photo.isNotEmpty)
                      ? NetworkImage(photo) as ImageProvider
                      : const AssetImage('assets/images/5.png'),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style:
                  const TextStyle(fontSize: 13, color: Color(0xFF7A7A7A)),
                ),
                const SizedBox(height: 24),

                // Статистика
                const Row(
                  children: [
                    Expanded(child: _StatCard(value: '5', label: 'Return')),
                    SizedBox(width: 12),
                    Expanded(child: _StatCard(value: '4', label: 'Pick up')),
                  ],
                ),
                const SizedBox(height: 24),

                ProfileMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                ProfileMenuItem(
                  icon: Icons.translate,
                  title: 'Language',
                  trailing: 'English',
                  //onTap: () {},
                  onTap: () => FirebaseCrashlytics.instance.crash(),
                ),
                const SizedBox(height: 12),
                ProfileMenuItem(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  isDestructive: true,
                  onTap: _signOut,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Borrowed Items Manager · v1.0',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1,
        onHomeTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EBF4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A7A))),
        ],
      ),
    );
  }
}