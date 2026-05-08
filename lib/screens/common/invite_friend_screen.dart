import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/app_theme.dart';

class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({super.key});

  void _shareApp() {
    Share.share(
      'Hey! Check out Nyumbani Connect, the best app for finding professional household managers and jobs in Kenya. Download it here: https://nyumbani-connect.co.ke/app',
      subject: 'Join Nyumbani Connect!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invite a Friend")),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group_add_rounded, size: 100, color: AppColors.primaryTeal),
            const SizedBox(height: 32),
            const Text(
              "Spread the Word!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "Help your friends find quality work or reliable help. Share your unique link via WhatsApp or SMS.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: _shareApp,
              icon: const Icon(Icons.share_rounded),
              label: const Text("SHARE DOWNLOAD LINK"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: AppColors.primaryTeal,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Maybe Later", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
