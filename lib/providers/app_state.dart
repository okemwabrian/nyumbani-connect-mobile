import 'package:flutter/material.dart';

enum UserRole { worker, agent, employer, admin }

class AppState extends ChangeNotifier {
  // Authentication & Profile
  bool _isLoggedIn = false;
  UserRole? _role;
  String? _name;
  String? _phone;
  String? _verificationStatus = "Verification Pending"; 
  bool _isVerified = false;

  // Automation: ID Parsing Data
  String? _extractedDob;
  int? _calculatedAge;

  // Registration Data
  int registrationStep = 0;
  String? tempAbout;
  List<String> tempSkills = [];
  int? tempExperience;

  // Stats
  int totalApplied = 0;
  int shortlisted = 0;
  int pendingReview = 0;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  UserRole? get role => _role;
  String? get name => _name;
  String? get phone => _phone;
  String? get verificationStatus => _verificationStatus;
  bool get isVerified => _isVerified;
  int? get calculatedAge => _calculatedAge;

  final List<String> availableSkills = [
    "Cooking", "Childcare", "Elderly care", "Laundry", "Ironing",
    "Cleaning", "Gardening", "Driving", "Pet care", "Shopping"
  ];

  final Map<String, List<String>> skillClusters = {
    "Childcare Specialists": ["Childcare", "Cooking", "First Aid"],
    "Senior Care": ["Elderly care", "First Aid", "Cleaning"],
    "Elite Housekeeping": ["Cleaning", "Laundry", "Ironing"],
  };

  void setRole(UserRole role) {
    _role = role;
    notifyListeners();
  }

  /// Sets the session from login data
  void setSession(String roleStr, String phone) {
    _isLoggedIn = true;
    _phone = phone;
    
    switch (roleStr) {
      case 'worker': _role = UserRole.worker; break;
      case 'agent': _role = UserRole.agent; break;
      case 'employer': _role = UserRole.employer; break;
      case 'admin': _role = UserRole.admin; break;
      default: _role = UserRole.employer;
    }
    
    // Default verification logic for mock: workers need review
    _isVerified = (_role != UserRole.worker);
    _verificationStatus = _isVerified ? "Verified" : "Verification Pending";
    
    notifyListeners();
  }

  void completeRegistration({
    required String name,
    required String phone,
    required String about,
    required List<String> skills,
    required int experience,
  }) {
    _name = name;
    _phone = phone;
    tempAbout = about;
    tempSkills = skills;
    tempExperience = experience;
    _isLoggedIn = true;
    _isVerified = false;
    _verificationStatus = "Verification Pending";
    notifyListeners();
  }

  void processNationalID(String mockIDData) {
    if (mockIDData.contains("-")) {
      final parts = mockIDData.split("-");
      if (parts.length > 1) {
        _extractedDob = parts[1]; // Expected format YYYYMMDD
        try {
          final year = int.parse(_extractedDob!.substring(0, 4));
          _calculatedAge = DateTime.now().year - year;
        } catch (e) {
          debugPrint("Error parsing age: $e");
        }
        notifyListeners();
      }
    }
  }

  void autoSelectCluster(String clusterName) {
    if (skillClusters.containsKey(clusterName)) {
      tempSkills = List.from(skillClusters[clusterName]!);
      notifyListeners();
    }
  }

  void toggleSkill(String skill) {
    if (tempSkills.contains(skill)) {
      tempSkills.remove(skill);
    } else {
      tempSkills.add(skill);
    }
    notifyListeners();
  }

  void applyToJob() {
    totalApplied++;
    pendingReview++;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _role = null;
    _name = null;
    _phone = null;
    registrationStep = 0;
    tempSkills = [];
    _calculatedAge = null;
    notifyListeners();
  }
}
