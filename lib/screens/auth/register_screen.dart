import 'package:flutter/material.dart';
import '../worker_ui/worker_dashboard.dart';
import '../employer_ui/employer_dashboard.dart'; // Import the new dashboard

class RegisterScreen extends StatefulWidget {
  final String initialRole;
  const RegisterScreen({super.key, required this.initialRole});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late String _selectedRole;
  final List<String> _roles = ['Worker', 'Employer', 'Agent'];
  DateTime? _dateOfBirth;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 18),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
        _errorMessage = '';
      });
    }
  }

  void _submitRegistration() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }

    if (_selectedRole == 'Worker') {
      if (_dateOfBirth == null) {
        setState(() => _errorMessage = 'Please select your Date of Birth.');
        return;
      }
      DateTime today = DateTime.now();
      int age = today.year - _dateOfBirth!.year;
      if (today.month < _dateOfBirth!.month || (today.month == _dateOfBirth!.month && today.day < _dateOfBirth!.day)) age--;

      if (age < 18) {
        setState(() => _errorMessage = 'You must be at least 18 years old to register as a worker.');
        return;
      }
    }

    // Routing Logic: Send them to the right dashboard!
    if (_selectedRole == 'Worker') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WorkerDashboard(workerName: _nameController.text)));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmployerDashboard(userName: _nameController.text, role: _selectedRole)));
    }
  }

  // Stylish Input Decoration
  InputDecoration _customInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1E3A8A)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFD97706), width: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1E3A8A),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Account', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                  SizedBox(height: 10),
                  Text('Fill in your details to join Nyumbani Connect.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Form Container
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(controller: _nameController, decoration: _customInputDecoration('Full Name', Icons.person_outline)),
                  const SizedBox(height: 20),
                  TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: _customInputDecoration('Phone Number', Icons.phone_outlined)),
                  const SizedBox(height: 20),
                  TextField(controller: _passwordController, obscureText: true, decoration: _customInputDecoration('Password', Icons.lock_outline)),
                  const SizedBox(height: 20),

                  // Role Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: _roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                    onChanged: (val) => setState(() { _selectedRole = val!; _errorMessage = ''; }),
                    decoration: _customInputDecoration('Select Role', Icons.work_outline),
                  ),
                  const SizedBox(height: 20),

                  if (_selectedRole == 'Worker') ...[
                    InkWell(
                      onTap: _selectDateOfBirth,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
                        child: Row(
                          children: [
                            const Icon(Icons.cake_outlined, color: Color(0xFF1E3A8A)),
                            const SizedBox(width: 15),
                            Text(_dateOfBirth == null ? 'Select Date of Birth (Must be 18+)' : 'DOB: ${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}', style: TextStyle(fontSize: 16, color: _dateOfBirth == null ? Colors.grey.shade600 : Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(_errorMessage, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitRegistration,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5
                    ),
                    child: const Text('Register Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 40), // Extra padding for scrolling
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}