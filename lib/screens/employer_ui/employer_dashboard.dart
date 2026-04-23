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

  // 🔥 TEMP DATA (UI MODE)
  List workers = [
    {"name": "Jane Doe", "skills": "Cooking"},
    {"name": "Mary Wanjiku", "skills": "Cleaning"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: AppDrawer(role: widget.role), // 🔥 FIXED
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
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Search Workers",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F3E6E),
                    ),
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField(
                    value: _selectedCounty,
                    items: counties.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _selectedCounty = val.toString());
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 LIST HEADER
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
                Text(
                  _selectedCounty,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // 🔥 WORKER LIST
            Expanded(
              child: ListView.builder(
                itemCount: workers.length,
                itemBuilder: (context, index) {
                  final worker = workers[index];

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
                          radius: 25,
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
                                worker['skills'],
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA8C97F),
                            foregroundColor: const Color(0xFF2F3E6E),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHireDialog(String workerName) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Hire $workerName"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Job Description",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Job Created")),
              );
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
}