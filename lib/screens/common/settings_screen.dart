import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/profile_screen.dart';
import '../welcome_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String role;

  const SettingsScreen({super.key, required this.role});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
    await prefs.setBool('notifications', notificationsEnabled);
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),

      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // 🔥 ACCOUNT SECTION
          const Text(
            "Account",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F3E6E),
            ),
          ),
          const SizedBox(height: 10),

          _tile(
            icon: Icons.person,
            title: "View Profile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(role: widget.role),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // 🔥 PREFERENCES
          const Text(
            "Preferences",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F3E6E),
            ),
          ),
          const SizedBox(height: 10),

          _switchTile(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            value: isDarkMode,
            onChanged: (val) {
              setState(() => isDarkMode = val);
              _saveSettings();
            },
          ),

          _switchTile(
            icon: Icons.notifications,
            title: "Notifications",
            value: notificationsEnabled,
            onChanged: (val) {
              setState(() => notificationsEnabled = val);
              _saveSettings();
            },
          ),

          const SizedBox(height: 20),

          // 🔥 ACTIONS
          const Text(
            "Actions",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F3E6E),
            ),
          ),
          const SizedBox(height: 10),

          _tile(
            icon: Icons.logout,
            title: "Logout",
            color: Colors.red,
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = const Color(0xFF2F3E6E),
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Colors.white,
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      secondary: Icon(icon, color: const Color(0xFF2F3E6E)),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}