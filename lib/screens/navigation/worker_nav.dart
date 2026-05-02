import 'package:flutter/material.dart';
import '../worker_ui/worker_dashboard.dart';
import '../common/job_tracking_screen.dart';
import '../common/profile_screen.dart';

class WorkerNav extends StatefulWidget {
  const WorkerNav({super.key});

  @override
  State<WorkerNav> createState() => _WorkerNavState();
}

class _WorkerNavState extends State<WorkerNav> {
  int _index = 0;

  final screens = [
    const WorkerDashboard(workerName: "User"),
    const JobTrackingScreen(role: "worker"),
    const ProfileScreen(role: "worker"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: const Color(0xFF1E3A8A),

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