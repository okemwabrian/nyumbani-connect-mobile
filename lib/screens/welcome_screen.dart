import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/app_theme.dart';
import 'role_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            
            // Branding
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryTeal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.house_rounded, color: AppColors.bgSurface, size: 60),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "NYUMBANI CONNECT",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            // HCI-Driven Lottie Animation (Placeholder)
            SizedBox(
              height: 300,
              child: Lottie.network(
                'https://assets9.lottiefiles.com/packages/lf20_7wwmupub.json',
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.handshake_rounded, size: 100, color: AppColors.secondarySage);
                },
              ),
            ),
            
            const Spacer(),

            // High-Impact CTA
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  const Text(
                    "Automating Trust in Domestic Work",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                      );
                    },
                    child: const Text("GET STARTED"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
