import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/primary_button.dart';

class JobTrackingScreen extends StatefulWidget {
  final String role;

  const JobTrackingScreen({super.key, required this.role});

  @override
  State<JobTrackingScreen> createState() => _JobTrackingScreenState();
}

class _JobTrackingScreenState extends State<JobTrackingScreen> {
  final List<Map<String, dynamic>> _jobs = [
    {
      "id": 101,
      "title": "Full-time House Manager",
      "partner": "Sarah M. (Employer)",
      "location": "Nairobi - Westlands",
      "status": "In Progress",
      "date": "24 Oct 2023",
      "amount": "KSh 25,000",
      "description": "Requires deep cleaning, cooking for a family of 4, and pet care. 6 days a week.",
      "contact": "+254712345678"
    },
    {
      "id": 102,
      "title": "Professional Chef",
      "partner": "Elite Care Bureau",
      "location": "Mombasa - Nyali",
      "status": "Completed",
      "date": "20 Oct 2023",
      "amount": "KSh 40,000",
      "description": "Temporary 2-week engagement for a private event. Gourmet seafood specialty required.",
      "contact": "+254722999888"
    },
    {
      "id": 103,
      "title": "Nanny Services",
      "partner": "John Maina (Employer)",
      "location": "Kiambu - Ruiru",
      "status": "Cancelled",
      "date": "18 Oct 2023",
      "amount": "KSh 18,000",
      "description": "Daytime childcare for a toddler. Cancelled due to location mismatch.",
      "contact": "+254733111222"
    },
  ];

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "in progress": return Colors.blue;
      case "completed": return Colors.green;
      case "cancelled": return Colors.redAccent;
      case "pending": return Colors.orange;
      default: return AppColors.primaryTeal;
    }
  }

  void _showJobDetails(Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(job['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: _statusColor(job['status']).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(job['status'].toUpperCase(), style: TextStyle(color: _statusColor(job['status']), fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ],
            ),
            const Divider(height: 32),
            _detailRow(Icons.business_center_rounded, "Contract Partner", job['partner']),
            _detailRow(Icons.location_on_rounded, "Physical Location", job['location']),
            _detailRow(Icons.calendar_month_rounded, "Engagement Date", job['date']),
            _detailRow(Icons.payments_rounded, "Total Amount", job['amount']),
            const SizedBox(height: 16),
            const Text("Job Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(job['description'], style: const TextStyle(color: Colors.black87, height: 1.5)),
            const SizedBox(height: 32),
            PrimaryButton(
              label: "CONTACT PARTNER", 
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connecting to ${job['contact']}...")));
              }
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: AppColors.bgSurface, child: Icon(icon, size: 18, color: AppColors.primaryTeal)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isWorker = widget.role == 'worker';

    return Scaffold(
      appBar: AppBar(
        title: Text(isWorker ? themeProvider.translate('job_history') : themeProvider.translate('hiring_history')),
        elevation: 0,
      ),
      body: _jobs.isEmpty 
        ? EmptyStateWidget(
            icon: Icons.history_rounded, 
            title: themeProvider.translate('no_history') ?? "No History Yet", 
            subtitle: "All your past and current activities will appear here."
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _jobs.length,
            itemBuilder: (context, index) {
              final job = _jobs[index];
              final statusColor = _statusColor(job['status']);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: InkWell(
                  onTap: () => _showJobDetails(job),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                job['status'].toUpperCase(),
                                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            ),
                            Text(job['date'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          job['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        _iconInfo(Icons.business_center_rounded, job['partner']),
                        _iconInfo(Icons.location_on_rounded, job['location']),
                        const Divider(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Estimated Pay", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                Text(job['amount'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryTeal)),
                              ],
                            ),
                            TextButton(
                              onPressed: () => _showJobDetails(job),
                              child: const Text("VIEW DETAILS", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _iconInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.secondarySage),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 13))),
        ],
      ),
    );
  }
}
