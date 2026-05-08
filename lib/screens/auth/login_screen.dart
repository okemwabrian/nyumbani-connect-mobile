import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import '../../providers/app_state.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/video_background.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _selectedRole = 'employer'; 

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      final result = await AuthService.login(identifier, password);
      
      if (!mounted) return;

      if (result != null) {
        final role = result['role'] ?? _selectedRole;
        final userPhone = result['phone'] ?? identifier;
        final token = result['access'];

        await SessionService.saveSession(token, role, userPhone);

        if (!mounted) return;

        Provider.of<AppState>(context, listen: false).setSession(role, userPhone);

        Widget nextScreen;
        if (role == 'worker') {
          nextScreen = WorkerNav(phone: userPhone);
        } else if (role == 'agent') {
          nextScreen = const AgentNav();
        } else if (role == 'admin') {
          // Placeholder for Admin Dashboard
          nextScreen = EmployerNav(phone: userPhone);
        } else {
          nextScreen = EmployerNav(phone: userPhone);
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => nextScreen),
          (route) => false,
        );
      } else {
        _showMessage("Invalid credentials. Please try again.", isError: true);
      }
    } catch (e) {
      _showMessage("Login failed. Check your connection.", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg), 
        backgroundColor: isError ? Colors.redAccent : AppColors.primaryTeal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    final List<Map<String, String>> roles = [
      {'id': 'employer', 'label': themeProvider.translate('employer')},
      {'id': 'worker', 'label': themeProvider.translate('worker')},
      {'id': 'agent', 'label': themeProvider.translate('agent')},
      {'id': 'admin', 'label': 'Admin'},
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(themeProvider.translate('login')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: VideoBackground(
        videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-kitchen-worker-preparing-a-meal-40342-large.mp4',
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_person_rounded, size: 64, color: AppColors.primaryTeal),
                    const SizedBox(height: 16),
                    Text(
                      themeProvider.translate('login_title'),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // Role Selection Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.tertiaryOlive),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRole,
                          isExpanded: true,
                          items: roles.map((role) => DropdownMenuItem(
                            value: role['id'],
                            child: Text(role['label']!),
                          )).toList(),
                          onChanged: (val) => setState(() => _selectedRole = val!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _identifierController,
                      label: themeProvider.translate('identifier_label'),
                      icon: Icons.person_outline_rounded,
                      validator: (value) => (value == null || value.isEmpty) ? themeProvider.translate('required_error') : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      label: themeProvider.translate('password'),
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      validator: (value) => (value == null || value.length < 6) ? themeProvider.translate('password_error') : null,
                    ),
                    const SizedBox(height: 32),

                    PrimaryButton(
                      label: themeProvider.translate('login'),
                      isLoading: _isLoading,
                      onPressed: _login,
                    ),

                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterScreen(initialRole: _selectedRole))
                        );
                      },
                      child: Text(themeProvider.translate('no_account_action'), 
                        style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
