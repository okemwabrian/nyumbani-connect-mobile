import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../screens/welcome_screen.dart';
import '../screens/job_board_screen.dart';
import '../screens/common/profile_screen.dart';

class NyumbaniLayout extends StatelessWidget {
  final Widget body;
  final String title;

  const NyumbaniLayout({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      drawer: isMobile ? const Drawer(child: Sidebar()) : null,
      appBar: isMobile ? AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
      ) : null,
      body: Row(
        children: [
          if (!isMobile) const Sidebar(),
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAFB),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: body,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    const Color navy = Color(0xFF1E293B);

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
                  child: Icon(Icons.person, color: Colors.white, size: 20),
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
          NavItem(
            icon: Icons.dashboard_rounded, 
            label: "Dashboard", 
            isActive: true,
            onTap: () {
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
              // Already on dashboard? Just refresh or navigate
            },
          ),
          NavItem(
            icon: Icons.work_rounded, 
            label: "Job Board",
            onTap: () {
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const JobBoardScreen()));
            },
          ),
          NavItem(
            icon: Icons.assignment_rounded, 
            label: "My Applications",
            onTap: () {
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
            },
          ),
          NavItem(
            icon: Icons.person_rounded, 
            label: "Profile",
            onTap: () {
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen(role: "worker")));
            },
          ),
          const Spacer(),
          const NavItem(icon: Icons.language, label: "Kiswahili"),
          NavItem(
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

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const NavItem({super.key, required this.icon, required this.label, this.isActive = false, this.onTap});

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
