import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import '../../providers/app_state.dart';
import '../navigation/worker_nav.dart';
import '../navigation/employer_nav.dart';
import '../navigation/agent_nav.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showMessage("Please fill all fields");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(phone, password);
      if (!mounted) return;

      if (result != null) {
        final role = result['role'];
        final userPhone = result['phone'] ?? phone;
        final token = result['access'];

        await SessionService.saveSession(token, role, userPhone);

        if (!mounted) return;

        // Update Provider State
        Provider.of<AppState>(context, listen: false).setSession(role, userPhone);

        Widget nextScreen;
        if (role == 'worker') {
          nextScreen = WorkerNav(phone: userPhone);
        } else if (role == 'agent') {
          nextScreen = const AgentNav();
        } else {
          nextScreen = EmployerNav(phone: userPhone);
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => nextScreen),
          (route) => false,
        );
      } else {
        _showMessage("Invalid credentials");
      }
    } catch (e) {
      _showMessage("Login failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.primaryTeal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.lock_person_rounded, size: 80, color: AppColors.primaryTeal),
            const SizedBox(height: 24),
            const Text(
              "Welcome Back",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const Text("Login to manage your connections"),
            const SizedBox(height: 48),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone_android_rounded),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("LOGIN"),
            ),

            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen(initialRole: 'worker'))
                );
              },
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
