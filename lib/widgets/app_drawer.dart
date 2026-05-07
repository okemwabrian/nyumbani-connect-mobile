import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../providers/app_state.dart';
import '../screens/welcome_screen.dart';
import '../services/session_service.dart';

class AppDrawer extends StatelessWidget {
  final String role;

  const AppDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Drawer(
      backgroundColor: AppColors.bgPale,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryTeal),
            accountName: Text(
              appState.phone ?? "User",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.tertiaryOlive.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                role.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 45, color: AppColors.primaryTeal),
            ),
          ),

          _drawerItem(context, Icons.home_rounded, "Dashboard", () => Navigator.pop(context)),
          _drawerItem(context, Icons.person_outline_rounded, "Profile", () {}),
          _drawerItem(context, Icons.notifications_none_rounded, "Notifications", () {}),
          _drawerItem(context, Icons.settings_outlined, "Settings", () {}),

          const Spacer(),
          const Divider(indent: 20, endIndent: 20),
          _drawerItem(
            context,
            Icons.logout_rounded,
            "Logout",
            () async {
              await SessionService.logout();
              appState.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            },
            color: Colors.redAccent
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primaryTeal),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? AppColors.textDark,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}
