import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
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

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      WorkerDashboard(workerName: widget.phone),
      const JobTrackingScreen(role: "worker"),
      const ProfileScreen(role: "worker"),
    ];
  }

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
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}