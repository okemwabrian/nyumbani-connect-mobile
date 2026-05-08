import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../providers/theme_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<ThemeProvider>(context);

    final screens = [
      const AgentDashboard(),
      const JobTrackingScreen(role: "agent"),
      const NotificationsScreen(role: "agent"),
    ];

    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: AppColors.primaryTeal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard_rounded), label: tp.translate('home')),
          BottomNavigationBarItem(icon: const Icon(Icons.work_history_rounded), label: tp.translate('jobs')),
          BottomNavigationBarItem(icon: const Icon(Icons.notifications_active_rounded), label: tp.translate('notifications')),
        ],
      ),
    );
  }
}
