import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../employer_ui/employer_dashboard.dart';
import '../common/job_tracking_screen.dart';
import '../common/profile_screen.dart';

class EmployerNav extends StatefulWidget {
  final String phone;
  const EmployerNav({super.key, required this.phone});

  @override
  State<EmployerNav> createState() => _EmployerNavState();
}

class _EmployerNavState extends State<EmployerNav> {
  int _index = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      EmployerDashboard(userName: widget.phone, role: "employer"),
      const JobTrackingScreen(role: "employer"),
      const ProfileScreen(role: "employer"),
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