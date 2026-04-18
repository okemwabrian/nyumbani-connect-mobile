import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A), // The deep blue from your design
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Logo & Title area
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, color: Colors.amber, size: 32),
                  const SizedBox(width: 10),
                  const Text(
                    'Nyumbani',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Hero Text
              const Text(
                'Trusted Connections for Better Homes',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                'Connecting verified house managers with trusted agents and employers across Nairobi.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),

              // Feature Cards (Horizontal Scroll for Mobile)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFeatureCard(
                      icon: Icons.shield_outlined,
                      iconColor: Colors.amber,
                      title: 'Verified IDs',
                      subtitle: 'All users verified with National ID',
                    ),
                    const SizedBox(width: 15),
                    _buildFeatureCard(
                      icon: Icons.check_circle_outline,
                      iconColor: Colors.greenAccent,
                      title: 'Safe & Secure',
                      subtitle: 'Your data is protected',
                    ),
                    const SizedBox(width: 15),
                    _buildFeatureCard(
                      icon: Icons.favorite,
                      iconColor: Colors.pinkAccent,
                      title: 'Empowering Women',
                      subtitle: 'Building careers, building futures',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Get Started Section
              const Text(
                'Get Started',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Card 1: House Manager
              _buildRoleCard(
                context,
                title: 'I am a House Manager',
                subtitle: 'Looking for trusted employment opportunities in Nairobi',
                icon: Icons.account_circle_outlined,
                buttonColor: const Color(0xFF2563EB), // Blue button
                role: 'Worker',
              ),
              const SizedBox(height: 20),

              // Card 2: Agent/Employer
              _buildRoleCard(
                context,
                title: 'I am an Agent/Employer',
                subtitle: 'Connect with verified, trustworthy house managers',
                icon: Icons.work_outline,
                buttonColor: const Color(0xFFD97706), // Orange button
                role: 'Employer', // You can change this based on how you want to route them
              ),
              const SizedBox(height: 30),

              // Login Link
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                child: const Text(
                  'By registering, you agree to our terms of service\n\nAlready have an account? Login here',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the top Feature Cards (Verified IDs, etc.)
  Widget _buildFeatureCard({required IconData icon, required Color iconColor, required String title, required String subtitle}) {
    return Container(
      width: 160, // Fixed width so they scroll nicely
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1), // Translucent background to match your web design
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 36),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  // Helper widget to build the white Role Selection cards
  Widget _buildRoleCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color buttonColor, required String role}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CircleAvatar(backgroundColor: Colors.blue.shade50, radius: 35, child: Icon(icon, size: 35, color: Colors.blue.shade800)),
          const SizedBox(height: 15),
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
          const SizedBox(height: 10),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: buttonColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(initialRole: role)));
              },
              child: Text(
                'Register as ${title.replaceAll("I am a ", "").replaceAll("I am an ", "")}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}