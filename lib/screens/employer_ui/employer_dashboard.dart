import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/counties.dart';
import '../../widgets/app_drawer.dart';

class EmployerDashboard extends StatefulWidget {
  final String userName;
  final String role;

  const EmployerDashboard({
    super.key,
    required this.userName,
    required this.role,
  });

  @override
  State<EmployerDashboard> createState() => _EmployerDashboardState();
}

class _EmployerDashboardState extends State<EmployerDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCounty = "Nairobi";

  // Mock Data
  final List<Map<String, dynamic>> _mockWorkers = [
    {"name": "Jane Doe", "skills": "Cooking, Cleaning", "status": "available", "verified": true, "county": "Nairobi"},
    {"name": "Mary Wanjiku", "skills": "Laundry, Childcare", "status": "available", "verified": true, "county": "Kiambu"},
  ];

  final List<Map<String, dynamic>> _applications = [
    {"name": "Alice Korir", "job": "Nanny", "status": "Under Review", "verified": true},
    {"name": "John Maina", "job": "Chef", "status": "Interviewing", "verified": true},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(role: widget.role),
      appBar: AppBar(
        title: Text("Welcome, ${widget.userName}"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.tertiaryOlive,
          tabs: const [
            Tab(text: "Discover", icon: Icon(Icons.search_rounded)),
            Tab(text: "Hiring Panel", icon: Icon(Icons.people_alt_rounded)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscoverView(),
          _buildHiringPanelView(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateJobDialog,
        backgroundColor: AppColors.primaryTeal,
        icon: const Icon(Icons.post_add_rounded, color: Colors.white),
        label: const Text("Post a Job", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildDiscoverView() {
    return Column(
      children: [
        _buildFilterHeader(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text("Top Rated Workers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              ..._mockWorkers.map((w) => _workerCard(w)),
              const SizedBox(height: 32),
              const Text("Verified Bureaus", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              _buildBureauCard("Elite Home Care", "Nairobi", 4.8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHiringPanelView() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _applications.length,
      itemBuilder: (context, index) {
        final app = _applications[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: AppColors.bgSurface, child: Icon(Icons.person, color: AppColors.primaryTeal)),
            title: Text(app['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Applied for: ${app['job']}"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.tertiaryOlive.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Text(app['status'], style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryTeal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedCounty,
            isExpanded: true,
            items: counties.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) => setState(() => _selectedCounty = val!),
          ),
        ),
      ),
    );
  }

  Widget _workerCard(Map<String, dynamic> worker) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const CircleAvatar(radius: 25, backgroundColor: AppColors.bgSurface, child: Icon(Icons.person, color: AppColors.primaryTeal)),
        title: Text(worker['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(worker['skills']),
        trailing: const Icon(Icons.verified_rounded, color: Colors.green),
      ),
    );
  }

  Widget _buildBureauCard(String name, String location, double rating) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: AppColors.tertiaryOlive, child: Icon(Icons.business_rounded, color: AppColors.primaryTeal)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("📍 $location"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [const Icon(Icons.star_rounded, color: Colors.amber, size: 18), Text(rating.toString())],
        ),
      ),
    );
  }

  void _showCreateJobDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Automated Job Post", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: "Job Title (e.g. Driver)")),
            const SizedBox(height: 16),
            const TextField(maxLines: 3, decoration: InputDecoration(labelText: "Description")),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("POST & NOTIFY WORKERS")),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
