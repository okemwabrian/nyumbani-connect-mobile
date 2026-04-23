import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  final String role;

  const NotificationsScreen({super.key, required this.role});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // 🔥 TEMP DATA (UI MODE)
  List notifications = [
    {
      "title": "New Worker Registered",
      "message": "Jane Doe is awaiting approval",
      "type": "approval",
      "time": "2 min ago",
      "read": false
    },
    {
      "title": "Job Assigned",
      "message": "You have been assigned a job in Nairobi",
      "type": "job",
      "time": "10 min ago",
      "read": false
    },
    {
      "title": "Profile Updated",
      "message": "Your profile was successfully updated",
      "type": "system",
      "time": "1 hr ago",
      "read": true
    },
  ];

  IconData _icon(String type) {
    switch (type) {
      case "job":
        return Icons.work;
      case "approval":
        return Icons.verified;
      default:
        return Icons.notifications;
    }
  }

  Color _color(String type) {
    switch (type) {
      case "job":
        return Colors.green;
      case "approval":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void markAsRead(int index) {
    setState(() {
      notifications[index]['read'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),

      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];

          return GestureDetector(
            onTap: () => markAsRead(index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: item['read']
                    ? Colors.white
                    : const Color(0xFFEAF3FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _color(item['type']).withOpacity(0.15),
                    child: Icon(
                      _icon(item['type']),
                      color: _color(item['type']),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F3E6E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['message'],
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['time'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (!item['read'])
                    const Icon(Icons.circle, size: 10, color: Colors.blue),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}