import 'package:flutter/material.dart';

class JobTrackingScreen extends StatefulWidget {
  final String role;

  const JobTrackingScreen({super.key, required this.role});

  @override
  State<JobTrackingScreen> createState() => _JobTrackingScreenState();
}

class _JobTrackingScreenState extends State<JobTrackingScreen> {
  // 🔥 TEMP DATA (UI MODE)
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

      appBar: AppBar(
        title: const Text("Jobs"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔥 TITLE
                Text(
                  job['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF2F3E6E),
                  ),
                ),

                const SizedBox(height: 8),

                // 🔥 DETAILS
                Text("Worker: ${job['worker']}"),
                Text("County: ${job['county']}"),

                const SizedBox(height: 10),

                // 🔥 STATUS BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor(job['status']).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    job['status'].toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(job['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 ACTIONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.role == "agent" &&
                        job['status'] == "pending")
                      TextButton(
                        onPressed: () {
                          setState(() {
                            job['status'] = "assigned";
                          });
                        },
                        child: const Text("Assign"),
                      ),

                    if (widget.role == "worker" &&
                        job['status'] == "assigned")
                      TextButton(
                        onPressed: () {
                          setState(() {
                            job['status'] = "completed";
                          });
                        },
                        child: const Text("Mark Complete"),
                      ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}