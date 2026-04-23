import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../common/worker_detail_screen.dart';

class AgentDashboard extends StatefulWidget {
  const AgentDashboard({super.key});

  @override
  State<AgentDashboard> createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard> {
  // 🔥 TEMP DATA (UI MODE)
  List workers = [
    {"name": "Jane Doe", "status": "pending", "verified": false},
    {"name": "Mary Wanjiku", "status": "available", "verified": true},
  ];

  List jobs = [
    {"title": "House Help Needed", "county": "Nairobi", "status": "open"},
    {"title": "Full-time Maid", "county": "Kiambu", "status": "assigned"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(role: "agent"),       backgroundColor: const Color(0xFFF4F7F2),

      appBar: AppBar(
        title: const Text("Agent Dashboard"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 SECTION: WORKERS
            const Text(
              "Worker Approvals",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F3E6E),
              ),
            ),

            const SizedBox(height: 10),

            ...workers.map((worker) => _workerCard(worker)),

            const SizedBox(height: 25),

            // 🔥 SECTION: JOBS
            const Text(
              "Job Assignments",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F3E6E),
              ),
            ),

            const SizedBox(height: 10),

            ...jobs.map((job) => _jobCard(job)),
          ],
        ),
      ),
    );
  }

  // 🔥 WORKER CARD
  Widget _workerCard(Map worker) {
    final isVerified = worker['verified'];

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE6EDD8),
            child: Icon(Icons.person, color: Color(0xFF2F3E6E)),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F3E6E),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Status: ${worker['status']}",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),

          isVerified
              ? const Icon(Icons.check_circle, color: Colors.green)
              : ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkerDetailScreen(
                    worker: worker,
                    role: "agent",
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA8C97F),
              foregroundColor: const Color(0xFF2F3E6E),
            ),
            child: const Text("Approve"),
          ),
        ],
      ),
    );
  }

  // 🔥 JOB CARD
  Widget _jobCard(Map job) {
    final isAssigned = job['status'] == "assigned";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE6EDD8),
            child: Icon(Icons.work, color: Color(0xFF2F3E6E)),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F3E6E),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${job['county']} • ${job['status']}",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),

          isAssigned
              ? const Text(
            "Assigned",
            style: TextStyle(color: Colors.green),
          )
              : ElevatedButton(
            onPressed: () {
              _showAssignDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F3E6E),
            ),
            child: const Text("Assign"),
          ),
        ],
      ),
    );
  }

  void _showAssignDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Assign Worker"),
        content: const Text("Worker selection UI goes here"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }
}