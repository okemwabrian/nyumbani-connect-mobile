import 'package:flutter/material.dart';

class JobTrackingScreen extends StatefulWidget {
  final String role;

  const JobTrackingScreen({super.key, required this.role});

  @override
  State<JobTrackingScreen> createState() => _JobTrackingScreenState();
}

class _JobTrackingScreenState extends State<JobTrackingScreen> {
  List jobs = [
    {
      "title": "House Cleaning",
      "worker": "Jane Doe",
      "county": "Nairobi",
      "status": "pending"
    },
    {
      "title": "Full-time Maid",
      "worker": "Mary Wanjiku",
      "county": "Kiambu",
      "status": "assigned"
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case "assigned":
        return Colors.green;
      case "completed":
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),

      appBar: AppBar(title: const Text("Jobs")),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F3E6E))),

                  const SizedBox(height: 6),

                  Text("Worker: ${job['worker']}"),
                  Text("County: ${job['county']}"),

                  const SizedBox(height: 10),

                  Chip(
                    label: Text(job['status']),
                    backgroundColor:
                    _statusColor(job['status']).withOpacity(0.15),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.role == "agent" &&
                          job['status'] == "pending")
                        TextButton(
                          onPressed: () {
                            setState(() => job['status'] = "assigned");
                          },
                          child: const Text("Assign"),
                        ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}