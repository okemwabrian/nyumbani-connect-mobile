import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../providers/app_state.dart';
import '../providers/theme_provider.dart';
import '../screens/welcome_screen.dart';
import '../screens/common/profile_screen.dart';
import '../screens/common/settings_screen.dart';
import '../screens/common/notifications_screen.dart';
import '../screens/common/invite_friend_screen.dart';
import '../services/session_service.dart';
import '../screens/navigation/worker_nav.dart';
import '../screens/navigation/employer_nav.dart';
import '../screens/navigation/agent_nav.dart';

class AppDrawer extends StatelessWidget {
  final String role;

  const AppDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryTeal,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
            ),
            accountName: Text(
              appState.phone ?? themeProvider.translate('user'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            accountEmail: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                role.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 45, color: AppColors.primaryTeal),
            ),
          ),

          // --- HOME / DASHBOARD BUTTON ---
          _drawerItem(
            context, 
            Icons.home_rounded, 
            themeProvider.translate('home'), 
            () {
              Widget nextScreen;
              if (role == 'worker') {
                nextScreen = WorkerNav(phone: appState.phone ?? "");
              } else if (role == 'agent') {
                nextScreen = const AgentNav();
              } else {
                nextScreen = EmployerNav(phone: appState.phone ?? "");
              }
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => nextScreen), (r) => false);
            }
          ),
          
          _drawerItem(
            context, 
            Icons.person_outline_rounded, 
            themeProvider.translate('profile'), 
            () {
              Navigator.pop(context); 
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(role: role)));
            }
          ),
          
          _drawerItem(
            context, 
            Icons.notifications_none_rounded, 
            themeProvider.translate('notifications'), 
            () {
              Navigator.pop(context); 
              Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen(role: role)));
            }
          ),
          
          _drawerItem(
            context, 
            Icons.settings_outlined, 
            themeProvider.translate('settings'), 
            () {
              Navigator.pop(context); 
              Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(role: role)));
            }
          ),

          _drawerItem(
            context, 
            Icons.share_rounded, 
            themeProvider.translate('invite'), 
            () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InviteFriendScreen()));
            }
          ),

          const Spacer(),
          const Divider(indent: 20, endIndent: 20),
          _drawerItem(
            context,
            Icons.logout_rounded,
            themeProvider.translate('logout'),
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
          color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}
