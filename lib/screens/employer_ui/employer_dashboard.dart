// employer_dashboard.dart (UPDATED)

import 'package:flutter/material.dart';
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
  String _selectedCounty = counties.first;

  List workers = [
    {
      "name": "Jane Doe",
      "skills": "Cooking",
      "status": "available",
      "verified": true
    },
    {
      "name": "Mary Wanjiku",
      "skills": "Cleaning",
      "status": "pending",
      "verified": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(role: widget.role),
      backgroundColor: const Color(0xFFF4F7F2),

      appBar: AppBar(
        title: Text("Welcome, ${widget.userName}"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 🔥 FILTER CARD
            _buildFilterCard(),

            const SizedBox(height: 20),

            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Available Workers",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F3E6E),
                  ),
                ),
                Text(_selectedCounty),
              ],
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: workers.length,
                itemBuilder: (context, index) {
                  final worker = workers[index];
                  return _workerCard(worker);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5)
        ],
      ),
      child: DropdownButtonFormField(
        value: _selectedCounty,
        items: counties.map((c) {
          return DropdownMenuItem(value: c, child: Text(c));
        }).toList(),
        onChanged: (val) {
          setState(() => _selectedCounty = val.toString());
        },
        decoration: const InputDecoration(
          labelText: "Select County",
          prefixIcon: Icon(Icons.location_on),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _workerCard(Map worker) {
    final bool isVerified = worker['verified'] ?? false;
    final String status = worker['status'] ?? "available";

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkerDetailScreen(
              worker: worker,
              role: "employer",
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Row(
          children: [
            // 🔥 AVATAR
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isVerified ? Colors.green : Colors.orange,
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                radius: 26,
                backgroundColor: Color(0xFFE6EDD8),
                child: Icon(Icons.person, color: Color(0xFF2F3E6E)),
              ),
            ),

            const SizedBox(width: 15),

            // 🔥 DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    worker['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2F3E6E),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    worker['skills'] ?? "No skills listed",
                    style: const TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 6),

                  // 🔥 STATUS BADGE
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(status).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _statusColor(status),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🔥 ACTION BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA8C97F),
                foregroundColor: const Color(0xFF2F3E6E),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkerDetailScreen(
                      worker: worker,
                      role: "employer",
                    ),
                  ),
                );
              },
              child: const Text("Hire"),
            ),
          ],
        ),
      ),
    );
  }
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "available":
        return Colors.green;
      case "allocated":
        return Colors.orange;
      case "pending":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
  }