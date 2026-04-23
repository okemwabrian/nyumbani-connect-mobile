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
          Container(
            height: 140,
            width: double.infinity,
            color: const Color(0xFF2F3E6E),
            alignment: Alignment.center,
            child: const Text(
              "Nyumbani Connect",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          _item(context, Icons.home, "Home", () {
            Navigator.pop(context);
          }),

          _item(context, Icons.person, "Profile", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(role: role),
              ),
            );
          }),
          _item(context, Icons.notifications, "Notifications", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotificationsScreen(role: role),
              ),
            );
          }),
          _item(context, Icons.work, "Jobs", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => JobTrackingScreen(role: role),
              ),
            );
          }),

        _item(context, Icons.settings, "Settings", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SettingsScreen(role: role),
            ),
          );
        }),

          const Divider(),

          _item(context, Icons.logout, "Logout", () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
            );
          }),
        ],
      ),
    );
  }

  Widget _item(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
