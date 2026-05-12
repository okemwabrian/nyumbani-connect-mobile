import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/app_state.dart';
import '../../widgets/nyumbani_layout.dart';
import '../job_board_screen.dart';
import '../../models/job_model.dart';
import '../../models/application_model.dart';
import '../../utils/app_theme.dart';

class WorkerDashboard extends StatelessWidget {
  final String workerName; // For compatibility
  const WorkerDashboard({super.key, required this.workerName});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = FirebaseAuth.instance.currentUser;
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

            // Stats Cards (Task 4)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Applications')
                  .where('workerId', isEqualTo: user?.uid ?? '')
                  .snapshots(),
              builder: (context, snapshot) {
                int total = 0;
                int shortlisted = 0;
                int pending = 0;

                if (snapshot.hasData) {
                  total = snapshot.data!.docs.length;
                  shortlisted = snapshot.data!.docs.where((doc) => doc['status'] == 'Shortlisted').length;
                  pending = snapshot.data!.docs.where((doc) => doc['status'] == 'Pending').length;
                }

                return Row(
                  children: [
                    _StatCard(label: "Total Applied", value: total.toString(), icon: Icons.work_outline),
                    const SizedBox(width: 24),
                    _StatCard(label: "Shortlisted", value: shortlisted.toString(), icon: Icons.check_circle_outline, color: Colors.green),
                    const SizedBox(width: 24),
                    _StatCard(label: "Pending Review", value: pending.toString(), icon: Icons.timer_outlined, color: gold),
                  ],
                );
              }
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
            // Live Jobs Section (Task 4)
            const Text("Available Jobs Near You", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Jobs').orderBy('postedAt', descending: true).limit(5).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppColors.tertiaryOlive)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: Colors.black12),
                        const SizedBox(height: 16),
                        const Text("No jobs available in your area yet.", style: TextStyle(color: Colors.black38)),
                      ],
                    ),
                  );
                }

                final jobs = snapshot.data!.docs.map((doc) => JobModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

                return Column(
                  children: jobs.map((job) => _DashboardJobCard(job: job)).toList(),
                );
              },
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

class _DashboardJobCard extends StatefulWidget {
  final JobModel job;
  const _DashboardJobCard({required this.job});

  @override
  State<_DashboardJobCard> createState() => _DashboardJobCardState();
}

class _DashboardJobCardState extends State<_DashboardJobCard> {
  bool _isApplying = false;

  Future<void> _applyToJob() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isApplying = true);

    try {
      final query = await FirebaseFirestore.instance
          .collection('Applications')
          .where('jobId', isEqualTo: widget.job.jobId)
          .where('workerId', isEqualTo: user.uid)
          .get();

      if (query.docs.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You have already applied for this job.")),
          );
        }
        return;
      }

      final appId = FirebaseFirestore.instance.collection('Applications').doc().id;
      final application = ApplicationModel(
        applicationId: appId,
        jobId: widget.job.jobId,
        workerId: user.uid,
        employerId: widget.job.employerId,
        status: "Pending",
        appliedAt: DateTime.now(),
        jobTitle: widget.job.title,
      );

      await FirebaseFirestore.instance.collection('Applications').doc(appId).set(application.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Application submitted successfully!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to apply: $e"), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isApplying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.work_outline, color: AppColors.primaryTeal),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.job.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("${widget.job.employerName} • ${widget.job.county}", style: const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(widget.job.budget, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
              const SizedBox(height: 8),
              _isApplying 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : TextButton(
                    onPressed: _applyToJob,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text("Apply", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
            ],
          ),
        ],
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
