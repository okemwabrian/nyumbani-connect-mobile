import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../worker_ui/worker_dashboard.dart';
import '../agent_ui/agent_dashboard.dart';

class RegisterScreen extends StatefulWidget {
  final String? initialRole;
  const RegisterScreen({super.key, this.initialRole});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _step = 1;
  UserRole? _selectedRole;

  // Form Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _aboutController = TextEditingController();
  final _expController = TextEditingController();

  String? _selectedArea;

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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _aboutController.dispose();
    _expController.dispose();
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
        _fieldLabel("Location in Nairobi"),
        DropdownButtonFormField<String>(
          value: _selectedArea,
          items: ["Westlands", "Karen", "Kilimani", "Kasarani"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _selectedArea = v),
          decoration: const InputDecoration(hintText: "Select your area..."),
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
        const Text("National ID", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text("Upload a clear photo of your Kenya National ID (front side)", style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.05), 
            borderRadius: BorderRadius.circular(16), 
            border: Border.all(color: Colors.green.withValues(alpha: 0.2))
          ),
          child: Column(children: [
            const CircleAvatar(backgroundColor: Colors.green, radius: 24, child: Icon(Icons.check, color: Colors.white)),
            const SizedBox(height: 16),
            const Text("ID uploaded successfully!", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const Text("Screenshot 2024-05-10.png", style: TextStyle(color: Colors.black38, fontSize: 12)),
            TextButton(onPressed: () {}, child: const Text("Tap to change file")),
          ]),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
          child: const Row(children: [
            Icon(Icons.security, size: 16, color: Colors.blue),
            SizedBox(width: 12),
            Expanded(child: Text("Your ID is encrypted and stored securely.", style: TextStyle(fontSize: 12, color: Colors.black54))),
          ]),
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () => setState(() => _step = 4),
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
    final appState = Provider.of<AppState>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LinearProgressIndicator(value: 1.0),
        const SizedBox(height: 32),
        const Text("Profile", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text("Help employers know you better.", style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 32),
        _fieldLabel("About Yourself"),
        TextField(controller: _aboutController, maxLines: 4, decoration: const InputDecoration(hintText: "Tell employers a little about yourself...")),
        const SizedBox(height: 20),
        _fieldLabel("Skills"),
        Wrap(
          spacing: 8,
          children: appState.availableSkills.map((s) => FilterChip(
            label: Text(s),
            selected: appState.tempSkills.contains(s),
            onSelected: (_) => appState.toggleSkill(s),
          )).toList(),
        ),
        const SizedBox(height: 20),
        _fieldLabel("Years of Experience"),
        TextField(controller: _expController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "0")),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () {
            if (_selectedRole == null) return;
            appState.setRole(_selectedRole!);
            appState.completeRegistration(
              name: _nameController.text,
              phone: _phoneController.text,
              about: _aboutController.text,
              skills: appState.tempSkills,
              experience: int.tryParse(_expController.text) ?? 0,
            );
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (_) => _selectedRole == UserRole.worker ? const WorkerDashboard(workerName: "") : const AgentDashboard())
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF059669),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 8),
              Text("Complete Registration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
