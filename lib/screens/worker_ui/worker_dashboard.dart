import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../utils/app_theme.dart';
import '../../providers/app_state.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/primary_button.dart';

class WorkerDashboard extends StatefulWidget {
  final String workerName;

  const WorkerDashboard({super.key, required this.workerName});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  File? _profileImage;
  List<File> _galleryImages = [];
  final ImagePicker _picker = ImagePicker();
  
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _isApplying = false;

  // Mock Data
  final List<Map<String, dynamic>> _availableJobs = [
    {"title": "Full-time Nanny", "salary": "KSh 20,000", "location": "Nairobi", "posted": "1h ago", "id": "1"},
    {"title": "Professional Chef", "salary": "KSh 45,000", "location": "Mombasa", "posted": "3h ago", "id": "2"},
  ];

  Future<void> _pickProfileImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  Future<void> _pickGalleryImages() async {
    final List<XFile> pickedList = await _picker.pickMultiImage();
    if (pickedList.isNotEmpty) {
      setState(() {
        _galleryImages.addAll(pickedList.map((x) => File(x.path)));
      });
    }
  }

  void _handleQuickApply(String jobTitle) async {
    setState(() => _isApplying = true);
    
    // Task B: Mock Delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isApplying = false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
        content: Text("Applied to $jobTitle!\nYour verified profile has been shared.", textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("AWESOME", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal))
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

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
            _buildProfileCard(appState),
            const SizedBox(height: 32),

            const Text("My Schedule", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildCalendar(),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Portfolio Gallery", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _pickGalleryImages,
                  icon: const Icon(Icons.add_a_photo_rounded, size: 18),
                  label: const Text("Add"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildGallery(),

            const SizedBox(height: 32),
            
            const Text("Recommended Jobs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (_availableJobs.isEmpty)
              const EmptyStateWidget(
                icon: Icons.work_off_rounded,
                title: "No jobs available",
                subtitle: "Check back later for new opportunities in your area.",
              )
            else
              ..._availableJobs.map((job) => _jobCard(job)),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(AppState appState) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.tertiaryOlive.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.bgSurface,
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null ? const Icon(Icons.person, size: 40, color: AppColors.primaryTeal) : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _pickProfileImage(ImageSource.gallery),
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primaryTeal,
                    child: Icon(Icons.edit, size: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.workerName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(appState.isVerified ? "Verified Professional" : "Verification Pending", 
                  style: TextStyle(color: appState.isVerified ? Colors.green : AppColors.secondarySage, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.tertiaryOlive.withOpacity(0.3)),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) => setState(() => _calendarFormat = format),
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(color: AppColors.secondarySage, shape: BoxShape.circle),
          selectedDecoration: BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle),
        ),
        headerStyle: const HeaderStyle(formatButtonVisible: true, titleCentered: true),
      ),
    );
  }

  Widget _buildGallery() {
    if (_galleryImages.isEmpty) {
      return Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.bgSurface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.tertiaryOlive, style: BorderStyle.solid),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, color: AppColors.secondarySage),
            Text("No portfolio photos yet", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );
    }
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _galleryImages.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: FileImage(_galleryImages[index]), fit: BoxFit.cover),
            ),
          );
        },
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
                      Text("${job['location']} • ${job['posted']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Text(job['salary'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: "Quick Apply",
              isLoading: _isApplying,
              onPressed: () => _handleQuickApply(job['title']),
              color: AppColors.secondarySage,
            ),
          ],
        ),
      ),
    );
  }
}
