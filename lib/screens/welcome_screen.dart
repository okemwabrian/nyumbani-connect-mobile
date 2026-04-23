import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  int _current = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> features = [
    {"icon": Icons.verified, "title": "Verified Workers"},
    {"icon": Icons.security, "title": "Safe Hiring"},
    {"icon": Icons.location_on, "title": "Across All Counties"},
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _current = (_current + 1) % features.length;

      _controller.animateToPage(
        _current,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(role: "guest"),      backgroundColor: const Color(0xFFF4F7F2),

      appBar: AppBar(
        title: const Text("Nyumbani Connect"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 🔥 HERO TEXT
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      "Find Trusted Help\nFor Your Home",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F3E6E),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Connect with verified house managers, agents, and employers across Kenya.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 🔥 FEATURE CARDS
              SizedBox(
                height: 140,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    final item = features[index];

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: index == _current
                            ? const Color(0xFFA8C97F)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item["icon"],
                            size: 36,
                            color: const Color(0xFF2F3E6E),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item["title"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2F3E6E),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              // 🔥 ACTION SECTION
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F3E6E),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _roleCard(
                      context,
                      icon: Icons.person,
                      title: "House Manager",
                      subtitle: "Find jobs near you",
                      role: "worker",
                    ),

                    const SizedBox(height: 15),

                    _roleCard(
                      context,
                      icon: Icons.business,
                      title: "Employer / Agent",
                      subtitle: "Hire trusted workers",
                      role: "employer",
                    ),

                    const SizedBox(height: 25),

                    // 🔥 REGISTER CTA
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(
                                initialRole: "worker",
                              ),
                            ),
                          );
                        },
                        child: const Text("Create Account"),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🔥 LOGIN CTA
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Color(0xFF2F3E6E)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard(BuildContext context,
      {required IconData icon,
        required String title,
        required String subtitle,
        required String role}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RegisterScreen(initialRole: role),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFFA8C97F),
              child: Icon(icon, color: const Color(0xFF2F3E6E)),
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F3E6E),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}