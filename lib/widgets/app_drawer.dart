import 'package:flutter/material.dart';
import '../screens/common/profile_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/common/job_tracking_screen.dart';
import '../screens/common/notifications_screen.dart';
import '../screens/common/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  final String role;

  const AppDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // 🔥 HEADER
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A8A),
            ),
            accountName: const Text(
              "John Doe",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              role.toUpperCase(),
              style: const TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF1E3A8A)),
            ),
          ),

          _item(context, Icons.home, "Home", () {
            Navigator.pop(context);
          }),

          _item(context, Icons.person, "Profile", () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(role: role),
              ),
            );
          }),

          _item(context, Icons.notifications, "Notifications", () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotificationsScreen(role: role),
              ),
            );
          }),

          _item(context, Icons.work, "Jobs", () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => JobTrackingScreen(role: role),
              ),
            );
          }),

          _item(context, Icons.settings, "Settings", () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsScreen(role: role),
              ),
            );
          }),

          const Spacer(),
          const Divider(),

          _item(
            context,
            Icons.logout,
            "Logout",
                () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (route) => false,
              );
            },
            color: Colors.red,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _item(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap, {
        Color? color,
      }) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF1E3A8A)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}