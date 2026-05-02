import 'package:flutter/material.dart';
import '../employer_ui/employer_dashboard.dart';
import '../common/job_tracking_screen.dart';
import '../common/profile_screen.dart';

class EmployerNav extends StatefulWidget {
  const EmployerNav({super.key});

  @override
  State<EmployerNav> createState() => _EmployerNavState();
}

class _EmployerNavState extends State<EmployerNav> {
  int _index = 0;

  final screens = [
    const EmployerDashboard(userName: "User", role: "employer"),
    const JobTrackingScreen(role: "employer"),
    const ProfileScreen(role: "employer"),
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
            icon: Icon(Icons.people),
            label: "Workers",
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