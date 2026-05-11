import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../screens/welcome_screen.dart';

class NyumbaniLayout extends StatelessWidget {
  final Widget body;
  final String title;

  const NyumbaniLayout({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      drawer: isMobile ? _Sidebar() : null,
      appBar: isMobile ? AppBar(title: Text(title)) : null,
      body: Row(
        children: [
          if (!isMobile) _Sidebar(),
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAFB),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    const Color navy = Color(0xFF1E293B);
    const Color gold = Color(0xFFFBBF24);

    return Container(
      width: 280,
      color: navy,
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Text("N", style: TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                const SizedBox(width: 12),
                const Text("Nyumbani", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 48),
          // Profile Mini
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appState.name ?? "User", 
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(appState.role == UserRole.worker ? "House Manager" : "Agent", 
                        style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Navigation
          _NavItem(icon: Icons.dashboard_rounded, label: "Dashboard", isActive: true),
          _NavItem(icon: Icons.work_rounded, label: "Job Board"),
          _NavItem(icon: Icons.assignment_rounded, label: "My Applications"),
          _NavItem(icon: Icons.person_rounded, label: "Profile"),
          const Spacer(),
          _NavItem(icon: Icons.language, label: "Kiswahili"),
          _NavItem(
            icon: Icons.logout_rounded, 
            label: "Logout",
            onTap: () {
              appState.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({required this.icon, required this.label, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFBBF24) : Colors.transparent,
          borderRadius: isActive ? BorderRadius.circular(8) : null,
        ),
        margin: isActive ? const EdgeInsets.symmetric(horizontal: 12, vertical: 4) : EdgeInsets.zero,
        child: Row(
          children: [
            Icon(icon, color: isActive ? const Color(0xFF1E293B) : Colors.white60, size: 20),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(
              color: isActive ? const Color(0xFF1E293B) : Colors.white60,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            )),
          ],
        ),
      ),
    );
  }
}
