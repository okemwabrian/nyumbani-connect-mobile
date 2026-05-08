import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../../providers/theme_provider.dart';

class NotificationsScreen extends StatefulWidget {
  final String role;

  const NotificationsScreen({super.key, required this.role});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      "id": 1, "title": "New Job Application", "message": "Alice Korir applied for your Nanny position.",
      "type": "job", "time": "2 mins ago", "read": false
    },
    {
      "id": 2, "title": "Account Verified", "message": "Your profile is now verified by the Bureau.",
      "type": "approval", "time": "1 hour ago", "read": true
    },
    {
      "id": 3, "title": "System Update", "message": "Nyumbani Connect version 2.0 is now live.",
      "type": "system", "time": "5 hours ago", "read": true
    },
  ];

  void markAsRead(int id) {
    setState(() {
      final i = notifications.indexWhere((n) => n['id'] == id);
      if (i != -1) notifications[i]['read'] = true;
    });
  }

  void delete(int id) {
    setState(() => notifications.removeWhere((n) => n['id'] == id));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(themeProvider.translate('notifications')),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => notifications.clear()),
              child: const Text("CLEAR ALL", style: TextStyle(color: Colors.white, fontSize: 12)),
            )
        ],
      ),
      body: notifications.isEmpty
        ? EmptyStateWidget(icon: Icons.notifications_none_rounded, title: "No Alerts", subtitle: "Stay tuned for updates.")
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];
              return Dismissible(
                key: Key(n['id'].toString()),
                onDismissed: (_) => delete(n['id']),
                background: Container(color: Colors.redAccent, child: const Icon(Icons.delete, color: Colors.white)),
                child: Card(
                  elevation: n['read'] ? 0 : 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    onTap: () => markAsRead(n['id']),
                    leading: CircleAvatar(
                      backgroundColor: n['read'] ? Colors.grey[200] : AppColors.primaryTeal.withValues(alpha: 0.1),
                      child: Icon(_getIcon(n['type']), color: AppColors.primaryTeal),
                    ),
                    title: Text(n['title'], style: TextStyle(fontWeight: n['read'] ? FontWeight.normal : FontWeight.bold)),
                    subtitle: Text(n['message'], maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Text(n['time'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ),
                ),
              );
            },
          ),
    );
  }

  IconData _getIcon(String type) {
    if (type == 'job') return Icons.work_history_rounded;
    if (type == 'approval') return Icons.verified_user_rounded;
    return Icons.info_outline_rounded;
  }
}
