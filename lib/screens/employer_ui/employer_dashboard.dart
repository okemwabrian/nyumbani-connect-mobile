import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_theme.dart';
import '../../utils/counties.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../common/chat_screen.dart';

class EmployerDashboard extends StatefulWidget {
  final String userName;
  final String role;

  const EmployerDashboard({
    super.key,
    required this.userName,
    required this.role,
  });

  @override
  State<EmployerDashboard> createState() => _EmployerDashboardState();
}

class _EmployerDashboardState extends State<EmployerDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCounty = "Nairobi";
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Mock Workers Data
  final List<Map<String, dynamic>> _mockWorkers = [
    {"name": "Mercy Atieno", "skills": "Childcare, First Aid", "status": "Available", "county": "Nairobi", "phone": "+254711223344", "verified": true, "image": "https://i.pravatar.cc/150?u=1"},
    {"name": "John Maina", "skills": "Chef, Cooking", "status": "Busy", "county": "Kiambu", "phone": "+254722334455", "verified": true, "image": "https://i.pravatar.cc/150?u=2"},
    {"name": "Faith Wanjiku", "skills": "Housekeeping", "status": "Available", "county": "Nairobi", "phone": "+254733445566", "verified": true, "image": "https://i.pravatar.cc/150?u=3"},
  ];

  final List<Map<String, dynamic>> _applications = [
    {"name": "Alice Korir", "job": "Nanny", "status": "Under Review", "phone": "+254712000111", "image": "https://i.pravatar.cc/150?u=4"},
    {"name": "Samuel Kipchoge", "job": "Driver", "status": "Pending", "phone": "+254721000222", "image": "https://i.pravatar.cc/150?u=5"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _makeCall(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(role: widget.role),
      appBar: AppBar(
        title: Text("Hello, ${widget.userName}"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "DISCOVER", icon: Icon(Icons.person_search_rounded)),
            Tab(text: "HIRING PANEL", icon: Icon(Icons.verified_user_rounded)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscoverView(),
          _buildHiringPanelView(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showPostJobDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("POST JOB", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryTeal,
      ),
    );
  }

  Widget _buildDiscoverView() {
    final filtered = _mockWorkers.where((w) => w['county'] == _selectedCounty).toList();

    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("Qualified Professionals in $_selectedCounty", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (filtered.isEmpty) 
                const Center(child: Padding(padding: EdgeInsets.all(40), child: Text("No workers available in this county yet.")))
              else
                ...filtered.map((w) => _workerCard(w)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: AppColors.primaryTeal,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedCounty,
            isExpanded: true,
            items: counties.map((c) => DropdownMenuItem(value: c, child: Text("County Filter: $c"))).toList(),
            onChanged: (v) => setState(() => _selectedCounty = v!),
          ),
        ),
      ),
    );
  }

  Widget _workerCard(Map<String, dynamic> w) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(radius: 30, backgroundImage: NetworkImage(w['image'])),
            title: Text(w['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(w['skills']),
            trailing: const Icon(Icons.verified_rounded, color: Colors.green, size: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(child: OutlinedButton.icon(onPressed: () => _makeCall(w['phone']), icon: const Icon(Icons.call, size: 16), label: const Text("CALL"))),
                const SizedBox(width: 8),
                Expanded(child: PrimaryButton(label: "HIRE", onPressed: () {}, color: AppColors.secondarySage)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHiringPanelView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Active Recruitment", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
          const SizedBox(height: 20),
          _buildCalendar(),
          const SizedBox(height: 32),
          const Text("Incoming Applications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._applications.map((app) => _applicationCard(app)),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.tertiaryOlive)),
      padding: const EdgeInsets.all(8),
      child: TableCalendar(
        firstDay: DateTime.utc(2023, 1, 1), lastDay: DateTime.utc(2030, 12, 31), focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        calendarStyle: const CalendarStyle(todayDecoration: BoxDecoration(color: AppColors.secondarySage, shape: BoxShape.circle), selectedDecoration: BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle)),
        onFormatChanged: (f) => setState(() => _calendarFormat = f),
      ),
    );
  }

  Widget _applicationCard(Map<String, dynamic> app) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(app['image'])),
            title: Text(app['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Job: ${app['job']}"),
            trailing: Text(app['status'], style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text("REJECT", style: TextStyle(color: Colors.red)))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: () {}, child: const Text("APPROVE"))),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.chat_outlined, color: AppColors.primaryTeal), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(recipientName: app['name'], role: "Applicant")))),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showPostJobDialog() {
    final formKey = GlobalKey<FormState>();
    final title = TextEditingController();
    final desc = TextEditingController();
    String county = "Nairobi";
    bool loading = false;

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Post a Professional Job", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  CustomTextField(controller: title, label: "Job Title", icon: Icons.work_outline, validator: (v) => v!.isEmpty ? "Required" : null),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: county, decoration: const InputDecoration(labelText: "Location County", border: OutlineInputBorder()),
                    items: counties.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setModalState(() => county = v!),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(controller: desc, label: "Full Description", icon: Icons.notes, validator: (v) => v!.isEmpty ? "Required" : null),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: "SUBMIT & NOTIFY AGENTS", isLoading: loading,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        setModalState(() => loading = true);
                        await Future.delayed(const Duration(seconds: 2));
                        if (mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Job posted in $county!"), backgroundColor: AppColors.primaryTeal));
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
