import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';
import 'providers/app_state.dart';
import 'providers/theme_provider.dart';
import 'screens/welcome_screen.dart';
import 'services/session_service.dart';
import 'screens/navigation/worker_nav.dart';
import 'screens/navigation/employer_nav.dart';
import 'screens/navigation/agent_nav.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const NyumbaniApp(),
    ),
  );
}

class NyumbaniApp extends StatelessWidget {
  const NyumbaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Nyumbani Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: themeProvider.locale,
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
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final session = await SessionService.getSession();
    if (!mounted) return;

    if (session != null) {
      final role = session['role'];
      final phone = session['phone'] ?? "";

      // Update Provider state
      Provider.of<AppState>(context, listen: false).setSession(role, phone);

      Widget nextScreen;
      if (role == 'worker') {
        nextScreen = WorkerNav(phone: phone);
      } else if (role == 'agent') {
        nextScreen = const AgentNav();
      } else {
        nextScreen = EmployerNav(phone: phone);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryTeal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for Lottie or Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.bgSurface,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/app_icon.png',
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "NYUMBANI CONNECT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Reliable Connections, Better Homes",
              style: TextStyle(
                color: AppColors.tertiaryOlive.withOpacity(0.9),
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 80),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondarySage),
            ),
          ],
        ),
      ),
    );
  }
}
