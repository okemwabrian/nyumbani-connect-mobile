import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class JobTrackingScreen extends StatefulWidget {
  final String role;

  const JobTrackingScreen({super.key, required this.role});

  @override
  State<JobTrackingScreen> createState() => _JobTrackingScreenState();
}

class _JobTrackingScreenState extends State<JobTrackingScreen> {
  final List<Map<String, dynamic>> _jobs = [
    {
      "title": "House Cleaning",
      "employer": "Sarah M.",
      "county": "Nairobi",
      "status": "Assigned",
      "date": "Oct 24, 2023"
    },
    {
      "title": "Full-time Maid",
      "employer": "Peter K.",
      "county": "Kiambu",
      "status": "Pending",
      "date": "Oct 22, 2023"
    },
  ];

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "assigned": return Colors.green;
      case "completed": return Colors.blue;
      case "pending": return Colors.orange;
      default: return AppColors.primaryTeal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hiring History")),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          final color = _statusColor(job['status']);

          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(job['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: Text(job['status'], style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _infoRow(Icons.person_outline, "Employer", job['employer']),
                  _infoRow(Icons.location_on_outlined, "County", job['county']),
                  _infoRow(Icons.calendar_today_rounded, "Posted On", job['date']),
                  
                  if (widget.role == "agent" && job['status'] == "Pending") ...[
                    const Divider(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
                        child: const Text("ALLOCATE WORKER"),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.secondarySage),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(color: Colors.black54, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }
}
