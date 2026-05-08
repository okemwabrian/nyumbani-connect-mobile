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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Spacer(),
                      
                      // Branding Section
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.primaryTeal,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(color: AppColors.primaryTeal.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))
                                ],
                              ),
                              child: const Icon(Icons.house_siding_rounded, color: AppColors.bgSurface, size: 64),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              "NYUMBANI CONNECT",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3,
                                color: AppColors.primaryTeal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Kenya's Trusted Care Marketplace",
                              style: TextStyle(fontSize: 14, color: AppColors.secondarySage, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),

                      // HCI-Driven Lottie Animation
                      SizedBox(
                        height: 280,
                        child: Lottie.network(
                          'https://assets9.lottiefiles.com/packages/lf20_7wwmupub.json',
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.handshake_rounded, size: 120, color: AppColors.secondarySage);
                          },
                        ),
                      ),
                      
                      const Spacer(),

                      // Action Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40),
                        child: Column(
                          children: [
                            const Text(
                              "Seamlessly Connecting Homes\nwith Professional Care",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryTeal,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                              ),
                              child: const Text("GET STARTED"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
