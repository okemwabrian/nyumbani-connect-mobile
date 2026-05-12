import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/register_screen.dart';
import 'auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color deepBlue = Color(0xFF1E293B);
    const Color accentGold = Color(0xFFFBBF24);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HERO SECTION ---
            _buildHero(context, deepBlue, accentGold),

            // --- STATS SECTION ---
            _buildStats(),

            // --- WHY CHOOSE US ---
            _buildBenefits(),

            // --- CALL TO ACTION ---
            _buildCTA(context, deepBlue, accentGold),

            const SizedBox(height: 48),
            const Text("By registering, you agree to our terms of service", style: TextStyle(color: Colors.black45, fontSize: 12)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, Color bg, Color gold) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: bg),
      child: Column(
        children: [
          // Navbar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(radius: 12, backgroundColor: Colors.white, child: Text("N", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold))),
                    const SizedBox(width: 8),
                    Text("Nyumbani", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.language, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    const Text("Kiswahili", style: TextStyle(color: Colors.white70)),
                    const SizedBox(width: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text("Sign In"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1),
                    children: [
                      const TextSpan(text: "Find Trusted "),
                      TextSpan(text: "House\nManagers", style: TextStyle(color: gold)),
                      const TextSpan(text: " in Nairobi"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text("Connecting trusted house managers with verified employers across Nairobi.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 18)),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold, 
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Register Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Login to Account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _statCard("2,400+", "Verified House Managers"),
          _statCard("850+", "Trusted Employers"),
          _statCard("97%", "Placement Success Rate"),
          _statCard("47", "Nairobi Neighborhoods"),
        ],
      ),
    );
  }

  Widget _statCard(String val, String label) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildBenefits() {
    return Column(
      children: [
        const SizedBox(height: 64),
        const Text("Why Choose Nyumbani?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const Text("Safety, trust, and community — at your fingertips.", style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 48),
        _benefitTile(Icons.shield_outlined, "Verified & Safe", "Every house manager is ID-verified and background-checked."),
        _benefitTile(Icons.star_outline, "Rated & Reviewed", "Transparent ratings from real employers help you decide."),
        _benefitTile(Icons.people_outline, "Community First", "Built for Nairobi families by people who understand the needs."),
      ],
    );
  }

  Widget _benefitTile(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.blue)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(desc, style: const TextStyle(color: Colors.black54)),
          ])),
        ],
      ),
    );
  }

  Widget _buildCTA(BuildContext context, Color bg, Color gold) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          const Text("Ready to get started?", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text("Join thousands of Nairobi families and house managers today.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
            style: ElevatedButton.styleFrom(backgroundColor: gold, foregroundColor: Colors.black87, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("Sign Up — It's Free →", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
