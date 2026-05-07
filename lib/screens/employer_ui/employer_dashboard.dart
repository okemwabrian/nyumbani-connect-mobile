import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/counties.dart';
import '../../widgets/app_drawer.dart';
import '../common/worker_detail_screen.dart';

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

class _EmployerDashboardState extends State<EmployerDashboard> {
  String _selectedCounty = counties.contains("Nairobi") ? "Nairobi" : counties.first;

  // Mock Workers
  final List<Map<String, dynamic>> _mockWorkers = [
    {"name": "Jane Doe", "skills": "Cooking, Cleaning", "status": "available", "verified": true, "county": "Nairobi"},
    {"name": "Mary Wanjiku", "skills": "Laundry, Childcare", "status": "available", "verified": true, "county": "Kiambu"},
    {"name": "David Otieno", "skills": "Gardening, Security", "status": "pending", "verified": false, "county": "Mombasa"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(role: widget.role),
      appBar: AppBar(
        title: Text("Welcome, ${widget.userName}"),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline_rounded), onPressed: _showCreateJobDialog),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSectionHeader("Worker Discovery", Icons.person_search_rounded),
                const SizedBox(height: 16),
                ..._mockWorkers.where((w) => w['verified']).map((w) => _workerCard(w)),

                const SizedBox(height: 32),

                _buildSectionHeader("Top Bureaus", Icons.business_rounded),
                const SizedBox(height: 16),
                _buildBureauCard("Elite Home Care", "Nairobi", 4.8),
                _buildBureauCard("SafeHands Agencies", "Kiambu", 4.5),
              ],
            ),
          ),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCounty,
                isExpanded: true,
                items: counties.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _selectedCounty = val!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryTeal),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
      ],
    );
  }

  Widget _workerCard(Map<String, dynamic> worker) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const Hero(
          tag: 'worker-avatar',
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.bgPale,
            child: Icon(Icons.person, color: AppColors.primaryTeal),
          ),
        ),
        title: Row(
          children: [
            Text(worker['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            const Icon(Icons.verified_rounded, color: Colors.green, size: 16),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(worker['skills'], style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text("📍 ${worker['county']}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondarySage,
            minimumSize: const Size(80, 36),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Text("Hire", style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  Widget _buildBureauCard(String name, String location, double rating) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.tertiaryOlive,
          child: Icon(Icons.business_rounded, color: AppColors.primaryTeal),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("📍 $location"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
            Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Create Job Posting", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: "Job Title", hintText: "e.g. Full-time House Manager")),
            const SizedBox(height: 16),
            const TextField(maxLines: 3, decoration: InputDecoration(labelText: "Description", hintText: "Describe tasks, salary, and expectations")),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCounty,
              decoration: const InputDecoration(labelText: "Select County"),
              items: counties.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) {},
            ),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("POST JOB")),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
