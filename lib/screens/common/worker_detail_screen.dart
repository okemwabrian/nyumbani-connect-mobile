import 'package:flutter/material.dart';

class WorkerDetailScreen extends StatelessWidget {
  final Map worker;
  final String role;

  const WorkerDetailScreen({
    super.key,
    required this.worker,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final bool isVerified = worker['verified'] ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),

      appBar: AppBar(
        title: const Text("Worker Profile"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 🔥 HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 6)
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFE6EDD8),
                    child: Icon(Icons.person, size: 55),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    worker['name'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F3E6E),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isVerified
                          ? Colors.green.withOpacity(0.15)
                          : Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isVerified ? "Verified" : "Pending",
                      style: TextStyle(
                        color: isVerified ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _infoCard(
              icon: Icons.star,
              title: "Skills",
              value: worker['skills'] ?? "Not specified",
            ),

            _infoCard(
              icon: Icons.work,
              title: "Status",
              value: worker['status'] ?? "Available",
            ),

            const SizedBox(height: 25),

            if (role == "employer") _hireButton(context),
            if (role == "agent") _approveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4)
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE6EDD8),
            child: Icon(icon, color: const Color(0xFF2F3E6E)),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.black54)),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F3E6E))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hireButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E3A8A),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {},
      child: const Text("Request Hire"),
    );
  }

  Widget _approveButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA8C97F),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {},
      child: const Text("Approve Worker"),
    );
  }
}