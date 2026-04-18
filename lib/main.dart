import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart'; // Changed import to point to the new welcome screen

void main() {
  runApp(const HomeManagerApp());
}

class HomeManagerApp extends StatelessWidget {
  const HomeManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nyumbani Connect', // Updated to match your brand name
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Updated the seed color to match the deep blue from your web design
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(), // Set the new Welcome Screen as the starting point
    );
  }
}