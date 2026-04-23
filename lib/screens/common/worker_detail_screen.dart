import 'package:flutter/material.dart';

class WorkerDetailScreen extends StatelessWidget {
  final Map worker;
  final String role; // employer / agent

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

            // 🔥 PROFILE HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    worker['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F3E6E),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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

            // 🔥 SKILLS
            _infoCard(
              icon: Icons.star,
              title: "Skills",
              value: worker['skills'] ?? "Not specified",
            ),

            const SizedBox(height: 15),

            // 🔥 STATUS
            _infoCard(
              icon: Icons.work,
              title: "Status",
              value: worker['status'] ?? "available",
            ),

            const SizedBox(height: 25),

            // 🔥 ACTIONS
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
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F3E6E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hireButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Job request sent to agent")),
          );
        },
        child: const Text("Request Hire"),
      ),
    );
  }

  Widget _approveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA8C97F),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Worker Approved")),
          );
        },
        child: const Text("Approve Worker"),
      ),
    );
  }
}