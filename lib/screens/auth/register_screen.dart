import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../utils/counties.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firebase_storage_service.dart';
import '../worker_ui/worker_dashboard.dart';
import '../agent_ui/agent_dashboard.dart';
import '../navigation/worker_nav.dart';
import '../navigation/employer_nav.dart';
import '../navigation/agent_nav.dart';

class RegisterScreen extends StatefulWidget {
  final String? initialRole;
  const RegisterScreen({super.key, this.initialRole});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _step = 1;
  UserRole? _selectedRole;

  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseStorageService _storageService = FirebaseStorageService();
  final ImagePicker _picker = ImagePicker();
  XFile? _idImage;
  XFile? _profileImage;
  bool _isUploading = false;
  String? _uploadedImageUrl;
  String? _uploadedProfileUrl;

  // Form Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _aboutController = TextEditingController();
  final _expController = TextEditingController();

  String? _selectedArea;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _idImage = image;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  void _handleRegistration() async {
    if (_selectedRole == null) return;
    
    setState(() => _isUploading = true);

    try {
      // 1. Upload ID Image if exists
      if (_idImage != null) {
        _uploadedImageUrl = await _storageService.uploadImage(
          File(_idImage!.path), 
          'id_cards/${_phoneController.text.trim()}_id.jpg'
        );
      }

      // 2. Upload Profile Image if exists
      if (_profileImage != null) {
        _uploadedProfileUrl = await _storageService.uploadImage(
          File(_profileImage!.path), 
          'profile_pics/${_phoneController.text.trim()}_profile.jpg'
        );
      }
    
      final error = await _authService.registerWithEmailAndPassword(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        password: "password123", // Default password for now
        role: _selectedRole.toString().split('.').last,
        county: _selectedArea,
        extraData: {
          'about': _aboutController.text,
          'skills': _userSkills,
          'experience': int.tryParse(_expController.text) ?? 0,
          'idImageUrl': _uploadedImageUrl,
          'profileImageUrl': _uploadedProfileUrl,
        }
      );

      if (!mounted) return;
      setState(() => _isUploading = false);

      if (error == null) {
        final roleStr = _selectedRole.toString().split('.').last;
        final userPhone = _phoneController.text.trim();
        
        Provider.of<AppState>(context, listen: false).setSession(roleStr, userPhone);

        Widget nextScreen;
        if (_selectedRole == UserRole.worker) {
          nextScreen = WorkerNav(phone: userPhone);
        } else if (_selectedRole == UserRole.agent) {
          nextScreen = const AgentNav();
        } else {
          nextScreen = EmployerNav(phone: userPhone);
        }

        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (_) => nextScreen),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error during registration: $e"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialRole != null) {
      if (widget.initialRole == 'worker') {
        _selectedRole = UserRole.worker;
      } else if (widget.initialRole == 'agent') {
        _selectedRole = UserRole.agent;
      } else if (widget.initialRole == 'employer') {
        _selectedRole = UserRole.employer;
      }
    }
  }

  final _skillController = TextEditingController();
  final List<String> _userSkills = [];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _aboutController.dispose();
    _expController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), 
          onPressed: () {
            if (_step > 1) {
              setState(() => _step--);
            } else {
              Navigator.pop(context);
            }
          }
        ),
        title: _step > 1 ? Text("Step $_step of 4", style: const TextStyle(color: Colors.black54, fontSize: 14)) : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _buildCurrentStep(),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 1: return _step1();
      case 2: return _step2();
      case 3: return _step3();
      case 4: return _step4();
      default: return const SizedBox();
    }
  }

  // --- Step 1: Role Selection ---
  Widget _step1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("How will you use Nyumbani?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("Select the option that best describes you.", style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 32),
        _roleCard(UserRole.worker, "House Manager", "Find trusted work in homes across Nairobi", Icons.home_rounded),
        const SizedBox(height: 16),
        _roleCard(UserRole.agent, "Agent / Employer", "Post jobs and find verified house managers", Icons.business_center_rounded),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: _selectedRole != null ? () => setState(() => _step = 2) : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
          ),
          child: const Text("Next →"),
        ),
      ],
    );
  }

  Widget _roleCard(UserRole role, String title, String sub, IconData icon) {
    bool isSelected = _selectedRole == role;
    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF1E293B) : Colors.black12, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12), 
              decoration: BoxDecoration(
                color: Colors.black12.withValues(alpha: 0.05), 
                borderRadius: BorderRadius.circular(12)
              ), 
              child: Icon(icon, color: Colors.black54)
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(sub, style: const TextStyle(color: Colors.black54, fontSize: 13)),
            ])),
          ],
        ),
      ),
    );
  }

  // --- Step 2: Personal Info ---
  Widget _step2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LinearProgressIndicator(value: 0.33),
        const SizedBox(height: 32),
        const Text("Personal Information", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text("Your information is safe and encrypted.", style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 32),
        _fieldLabel("Full Name"),
        TextField(controller: _nameController, decoration: const InputDecoration(hintText: "e.g. Amina Wanjiku")),
        const SizedBox(height: 20),
        _fieldLabel("Phone Number"),
        TextField(controller: _phoneController, decoration: const InputDecoration(hintText: "+254 7XX XXX XXX")),
        const SizedBox(height: 20),
        _fieldLabel("Date of Birth"),
        TextField(
          controller: _dobController, 
          decoration: const InputDecoration(hintText: "mm/dd/yyyy", suffixIcon: Icon(Icons.calendar_today)),
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context, 
              firstDate: DateTime(1900), 
              lastDate: DateTime.now(),
              initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
            );
            if (picked != null) {
              setState(() {
                _dobController.text = "${picked.month}/${picked.day}/${picked.year}";
              });
            }
          },
        ),
        const Text("You must be 18 years or older to register", style: TextStyle(color: Colors.black54, fontSize: 12)),
        const SizedBox(height: 20),
        _fieldLabel("Location in Kenya"),
        DropdownButtonFormField<String>(
          value: _selectedArea,
          items: counties.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _selectedArea = v),
          decoration: const InputDecoration(
            hintText: "Select your county...",
            border: OutlineInputBorder(),
          ),
          menuMaxHeight: 300,
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () => setState(() => _step = 3),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
          ),
          child: const Text("Next →"),
        ),
      ],
    );
  }

  // --- Step 3: National ID ---
  Widget _step3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LinearProgressIndicator(value: 0.67),
        const SizedBox(height: 32),
        const Text("National ID Verification", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text("Upload a clear photo of your Kenya National ID (front side)", style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 32),
        
        InkWell(
          onTap: _isUploading ? null : _pickImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12, style: BorderStyle.solid),
            ),
            child: _idImage != null 
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(File(_idImage!.path), width: double.infinity, height: 200, fit: BoxFit.cover),
                    ),
                    if (_isUploading)
                      Container(
                        color: Colors.black45,
                        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                      )
                    else
                      Positioned(
                        bottom: 8, right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 16,
                          child: Icon(Icons.check, color: Colors.white, size: 20),
                        ),
                      ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, size: 48, color: Colors.black26),
                    const SizedBox(height: 12),
                    Text(_isUploading ? "Uploading..." : "Tap to upload ID Card", style: const TextStyle(color: Colors.black45)),
                  ],
                ),
          ),
        ),
        
        if (_idImage != null && !_isUploading)
          Center(
            child: TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.refresh),
              label: const Text("Replace Image"),
            ),
          ),
          
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
          child: const Row(children: [
            Icon(Icons.security, size: 16, color: Colors.blue),
            SizedBox(width: 12),
            Expanded(child: Text("Your ID is encrypted and stored securely for verification purposes only.", style: TextStyle(fontSize: 12, color: Colors.black54))),
          ]),
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: (_idImage != null && !_isUploading) ? () => setState(() => _step = 4) : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
          ),
          child: const Text("Next →"),
        ),
      ],
    );
  }

  // --- Step 4: Profile ---
  Widget _step4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LinearProgressIndicator(value: 1.0),
        const SizedBox(height: 32),
        const Text("Professional Profile", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text("Showcase your skills and experience.", style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 32),
        
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.black12,
                backgroundImage: _profileImage != null ? FileImage(File(_profileImage!.path)) : null,
                child: _profileImage == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
              ),
              Positioned(
                bottom: 0, right: 0,
                child: GestureDetector(
                  onTap: _pickProfileImage,
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF1D4ED8),
                    child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Center(child: Text("Upload Profile Picture", style: TextStyle(color: Colors.black54, fontSize: 12))),
        const SizedBox(height: 32),

        _fieldLabel("About Yourself"),
        TextField(controller: _aboutController, maxLines: 4, decoration: const InputDecoration(hintText: "Briefly describe your work history and strengths...", border: OutlineInputBorder())),
        const SizedBox(height: 20),
        
        _fieldLabel("Your Skills"),
        const Text("Type a skill (e.g. Cooking) and press Enter", style: TextStyle(color: Colors.black45, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          controller: _skillController,
          decoration: const InputDecoration(
            hintText: "Add a skill...",
            suffixIcon: Icon(Icons.add),
            border: OutlineInputBorder(),
          ),
          onSubmitted: (val) {
            if (val.trim().isNotEmpty) {
              setState(() {
                _userSkills.add(val.trim());
                _skillController.clear();
              });
            }
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _userSkills.map((skill) => Chip(
            label: Text(skill),
            onDeleted: () => setState(() => _userSkills.remove(skill)),
            backgroundColor: const Color(0xFFECFDF5),
            labelStyle: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold),
            deleteIconColor: Colors.redAccent,
          )).toList(),
        ),
        
        const SizedBox(height: 20),
        _fieldLabel("Years of Experience"),
        TextField(controller: _expController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "e.g. 5", border: OutlineInputBorder())),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: _isUploading ? null : _handleRegistration,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF059669),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isUploading 
            ? const CircularProgressIndicator(color: Colors.white)
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Complete Registration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ],
              ),
        ),
      ],
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)));
  }
}
