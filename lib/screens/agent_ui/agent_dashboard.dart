import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../widgets/nyumbani_layout.dart';

class AgentDashboard extends StatelessWidget {
  const AgentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    const Color gold = Color(0xFFFBBF24);

    return NyumbaniLayout(
      title: "Agent Dashboard",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                    const Text("Here's your bureau overview.", style: TextStyle(color: Colors.black54)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {}, 
                  icon: const Icon(Icons.add), 
                  label: const Text("Post a Job"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Stats Cards
            Row(
              children: const [
                _AgentStatCard(label: "Active Jobs", value: "0", icon: Icons.work_outline),
                const SizedBox(width: 24),
                _AgentStatCard(label: "Total Applications", value: "0", icon: Icons.people_outline, color: Colors.blue),
                const SizedBox(width: 24),
                _AgentStatCard(label: "Shortlisted", value: "0", icon: Icons.check_circle_outline, color: Colors.green),
              ],
            ),
            const SizedBox(height: 48),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _AgentCard(
                    title: "My Job Posts",
                    content: Column(
                      children: [
                        const SizedBox(height: 32),
                        const Text("No jobs posted yet.", style: TextStyle(color: Colors.black38)),
                        TextButton(onPressed: () {}, child: const Text("Post a Job")),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: _AgentCard(
                    title: "Candidates",
                    content: Column(
                      children: const [
                        SizedBox(height: 32),
                        Text("No applications received yet.", style: TextStyle(color: Colors.black38)),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AgentStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _AgentStatCard({required this.label, required this.value, required this.icon, this.color});

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

class _AgentCard extends StatelessWidget {
  final String title;
  final Widget content;

  const _AgentCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(height: 32),
          content,
        ],
      ),
    );
  }
}
