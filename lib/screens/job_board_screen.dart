import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/nyumbani_layout.dart';

class JobBoardScreen extends StatelessWidget {
  const JobBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NyumbaniLayout(
      title: "Job Board",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Job Board", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text("Verified job openings across Nairobi", style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 32),

            // Search and Filters
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search jobs or location...",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black12)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _FilterChip(label: "All", isActive: true),
                const SizedBox(width: 8),
                _FilterChip(label: "Live-In"),
                const SizedBox(width: 8),
                _FilterChip(label: "Live-Out"),
                const SizedBox(width: 8),
                _FilterChip(label: "Part-Time"),
              ],
            ),
            const SizedBox(height: 32),

            // Job Cards
            _JobCard(
              title: "Live-In Housekeeper & Cook",
              postedBy: "Mary Njoroge • Nairobi Home Staffing",
              time: "22 days ago",
              location: "Karen",
              salary: "KES 18,000 - 25,000 /per month",
              desc: "Full housekeeping, daily cooking (local & continental), grocery shopping, and managing household supplies. Must be comfortable with 2 dogs.",
              tag: "Live-In",
              tagColor: Colors.blue,
            ),
            _JobCard(
              title: "Nanny / Childcare Specialist",
              postedBy: "James Mwangi • TrustCare Recruitment",
              time: "22 days ago",
              location: "Kilimani",
              salary: "KES 20,000 - 30,000 /per month",
              desc: "Full-time care for 2 toddlers (ages 2 & 4). Duties include feeding, playtime, school pick-up, light cooking for children, and maintaining nursery cleanliness.",
              tag: "Live-Out",
              tagColor: Colors.green,
            ),
            _JobCard(
              title: "Part-Time House Cleaner",
              postedBy: "Grace Achieng • CleanHome Agency",
              time: "22 days ago",
              location: "Westlands",
              salary: "KES 12,000 - 15,000 /per month",
              desc: "Cleaning and organizing a 3-bedroom apartment 5 days a week (mornings only). Tasks include mopping, dusting, laundry, and ironing.",
              tag: "Part-Time",
              tagColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  const _FilterChip({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1D4ED8) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isActive ? Colors.transparent : Colors.black12),
      ),
      child: Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
    );
  }
}

class _JobCard extends StatelessWidget {
  final String title;
  final String postedBy;
  final String time;
  final String location;
  final String salary;
  final String desc;
  final String tag;
  final Color tagColor;

  const _JobCard({
    required this.title, required this.postedBy, required this.time,
    required this.location, required this.salary, required this.desc,
    required this.tag, required this.tagColor
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                child: Text(tag, style: TextStyle(color: tagColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text("Posted by $postedBy • $time", style: const TextStyle(color: Colors.black38, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.black54),
              const SizedBox(width: 4),
              Text(location, style: const TextStyle(color: Colors.black54)),
              const SizedBox(width: 24),
              const Icon(Icons.payments_outlined, size: 16, color: Colors.black54),
              const SizedBox(width: 4),
              Text(salary, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 16),
          Text(desc, style: const TextStyle(color: Colors.black54, height: 1.5)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showApplyDialog(context, appState),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D4ED8),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Apply Now"),
          ),
        ],
      ),
    );
  }

  void _showApplyDialog(BuildContext context, AppState state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Apply Now: $title"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📍 $location   💰 $salary", style: const TextStyle(fontSize: 12, color: Colors.black45)),
            const SizedBox(height: 24),
            const Text("Optional message to the agent", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Write a short message...",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              state.applyToJob();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Application submitted!")));
            }, 
            child: const Text("Submit")
          ),
        ],
      ),
    );
  }
}
