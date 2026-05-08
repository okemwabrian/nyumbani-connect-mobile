import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'auth/register_screen.dart';
import 'auth/login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Nyumbani"),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tell us who you are",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text("Select the role that best describes you."),
                      const SizedBox(height: 40),
                      
                      _roleCard(
                        context,
                        title: "Employer",
                        subtitle: "I'm looking to hire professional help.",
                        icon: Icons.person_add_alt_1_rounded,
                        role: "employer",
                      ),
                      const SizedBox(height: 20),
                      _roleCard(
                        context,
                        title: "House Manager",
                        subtitle: "I'm looking for professional jobs.",
                        icon: Icons.work_history_rounded,
                        role: "worker",
                      ),
                      const SizedBox(height: 20),
                      _roleCard(
                        context,
                        title: "Bureau / Agent",
                        subtitle: "I manage workers and verify credentials.",
                        icon: Icons.admin_panel_settings_rounded,
                        role: "agent",
                      ),
                      
                      const Spacer(),
                      const SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                          child: const Text("Already have an account? Login", 
                            style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _roleCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required String role}) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen(initialRole: role))),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.tertiaryOlive),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.bgSurface,
              child: Icon(icon, color: AppColors.primaryTeal, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.secondarySage, size: 16),
          ],
        ),
      ),
    );
  }
}
 