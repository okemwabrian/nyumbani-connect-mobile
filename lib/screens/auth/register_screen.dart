import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/counties.dart';
import '../../providers/app_state.dart';

class RegisterScreen extends StatefulWidget {
  final String initialRole;
  const RegisterScreen({super.key, required this.initialRole});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;
  String _selectedCounty = counties.first;
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Digital Onboarding")),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _handleRegistration();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: ElevatedButton(
              onPressed: details.onStepContinue,
              child: Text(_currentStep == 2 ? "COMPLETE VERIFICATION" : "NEXT STEP"),
            ),
          );
        },
        steps: [
          Step(
            title: const Text("Profile"),
            isActive: _currentStep >= 0,
            content: _buildBasicInfo(),
          ),
          Step(
            title: const Text("Expertise"),
            isActive: _currentStep >= 1,
            content: _buildRoleSpecificInfo(),
          ),
          Step(
            title: const Text("Security"),
            isActive: _currentStep >= 2,
            content: _buildVerificationStep(),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      children: [
        TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Legal Name")),
        const SizedBox(height: 16),
        TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Active Phone Number")),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedCounty,
          decoration: const InputDecoration(labelText: "Primary County"),
          items: counties.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (val) => setState(() => _selectedCounty = val!),
        ),
      ],
    );
  }

  Widget _buildRoleSpecificInfo() {
    if (widget.initialRole == 'worker') {
      return Consumer<AppState>(
        builder: (context, appState, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Smart Skill Clusters", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Text("Select a cluster to auto-populate your skills.", style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 16),
            ...appState.skillClusters.keys.map((cluster) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ActionChip(
                label: Text(cluster),
                onPressed: () => appState.autoSelectCluster(cluster),
                backgroundColor: AppColors.tertiaryOlive.withOpacity(0.3),
              ),
            )),
            const Divider(height: 32),
            const Text("Individual Skills", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: appState.selectedSkills.map((skill) => Chip(
                label: Text(skill),
                onDeleted: () => appState.toggleSkill(skill),
                deleteIconColor: AppColors.primaryTeal,
              )).toList(),
            ),
          ],
        ),
      );
    }
    return const Column(
      children: [
        TextField(decoration: InputDecoration(labelText: "Bureau/Employer Details")),
        SizedBox(height: 16),
        TextField(decoration: InputDecoration(labelText: "Tax/Business ID")),
      ],
    );
  }

  Widget _buildVerificationStep() {
    final appState = Provider.of<AppState>(context);
    return Column(
      children: [
        const Text("Biometric & ID Capture", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 24),
        InkWell(
          onTap: () {
            // Automation: Mock ID extraction
            appState.processNationalID("ID-19921015-ABC");
          },
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryTeal, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.qr_code_scanner_rounded, size: 40, color: AppColors.primaryTeal),
                const SizedBox(height: 8),
                const Text("Scan National ID", style: TextStyle(fontWeight: FontWeight.bold)),
                if (appState.calculatedAge != null)
                  Text("Age Verified: ${appState.calculatedAge} Years", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text("ID parsing automatically extracts age and DOB to ensure 18+ compliance.", 
          textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.black54)),
      ],
    );
  }

  void _handleRegistration() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Onboarding Successful! Welcome to Nyumbani."), backgroundColor: AppColors.primaryTeal),
    );
  }
}
