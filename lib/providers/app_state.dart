import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String? _role;
  String? _phone;
  bool _isVerified = false;
  String _verificationStatus = "Pending";

  // Automation: ID Parsing Data
  String? _extractedDob;
  int? _calculatedAge;

  // Automation: Skill Clusters
  final Map<String, List<String>> _skillClusters = {
    "Childcare Specialists": ["Pediatric First Aid", "Early Childhood Development", "Nutritional Cooking"],
    "Senior Care": ["Elderly Assistance", "Medication Management", "Mobility Support"],
    "Elite Housekeeping": ["Deep Cleaning", "Laundry & Ironing", "Silverware Maintenance"],
  };

  String? get role => _role;
  String? get phone => _phone;
  bool get isVerified => _isVerified;
  String get verificationStatus => _verificationStatus;
  String? get extractedDob => _extractedDob;
  int? get calculatedAge => _calculatedAge;
  Map<String, List<String>> get skillClusters => _skillClusters;

  List<String> selectedSkills = [];

  void setSession(String? role, String? phone) {
    _role = role;
    _phone = phone;
    _isVerified = (role != 'worker');
    _verificationStatus = _isVerified ? "Verified" : "Pending";
    notifyListeners();
  }

  // Smart Automation: Mock ID Parser
  void processNationalID(String mockIDData) {
    // Logic: Extracts DOB from a mock string (e.g. "ID-19950520-XXX")
    if (mockIDData.contains("-")) {
      final parts = mockIDData.split("-");
      if (parts.length > 1) {
        _extractedDob = parts[1]; // YYYYMMDD
        final year = int.parse(_extractedDob!.substring(0, 4));
        _calculatedAge = DateTime.now().year - year;
        notifyListeners();
      }
    }
  }

  // Automation: Smart Skill Selector
  void autoSelectCluster(String clusterName) {
    if (_skillClusters.containsKey(clusterName)) {
      selectedSkills = List.from(_skillClusters[clusterName]!);
      notifyListeners();
    }
  }

  void toggleSkill(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
    } else {
      selectedSkills.add(skill);
    }
    notifyListeners();
  }

  void logout() {
    _role = null;
    _phone = null;
    selectedSkills = [];
    _extractedDob = null;
    _calculatedAge = null;
    notifyListeners();
  }
}
