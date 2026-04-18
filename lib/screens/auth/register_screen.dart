import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final String initialRole; // <--- We added this to accept the role from the welcome screen

  const RegisterScreen({super.key, required this.initialRole}); // Require it in the constructor

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers to capture user text input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late String _selectedRole; // <--- Changed this to 'late' since we set it in initState
  final List<String> _roles = ['Worker', 'Employer', 'Agent'];

  DateTime? _dateOfBirth;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialize the dropdown with whatever role the user clicked on the Welcome screen!
    _selectedRole = widget.initialRole;
  }

  // Clean up controllers when the screen is closed
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
    // Basic validation to ensure fields aren't empty
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

      if (today.month < _dateOfBirth!.month ||
          (today.month == _dateOfBirth!.month && today.day < _dateOfBirth!.day)) {
        age--;
      }

      if (age < 18) {
        setState(() => _errorMessage = 'You must be at least 18 years old to register as a worker.');
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Success! Welcome, ${_nameController.text}'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create an Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text Fields for User Info
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 25),

            const Text('I am registering as a:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Dropdown for Role Selection
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: _roles.map((String role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue!;
                  _errorMessage = '';
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            // DOB picker for Workers
            if (_selectedRole == 'Worker') ...[
              ListTile(
                title: Text(_dateOfBirth == null
                    ? 'Select Date of Birth'
                    : 'DOB: ${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'),
                trailing: const Icon(Icons.calendar_today),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                onTap: _selectDateOfBirth,
              ),
              const SizedBox(height: 15),
            ],

            // Error Display
            if (_errorMessage.isNotEmpty) ...[
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
            ],

            // Submit Button
            ElevatedButton(
              onPressed: _submitRegistration,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Register', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}