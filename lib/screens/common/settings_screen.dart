import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../providers/app_state.dart';
import '../../providers/theme_provider.dart';
import '../../services/session_service.dart';
import '../welcome_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String? role;

  const SettingsScreen({super.key, this.role});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _phoneController = TextEditingController(text: appState.phone ?? "0712 345 678");
    _emailController = TextEditingController(text: "user@nyumbani.co.ke");
    _addressController = TextEditingController(text: "Nairobi, Kenya");
    _ageController = TextEditingController(text: appState.calculatedAge?.toString() ?? "28");
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _saveDetails() {
    if (!mounted) return;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(themeProvider.translate('save_changes')),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appState = Provider.of<AppState>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(themeProvider.translate('settings')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION: ACCOUNT DETAILS ---
            _buildSectionHeader(themeProvider.translate('account_details'), Icons.person_rounded),
            const SizedBox(height: 16),
            _buildTextField("Phone Number", _phoneController, Icons.phone_android_rounded),
            _buildTextField("Email Address", _emailController, Icons.email_outlined),
            _buildTextField("Physical Address", _addressController, Icons.location_on_outlined),
            _buildTextField("Age", _ageController, Icons.calendar_month_outlined, isNumber: true),
            
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveDetails,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.secondarySage,
              ),
              child: Text(themeProvider.translate('save_changes')),
            ),

            const SizedBox(height: 40),

            // --- SECTION: APP APPEARANCE ---
            _buildSectionHeader(themeProvider.translate('app_appearance'), Icons.palette_rounded),
            const SizedBox(height: 8),
            SwitchListTile(
              title: Text(themeProvider.translate('dark_mode'), 
                style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(isDark ? "On" : "Off"),
              value: isDark,
              activeColor: AppColors.primaryTeal,
              onChanged: (val) => themeProvider.toggleTheme(val),
            ),

            const SizedBox(height: 24),

            // --- SECTION: LANGUAGE ---
            _buildSectionHeader(themeProvider.translate('language'), Icons.language_rounded),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildLanguageButton(
                    label: "English",
                    isSelected: themeProvider.locale.languageCode == 'en',
                    onTap: () => themeProvider.setLocale('en'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildLanguageButton(
                    label: "Kiswahili",
                    isSelected: themeProvider.locale.languageCode == 'sw',
                    onTap: () => themeProvider.setLocale('sw'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),

            // --- LOGOUT BUTTON ---
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  await SessionService.logout();
                  appState.logout();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                label: Text(
                  themeProvider.translate('logout'),
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryTeal, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            letterSpacing: 0.5,
            color: Theme.of(context).textTheme.titleLarge?.color, // FIX: Dynamic color
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color), // FIX: Dynamic color
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.secondarySage, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildLanguageButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryTeal : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryTeal, width: 2),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.primaryTeal,
            ),
          ),
        ),
      ),
    );
  }
}
