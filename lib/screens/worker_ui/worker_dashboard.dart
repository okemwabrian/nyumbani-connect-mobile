import 'dart:io'; // Needed to handle the image file
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WorkerDashboard extends StatefulWidget {
  final String workerName;

  const WorkerDashboard({super.key, required this.workerName});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  // Variable to store the selected image
  File? _profileImage;
  // Instance of the picker
  final ImagePicker _picker = ImagePicker();

  // Function to actually pick the image
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  // HCI: Show a bottom sheet asking Camera or Gallery
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Upload Profile Picture', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFF1E3A8A)),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _pickImage(ImageSource.camera); // Open Camera
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF1E3A8A)),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _pickImage(ImageSource.gallery); // Open Gallery
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('My Dashboard'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Profile Header Background
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A8A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 30, top: 20),
              child: Column(
                children: [
                  // Profile Image Upload Area
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.grey.shade300,
                          // If we have an image, show it. Otherwise, stay null.
                          backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                          // If we DO NOT have an image, show the default icon.
                          child: _profileImage == null
                              ? const Icon(Icons.person, size: 60, color: Colors.grey)
                              : null,
                        ),
                      ),
                      // Edit Image Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.black87, size: 20),
                          onPressed: _showImageSourceDialog, // Trigger the bottom sheet
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.workerName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Text(
                    'House Manager',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Status & Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
                            child: const Icon(Icons.pending_actions, color: Colors.orange, size: 30),
                          ),
                          const SizedBox(width: 20),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Verification Status', style: TextStyle(fontSize: 14, color: Colors.grey)),
                                SizedBox(height: 4),
                                Text('Pending ID Check', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text('My Profile Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                  const SizedBox(height: 10),

                  ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
                    title: const Text('Location'),
                    subtitle: const Text('Not set'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: const Icon(Icons.work_outline, color: Colors.grey),
                    title: const Text('Experience'),
                    subtitle: const Text('Not set'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
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