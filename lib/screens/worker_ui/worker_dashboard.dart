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

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profile Photo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primaryTeal),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: AppColors.primaryTeal),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
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
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // PROFILE CARD
            _buildProfileCard(appState, statusColor, isVerified),

            const SizedBox(height: 24),

            // VERIFICATION ALERT
            if (!isVerified)
              _buildVerificationAlert(),

            const SizedBox(height: 24),

            // INFO CARDS
            _infoCard(
              Icons.stars_rounded,
              "My Skills",
              appState.selectedSkills.isEmpty
                ? "No skills selected"
                : appState.selectedSkills.join(", ")
            ),

            const SizedBox(height: 24),
            
            // JOB BOARD ACCESS
            _buildJobBoardButton(isVerified),
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
                  backgroundColor: AppColors.bgPale,
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
                Icon(isVerified ? Icons.verified_rounded : Icons.pending_rounded, size: 16, color: statusColor),
                const SizedBox(width: 8),
                Text(
                  appState.verificationStatus,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tertiaryOlive.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.tertiaryOlive),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.primaryTeal),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Your ID is being reviewed. You will have full access once verified.",
              style: TextStyle(color: AppColors.textDark, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobBoardButton(bool isVerified) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isVerified ? () {
          // Navigate to Job Board
        } : null,
        icon: const Icon(Icons.search_rounded),
        label: const Text("BROWSE JOB BOARD"),
        style: ElevatedButton.styleFrom(
          backgroundColor: isVerified ? AppColors.primaryTeal : Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.bgPale,
            child: Icon(icon, color: AppColors.primaryTeal),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
