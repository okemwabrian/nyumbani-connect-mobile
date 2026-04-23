import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../worker_ui/worker_dashboard.dart';
import '../employer_ui/employer_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage("Enter phone and password");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(
        _phoneController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (result != null) {
        final role = result['role'];
        final phone = result['phone'];
        final token = result['access'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('role', role);

        if (role == 'worker') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => WorkerDashboard(workerName: phone),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => EmployerDashboard(
                userName: phone,
                role: role,
              ),
            ),
          );
        }
      } else {
        _showMessage("Invalid credentials");
      }
    } catch (e) {
      _showMessage("Error: $e");
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF2F3E6E)),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFA8C97F),
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),

      appBar: AppBar(
        title: const Text("Login"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 🔥 HEADER
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F3E6E),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Login to continue",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 30),

              // 🔥 PHONE
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputStyle("Phone Number", Icons.phone),
              ),

              const SizedBox(height: 15),

              // 🔥 PASSWORD
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputStyle("Password", Icons.lock),
              ),

              const SizedBox(height: 25),

              // 🔥 LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text("Login"),
                ),
              ),

              const SizedBox(height: 15),

              // 🔥 SECONDARY ACTION
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Don't have an account? Register",
                    style: TextStyle(color: Color(0xFF2F3E6E)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}