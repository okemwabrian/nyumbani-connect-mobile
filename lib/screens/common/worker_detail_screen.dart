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
            _header(isVerified),
            const SizedBox(height: 20),

            _infoCard(Icons.star, "Skills", worker['skills'] ?? "Not specified"),
            const SizedBox(height: 15),
            _infoCard(Icons.work, "Status", worker['status'] ?? "Available"),

            const SizedBox(height: 25),

            if (role == "employer") _hireButton(context),
            if (role == "agent") _approveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _header(bool isVerified) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
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
        onPressed: () {},
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
        onPressed: () {},
        child: const Text("Approve Worker"),
      ),
    );
  }
}