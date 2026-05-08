import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/app_theme.dart';
import '../../utils/counties.dart';
import '../../providers/app_state.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  final String initialRole;
  const RegisterScreen({super.key, required this.initialRole});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;
  String _selectedCounty = counties.first;
  bool _isRegistering = false;
  
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otherSkillController = TextEditingController();

  File? _idFront;
  File? _profilePic;
  List<File> _portfolio = [];
  final ImagePicker _picker = ImagePicker();

  final List<String> _baseSkills = [
    "Nanny / Childcare", "Elderly Care", "Housekeeping", "Cooking / Chef",
    "Gardening", "Driving", "Laundry & Ironing", "Pool Maintenance", "Security"
  ];

  Future<void> _pickFile(bool isID, {bool multi = false}) async {
    if (multi) {
      final List<XFile> picked = await _picker.pickMultiImage();
      if (picked.isNotEmpty) setState(() => _portfolio.addAll(picked.map((x) => File(x.path))));
    } else {
      final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          if (isID) _idFront = File(picked.path);
          else _profilePic = File(picked.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(themeProvider.translate('register'))),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0 && _formKey1.currentState!.validate()) setState(() => _currentStep++);
          else if (_currentStep == 1 && _formKey2.currentState!.validate()) setState(() => _currentStep++);
          else if (_currentStep == 2) _handleRegistration();
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: PrimaryButton(
              label: _currentStep == 2 ? themeProvider.translate('complete_setup') : themeProvider.translate('next_step'),
              isLoading: _isRegistering,
              onPressed: details.onStepContinue,
            ),
          );
        },
        steps: [
          Step(
            title: Text(themeProvider.translate('account')),
            isActive: _currentStep >= 0,
            content: Form(key: _formKey1, child: _buildAccountInfo(themeProvider)),
          ),
          Step(
            title: Text(themeProvider.translate('details')),
            isActive: _currentStep >= 1,
            content: Form(key: _formKey2, child: _buildDetailInfo(themeProvider)),
          ),
          Step(
            title: const Text("Files"),
            isActive: _currentStep >= 2,
            content: _buildUploads(themeProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(ThemeProvider tp) {
    return Column(
      children: [
        CustomTextField(
          controller: _usernameController, 
          label: "${tp.translate('username')} (Compulsory)", 
          icon: Icons.person_rounded, 
          validator: (v) => (v == null || v.isEmpty) ? tp.translate('required_error') : null
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController, 
          label: "${tp.translate('email')} (Optional)", 
          icon: Icons.email_outlined, 
          keyboardType: TextInputType.emailAddress
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _phoneController, 
          label: "${tp.translate('phone')} (Compulsory)", 
          icon: Icons.phone_iphone_rounded, 
          keyboardType: TextInputType.phone, 
          validator: (v) => (v == null || v.isEmpty) ? tp.translate('required_error') : null
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController, 
          label: tp.translate('password'), 
          icon: Icons.lock_outline_rounded, 
          isPassword: true, 
          validator: (v) => (v == null || v.length < 6) ? tp.translate('password_error') : null
        ),
      ],
    );
  }

  Widget _buildDetailInfo(ThemeProvider tp) {
    if (widget.initialRole == 'worker') {
      return Consumer<AppState>(
        builder: (context, appState, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tp.translate('skills'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _baseSkills.map((s) => FilterChip(
                label: Text(s),
                selected: appState.selectedSkills.contains(s),
                onSelected: (val) => appState.toggleSkill(s),
              )).toList(),
            ),
            const SizedBox(height: 16),
            CustomTextField(controller: _otherSkillController, label: "Other Skills (Separate with commas)", icon: Icons.add_circle_outline_rounded),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCounty,
              items: counties.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCounty = v!),
              decoration: InputDecoration(labelText: tp.translate('county'), border: const OutlineInputBorder()),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedCounty,
            items: counties.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _selectedCounty = v!),
            decoration: InputDecoration(labelText: tp.translate('county'), border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          CustomTextField(controller: TextEditingController(), label: widget.initialRole == 'agent' ? "Bureau Name" : "Physical Address", icon: Icons.home_work_rounded),
        ],
      );
    }
  }

  Widget _buildUploads(ThemeProvider tp) {
    return Column(
      children: [
        _uploadTile(tp.translate('id_required'), _idFront, () => _pickFile(true)),
        const SizedBox(height: 16),
        _uploadTile("Profile Picture", _profilePic, () => _pickFile(false)),
        if (widget.initialRole == 'worker') ...[
          const SizedBox(height: 16),
          const Text("Portfolio Images (Work proof)", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _pickFile(false, multi: true),
            child: Container(
              height: 100,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
              child: _portfolio.isEmpty 
                ? const Center(child: Icon(Icons.add_a_photo_outlined))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _portfolio.length,
                    itemBuilder: (context, i) => Padding(padding: const EdgeInsets.all(4), child: Image.file(_portfolio[i], width: 80, fit: BoxFit.cover)),
                  ),
            ),
          )
        ],
      ],
    );
  }

  Widget _uploadTile(String label, File? file, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: AppColors.tertiaryOlive), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(file == null ? Icons.cloud_upload_outlined : Icons.check_circle, color: file == null ? Colors.grey : Colors.green),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            if (file != null) ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(file, width: 40, height: 40, fit: BoxFit.cover)),
          ],
        ),
      ),
    );
  }

  void _handleRegistration() async {
    if (_idFront == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ID Document is compulsory.")));
      return;
    }
    setState(() => _isRegistering = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isRegistering = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Registration Successful"),
          content: const Text("Your documents have been submitted for verification. You can now login."),
          actions: [TextButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text("OK"))],
        ),
      );
    }
  }
}
