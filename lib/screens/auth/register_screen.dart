import 'package:flutter/material.dart';
// We will import the dashboard so we can navigate to it after registering
import '../worker_ui/worker_dashboard.dart';

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

    if (picked != null && picked != _dateOfBirth) {
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

    // HCI: Give immediate positive feedback, then route to the dashboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration Successful!'), backgroundColor: Colors.green),
    );

    // If they registered as a worker, send them to the new Worker Dashboard
    if (_selectedRole == 'Worker') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WorkerDashboard(workerName: _nameController.text)),
      );
    }
  }

  // Helper method for clean, consistent HCI text fields
  InputDecoration _customInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Soft background to make the white card pop
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1E3A8A),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Join Nyumbani', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text('Enter your details below to get started.', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                  const SizedBox(height: 30),

                  TextField(controller: _nameController, decoration: _customInputDecoration('Full Name', Icons.person_outline)),
                  const SizedBox(height: 16),
                  TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: _customInputDecoration('Phone Number', Icons.phone_outlined)),
                  const SizedBox(height: 16),
                  TextField(controller: _passwordController, obscureText: true, decoration: _customInputDecoration('Password', Icons.lock_outline)),
                  const SizedBox(height: 24),

                  const Text('Role', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: _roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                    onChanged: (val) => setState(() { _selectedRole = val!; _errorMessage = ''; }),
                    decoration: _customInputDecoration('Select Role', Icons.work_outline),
                  ),
                  const SizedBox(height: 16),

                  if (_selectedRole == 'Worker') ...[
                    InkWell(
                      onTap: _selectDateOfBirth,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12), color: Colors.grey.shade50),
                        child: Row(
                          children: [
                            Icon(Icons.cake_outlined, color: Colors.grey.shade600),
                            const SizedBox(width: 12),
                            Text(_dateOfBirth == null ? 'Select Date of Birth' : 'DOB: ${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}', style: TextStyle(fontSize: 16, color: _dateOfBirth == null ? Colors.grey.shade700 : Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_errorMessage.isNotEmpty)
                    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.error_outline, color: Colors.red), const SizedBox(width: 8), Expanded(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))] )),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitRegistration,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2),
                    child: const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}