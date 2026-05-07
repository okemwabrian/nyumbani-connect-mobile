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
    {"name": "Alice Korir", "id_uploaded": true, "skills": "Cooking, Elderly Care", "date": "2h ago"},
    {"name": "John Maina", "id_uploaded": true, "skills": "Security", "date": "1d ago"},
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
        title: const Text("Bureau Admin"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.tertiaryOlive,
          tabs: const [
            Tab(text: "Verify Queue", icon: Icon(Icons.verified_user_rounded)),
            Tab(text: "Job Matcher", icon: Icon(Icons.auto_awesome_rounded)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVerifyQueue(),
          _buildJobMatcher(),
        ],
      ),
    );
  }

  Widget _buildVerifyQueue() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _pendingWorkers.length,
      itemBuilder: (context, index) {
        final worker = _pendingWorkers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: const CircleAvatar(backgroundColor: AppColors.bgSurface, child: Icon(Icons.person, color: AppColors.primaryTeal)),
            title: Text(worker['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Registered: ${worker['date']}"),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Automation: National ID Scanned", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 8),
                    Container(height: 100, width: double.infinity, color: AppColors.bgSurface, child: const Icon(Icons.badge_rounded, size: 50, color: AppColors.primaryTeal)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: () {}, child: const Text("REJECT"))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text("VERIFY ID"),
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

  Widget _buildJobMatcher() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text("Active Job Requests", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _matchCard("Nanny Needed", "Nairobi", "Mercy N."),
        _matchCard("Professional Cook", "Kisumu", "Peter O."),
      ],
    );
  }

  Widget _matchCard(String title, String location, String employer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("📍 $location • From: $employer", style: const TextStyle(color: Colors.black54)),
            const Divider(height: 32),
            const Text("Smart Suggestions (Best Match):", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryTeal)),
            const SizedBox(height: 12),
            _suggestionItem("Mary Wanjiku", "98% Match"),
            _suggestionItem("Jane Doe", "92% Match"),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {}, child: const Text("ALLOCATE WORKER")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _suggestionItem(String name, String match) {
    return Row(
      children: [
        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
        const SizedBox(width: 8),
        Text(name, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        Text(match, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondarySage, fontSize: 12)),
      ],
    );
  }
}
