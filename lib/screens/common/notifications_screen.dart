import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  final String role;

  const NotificationsScreen({super.key, required this.role});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
        return Icons.work_outline;
      case "approval":
        return Icons.verified_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  Color _color(String type) {
    switch (type) {
      case "job":
        return const Color(0xFFA8C97F);
      case "approval":
        return Colors.orange;
      default:
        return const Color(0xFF2F3E6E);
    }
  }

  void markAsRead(int index) {
    setState(() {
      notifications[index]['read'] = true;
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),

      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),

      body: notifications.isEmpty
          ? _emptyState()
          : RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            final isRead = item['read'];

            return GestureDetector(
              onTap: () => markAsRead(index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: isRead ? Colors.white : const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (!isRead)
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // 🔥 ICON
                      CircleAvatar(
                        radius: 22,
                        backgroundColor:
                        _color(item['type']).withOpacity(0.15),
                        child: Icon(
                          _icon(item['type']),
                          color: _color(item['type']),
                        ),
                      ),

                      const SizedBox(width: 14),

                      // 🔥 TEXT
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF2F3E6E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['message'],
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
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

                      // 🔥 UNREAD DOT
                      if (!isRead)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔥 EMPTY STATE (VERY IMPORTANT UX)
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.notifications_off, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No notifications yet",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}