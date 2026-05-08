import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../worker_ui/worker_dashboard.dart';
import '../common/job_tracking_screen.dart';
import '../common/profile_screen.dart';

class WorkerNav extends StatefulWidget {
  final String phone;
  const WorkerNav({super.key, required this.phone});

  @override
  State<WorkerNav> createState() => _WorkerNavState();
}

class _WorkerNavState extends State<WorkerNav> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<ThemeProvider>(context);

    final List<Widget> screens = [
      WorkerDashboard(workerName: widget.phone),
      const JobTrackingScreen(role: "worker"),
      const ProfileScreen(role: "worker"),
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
          BottomNavigationBarItem(icon: const Icon(Icons.home_filled), label: tp.translate('home')),
          BottomNavigationBarItem(icon: const Icon(Icons.history_rounded), label: tp.translate('history')),
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline_rounded), label: tp.translate('profile')),
        ],
      ),
    );
  }
}
