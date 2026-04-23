import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const NyumbaniApp());
}

class NyumbaniApp extends StatelessWidget {
  const NyumbaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nyumbani Connect',
      debugShowCheckedModeBanner: false,

      // 🎨 GLOBAL THEME (YOUR COLORS)
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F3E6E),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2F3E6E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2F3E6E),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F3E6E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.home, color: Colors.white, size: 80),
            SizedBox(height: 20),
            Text(
              "Nyumbani Connect",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}