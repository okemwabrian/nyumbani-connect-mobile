import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/welcome_screen.dart';
import 'screens/worker_ui/worker_dashboard.dart';
import 'screens/employer_ui/employer_dashboard.dart';

void main() {
  runApp(const HomeManagerApp());
}

class HomeManagerApp extends StatelessWidget {
  const HomeManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nyumbani Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
      ),
      home: const AuthCheckScreen(), // 🔥 NEW
    );
  }
}

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role'); // we’ll store this too

    await Future.delayed(const Duration(seconds: 2)); // splash feel

    if (!mounted) return;

    if (token != null && role != null) {
      // 🔥 Auto-route based on role
      if (role == 'worker') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => WorkerDashboard(workerName: 'User'),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmployerDashboard(
              userName: 'User',
              role: role,
            ),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}