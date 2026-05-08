import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../agent_ui/agent_dashboard.dart';
import '../common/job_tracking_screen.dart';
import '../common/notifications_screen.dart';

class AgentNav extends StatefulWidget {
  final String? phone;
  const AgentNav({super.key, this.phone});

  @override
  State<AgentNav> createState() => _AgentNavState();
}

class _AgentNavState extends State<AgentNav> {
  int _index = 0;

  final screens = [
    const AgentDashboard(),
    const JobTrackingScreen(role: "agent"),
    const NotificationsScreen(role: "agent"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: AppColors.secondarySage,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.verified),
            label: "Workers",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Alerts",
          ),
        ],
      ),
    );
  }
}