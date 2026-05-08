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
            title: const Text("Details"),
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
        TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Legal Name", prefixIcon: Icon(Icons.person_outline))),
        const SizedBox(height: 16),
        TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Active Phone Number", prefixIcon: Icon(Icons.phone_iphone_rounded))),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedCounty,
          decoration: const InputDecoration(labelText: "Primary County", prefixIcon: Icon(Icons.location_on_outlined)),
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
            const Text("Smart Skill Clusters", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryTeal)),
            const Text("Select a cluster to auto-populate your expertise.", style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: appState.skillClusters.keys.map((cluster) => ActionChip(
                label: Text(cluster),
                onPressed: () => appState.autoSelectCluster(cluster),
                backgroundColor: AppColors.tertiaryOlive.withValues(alpha: 0.3),
              )).toList(),
            ),
            const Divider(height: 40),
            const Text("Your Selected Skills", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
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
    } else if (widget.initialRole == 'agent') {
      return const Column(
        children: [
          TextField(decoration: InputDecoration(labelText: "Bureau Name", prefixIcon: Icon(Icons.business_rounded))),
          SizedBox(height: 16),
          TextField(decoration: InputDecoration(labelText: "Business Permit Number", prefixIcon: Icon(Icons.verified_user_rounded))),
          SizedBox(height: 16),
          TextField(decoration: InputDecoration(labelText: "Physical Office Address", prefixIcon: Icon(Icons.map_rounded))),
        ],
      );
    } else {
      return const Column(
        children: [
          Text("Employer Information", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
          SizedBox(height: 16),
          TextField(decoration: InputDecoration(labelText: "Home Address", prefixIcon: Icon(Icons.home_outlined))),
          SizedBox(height: 16),
          TextField(decoration: InputDecoration(labelText: "Emergency Contact", prefixIcon: Icon(Icons.contact_phone_outlined))),
        ],
      );
    }
  }

  Widget _buildVerificationStep() {
    final appState = Provider.of<AppState>(context);
    return Column(
      children: [
        const Text("Biometric & ID Capture", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryTeal)),
        const SizedBox(height: 24),
        InkWell(
          onTap: () {
            // Automation: Mock ID extraction
            appState.processNationalID("ID-19921015-ABC");
          },
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.tertiaryOlive, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.qr_code_scanner_rounded, size: 48, color: AppColors.primaryTeal),
                const SizedBox(height: 12),
                const Text("Scan National ID", style: TextStyle(fontWeight: FontWeight.bold)),
                if (appState.calculatedAge != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text("Age Verified: ${appState.calculatedAge} Years", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text("Our HCI logic extracts Age and DOB to ensure 18+ compliance without manual entry.", 
          textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.black54)),
      ],
    );
  }

  void _handleRegistration() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
        content: const Text("Digital Onboarding Complete!\nYour details are being verified by our automated system.", textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }, 
            child: const Text("CONTINUE TO LOGIN", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal))
          ),
        ],
      ),
    );
  }
}
