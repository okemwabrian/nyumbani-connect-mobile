import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../providers/app_state.dart';
import '../../widgets/app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  final String role;

  const ProfileScreen({super.key, required this.role});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: "John Doe");
    phoneController = TextEditingController(text: "0712345678");
  }

  void saveProfile() {
    setState(() => isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully"), backgroundColor: AppColors.primaryTeal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      drawer: AppDrawer(role: widget.role),
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check_circle_rounded : Icons.edit_note_rounded),
            onPressed: () {
              if (isEditing) saveProfile();
              else setState(() => isEditing = true);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // PROFILE IMAGE SECTION
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.secondarySage, width: 3),
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 60, color: AppColors.primaryTeal),
                    ),
                  ),
                  if (isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primaryTeal,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // FORM FIELDS
            _buildField("Full Name", nameController, Icons.person_outline),
            _buildField("Phone Number", phoneController, Icons.phone_android_rounded),
            
            _infoRow("County", "Nairobi", Icons.location_on_outlined),
            
            if (widget.role == "worker") ...[
              const Divider(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Verified Expertise", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: appState.selectedSkills.map((skill) => Chip(
                  label: Text(skill),
                  backgroundColor: AppColors.tertiaryOlive.withOpacity(0.3),
                  side: BorderSide.none,
                )).toList(),
              ),
            ],

            const SizedBox(height: 40),
            if (isEditing)
              ElevatedButton(
                onPressed: saveProfile,
                child: const Text("SAVE CHANGES"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primaryTeal),
          filled: true,
          fillColor: isEditing ? Colors.white : Colors.transparent,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.tertiaryOlive, width: 0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryTeal, size: 22),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(color: Colors.black54)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ],
      ),
    );
  }
}
