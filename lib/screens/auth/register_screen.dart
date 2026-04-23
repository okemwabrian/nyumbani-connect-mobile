import 'package:flutter/material.dart';
import '../../utils/counties.dart';
import '../worker_ui/worker_dashboard.dart';
import '../employer_ui/employer_dashboard.dart';

class RegisterScreen extends StatefulWidget {
  final String initialRole;

  const RegisterScreen({super.key, required this.initialRole});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = "worker";
  String _selectedCounty = counties.first;
  DateTime? _dob;

  String _error = '';

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole.toLowerCase();
  }

  void _submit() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _error = "Fill all fields");
      return;
    }

    if (_selectedRole == "worker") {
      if (_dob == null) {
        setState(() => _error = "Select date of birth");
        return;
      }

      final age = DateTime.now().year - _dob!.year;
      if (age < 18) {
        setState(() => _error = "Must be 18+");
        return;
      }
    }

    // 🔥 TEMP ROUTING (UI MODE)
    if (_selectedRole == "worker") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WorkerDashboard(workerName: _nameController.text),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => EmployerDashboard(
            userName: _nameController.text,
            role: _selectedRole,
          ),
        ),
      );
    }
  }

  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF2F3E6E)),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _roleCard(String role, IconData icon) {
    final selected = _selectedRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFA8C97F) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF2F3E6E)),
              const SizedBox(height: 6),
              Text(role.toUpperCase()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),

      appBar: AppBar(
        title: const Text("Register"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create Account",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F3E6E),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 INPUTS
            TextField(
              controller: _nameController,
              decoration: _input("Full Name", Icons.person),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _phoneController,
              decoration: _input("Phone Number", Icons.phone),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: _input("Password", Icons.lock),
            ),

            const SizedBox(height: 20),

            // 🔥 ROLE
            const Text("Select Role"),
            const SizedBox(height: 10),
            Row(
              children: [
                _roleCard("worker", Icons.person),
                const SizedBox(width: 10),
                _roleCard("employer", Icons.business),
                const SizedBox(width: 10),
                _roleCard("agent", Icons.admin_panel_settings),
              ],
            ),

            const SizedBox(height: 20),

            // 🔥 COUNTY
            const Text("County"),
            const SizedBox(height: 10),

            DropdownButtonFormField(
              value: _selectedCounty,
              items: counties.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedCounty = val.toString());
              },
              decoration: _input("Select County", Icons.location_on),
            ),

            const SizedBox(height: 20),

            // 🔥 DOB
            if (_selectedRole == "worker") ...[
              GestureDetector(
                onTap: _pickDOB,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cake, color: Color(0xFF2F3E6E)),
                      const SizedBox(width: 10),
                      Text(
                        _dob == null
                            ? "Select Date of Birth"
                            : "${_dob!.day}/${_dob!.month}/${_dob!.year}",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // 🔥 ERROR
            if (_error.isNotEmpty)
              Text(
                _error,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 20),

            // 🔥 BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}