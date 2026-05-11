import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../widgets/nyumbani_layout.dart';
import '../job_board_screen.dart';

class WorkerDashboard extends StatelessWidget {
  final String workerName; // For compatibility
  const WorkerDashboard({super.key, required this.workerName});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    const Color gold = Color(0xFFFBBF24);

    return NyumbaniLayout(
      title: "Dashboard",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Welcome back, ${appState.name ?? "User"}", 
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Icons.front_hand_rounded, color: gold),
              ],
            ),
            const Text("Here's your activity overview.", style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 32),

            // ID Verification Pending Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: gold.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active_outlined, color: Color(0xFF92400E)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("ID Verification Pending", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                        Text("Our team is reviewing your National ID. You can still browse and apply for jobs.", 
                          style: TextStyle(color: Color(0xFF92400E), fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Stats Cards
            Row(
              children: [
                _StatCard(label: "Total Applied", value: appState.totalApplied.toString(), icon: Icons.work_outline),
                const SizedBox(width: 24),
                _StatCard(label: "Shortlisted", value: appState.shortlisted.toString(), icon: Icons.check_circle_outline, color: Colors.green),
                const SizedBox(width: 24),
                _StatCard(label: "Pending Review", value: appState.pendingReview.toString(), icon: Icons.timer_outlined, color: gold),
              ],
            ),
            const SizedBox(height: 48),

            // Find Job Card
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Find Your Next Job", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("Browse verified job openings across Nairobi.", style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JobBoardScreen())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D4ED8),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: const Text("Job Board →"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // My Applications Section
            const Text("My Applications", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 64),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.work_history_outlined, size: 48, color: Colors.black12),
                  const SizedBox(height: 16),
                  const Text("You haven't applied to any jobs yet.", style: TextStyle(color: Colors.black38)),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JobBoardScreen())), 
                    child: const Text("Job Board", style: TextStyle(fontWeight: FontWeight.bold))
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _StatCard({required this.label, required this.value, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: (color ?? Colors.blue).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color ?? Colors.blue, size: 20),
            ),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
