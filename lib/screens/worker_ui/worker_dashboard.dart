import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../providers/app_state.dart';
import '../../widgets/app_drawer.dart';

class WorkerDashboard extends StatefulWidget {
  final String workerName;

  const WorkerDashboard({super.key, required this.workerName});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Mock Job Feed Data
  final List<Map<String, dynamic>> _availableJobs = [
    {"title": "Full-time Nanny", "salary": "KSh 20,000", "location": "Nairobi", "posted": "1h ago"},
    {"title": "Professional Chef", "salary": "KSh 45,000", "location": "Mombasa", "posted": "3h ago"},
    {"title": "House Manager", "salary": "KSh 30,000", "location": "Kiambu", "posted": "5h ago"},
  ];

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Profile Photo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primaryTeal),
              title: const Text("Take Photo"),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: AppColors.primaryTeal),
              title: const Text("Choose from Gallery"),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isVerified = appState.isVerified;
    final statusColor = isVerified ? Colors.green : AppColors.secondarySage;

    return Scaffold(
      drawer: const AppDrawer(role: "worker"),
      appBar: AppBar(
        title: const Text("Worker Dashboard"),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROFILE CARD
            _buildProfileCard(appState, statusColor, isVerified),
            
            const SizedBox(height: 32),
            
            // EARNINGS SUMMARY (Mock)
            _buildEarningsCard(),

            const SizedBox(height: 32),
            
            // SMART JOB FEED
            const Text("Recommended Jobs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 16),
            if (!isVerified)
              _buildVerificationAlert()
            else
              ..._availableJobs.map((job) => _jobCard(job)),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(AppState appState, Color statusColor, bool isVerified) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primaryTeal.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Hero(
                tag: 'profile-pic',
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.bgSurface,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null ? const Icon(Icons.person, size: 60, color: AppColors.primaryTeal) : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: _showImageOptions,
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primaryTeal,
                    child: Icon(Icons.edit, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.workerName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glowing Indicator
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: statusColor, blurRadius: 4)]),
                ),
                const SizedBox(width: 8),
                Text(
                  appState.verificationStatus,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total Earnings", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
              const Text("KSh 12,500", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const Icon(Icons.account_balance_wallet_rounded, color: AppColors.tertiaryOlive, size: 40),
        ],
      ),
    );
  }

  Widget _jobCard(Map<String, dynamic> job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundColor: AppColors.bgSurface, child: Icon(Icons.work_rounded, color: AppColors.primaryTeal)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("${job['location']} • ${job['posted']}", style: const TextStyle(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                ),
                Text(job['salary'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleQuickApply(job['title']),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondarySage, minimumSize: const Size(0, 44)),
                child: const Text("QUICK APPLY", style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleQuickApply(String jobTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
        content: Text("Applied to $jobTitle!\nYour verified profile and ID status have been shared.", textAlign: TextAlign.center),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("AWESOME"))],
      ),
    );
  }

  Widget _buildVerificationAlert() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.tertiaryOlive.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.tertiaryOlive),
      ),
      child: const Column(
        children: [
          Icon(Icons.lock_person_rounded, color: AppColors.primaryTeal, size: 40),
          SizedBox(height: 12),
          Text(
            "Account Under Review",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            "Complete your ID verification to unlock the job board and start applying.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
