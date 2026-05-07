import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/app_drawer.dart';

class AgentDashboard extends StatefulWidget {
  const AgentDashboard({super.key});

  @override
  State<AgentDashboard> createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _pendingWorkers = [
    {"name": "Alice Korir", "id_uploaded": true, "skills": "Cooking, Elderly Care", "date": "2 hours ago"},
    {"name": "John Maina", "id_uploaded": true, "skills": "Security, Gardening", "date": "1 day ago"},
  ];

  final List<Map<String, dynamic>> _jobRequests = [
    {"title": "Full-time Maid", "employer": "Mercy N.", "location": "Nairobi", "salary": "KSh 15,000"},
    {"title": "Weekend Cook", "employer": "Peter K.", "location": "Kiambu", "salary": "KSh 2,500/day"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(role: "agent"),
      appBar: AppBar(
        title: const Text("Bureau Dashboard"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.tertiaryOlive,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Pending Approvals", icon: Icon(Icons.pending_actions_rounded)),
            Tab(text: "Job Requests", icon: Icon(Icons.assignment_ind_rounded)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingRoster(),
          _buildJobRequestsView(),
        ],
      ),
    );
  }

  Widget _buildPendingRoster() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _pendingWorkers.length,
      itemBuilder: (context, index) {
        final worker = _pendingWorkers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: const CircleAvatar(backgroundColor: AppColors.bgPale, child: Icon(Icons.person, color: AppColors.primaryTeal)),
            title: Text(worker['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Applied: ${worker['date']}"),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Uploaded Documents:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _docItem("National ID / Passport", worker['id_uploaded']),
                    const SizedBox(height: 16),
                    Text("Skills: ${worker['skills']}"),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text("Reject"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text("Approve"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _docItem(String title, bool uploaded) {
    return Row(
      children: [
        Icon(uploaded ? Icons.check_circle_rounded : Icons.error_outline_rounded,
             color: uploaded ? Colors.green : Colors.red, size: 20),
        const SizedBox(width: 8),
        Text(title),
        const Spacer(),
        TextButton(onPressed: () {}, child: const Text("View File")),
      ],
    );
  }

  Widget _buildJobRequestsView() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _jobRequests.length,
      itemBuilder: (context, index) {
        final job = _jobRequests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(job['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text("Employer: ${job['employer']} • 📍 ${job['location']}"),
                Text("Budget: ${job['salary']}", style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () => _showAllocationDialog(job),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, minimumSize: const Size(100, 44)),
              child: const Text("Allocate"),
            ),
          ),
        );
      },
    );
  }

  void _showAllocationDialog(Map job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Allocate Worker"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select a verified worker for ${job['title']}"),
            const SizedBox(height: 20),
            _allocationItem("Mary Wanjiku"),
            _allocationItem("Jane Doe"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ],
      ),
    );
  }

  Widget _allocationItem(String name) {
    return ListTile(
      leading: const CircleAvatar(radius: 15, child: Icon(Icons.person, size: 15)),
      title: Text(name),
      trailing: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryTeal),
      onTap: () => Navigator.pop(context),
    );
  }
}
