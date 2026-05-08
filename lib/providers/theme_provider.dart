import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  Locale _locale = const Locale('en');

  bool get isDarkMode => _isDarkMode;
  Locale get locale => _locale;

  // Expanded Translation Map
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'account_details': 'Account Details',
      'app_appearance': 'App Appearance',
      'language': 'Language Toggle',
      'dark_mode': 'Dark Mode',
      'logout': 'Logout from Nyumbani',
      'save_changes': 'SAVE CHANGES',
      'notifications': 'Notifications',
      'profile': 'My Profile',
      'dashboard': 'Dashboard',
      'invite': 'Invite a Friend',
      'history': 'History',
      'hiring_history': 'Hiring History',
      'job_history': 'Job History',
      'login': 'Login',
      'login_title': 'Login to Nyumbani',
      'register': 'Register',
      'username': 'Username',
      'email': 'Email',
      'phone': 'Phone Number',
      'password': 'Password',
      'skills': 'Skills',
      'location': 'Location',
      'post_job': 'Post a Job',
      'call': 'Call',
      'chat': 'Chat',
      'approve': 'Approve',
      'reject': 'Reject',
      'no_notifications': 'No Notifications',
      'county': 'County',
      'search': 'Search',
      'workers': 'Workers',
      'jobs': 'Jobs',
      'home': 'Home',
      'user': 'User',
      'employer': 'Employer',
      'worker': 'House Manager',
      'agent': 'Bureau / Agent',
      'account': 'Account',
      'details': 'Details',
      'identifier_label': 'Username, Email or Phone',
      'required_error': 'Field is required',
      'password_error': 'Min 6 characters',
      'no_account_action': 'Don\'t have an account? Register',
      'next_step': 'NEXT STEP',
      'complete_setup': 'COMPLETE SETUP',
      'id_required': 'National ID (Front) - Compulsory',
    },
    'sw': {
      'settings': 'Mipangilio',
      'account_details': 'Maelezo ya Akaunti',
      'app_appearance': 'Muonekano wa Programu',
      'language': 'Badilisha Lugha',
      'dark_mode': 'Modi ya Usiku',
      'logout': 'Ondoka Nyumbani',
      'save_changes': 'HIFADHI MABADILIKO',
      'notifications': 'Arifa',
      'profile': 'Wasifu Wangu',
      'dashboard': 'Dashibodi',
      'invite': 'Alika Rafiki',
      'history': 'Historia',
      'hiring_history': 'Historia ya Kuajiri',
      'job_history': 'Historia ya Kazi',
      'login': 'Ingia',
      'login_title': 'Ingia Nyumbani',
      'register': 'Jisajili',
      'username': 'Jina la Mtumiaji',
      'email': 'Barua Pepe',
      'phone': 'Nambari ya Simu',
      'password': 'Nenosiri',
      'skills': 'Ujuzi',
      'location': 'Mahali',
      'post_job': 'Tuma Kazi',
      'call': 'Piga Simu',
      'chat': 'Zungumza',
      'approve': 'Kubali',
      'reject': 'Kataa',
      'no_notifications': 'Hakuna Arifa',
      'county': 'Kaunti',
      'search': 'Tafuta',
      'workers': 'Wafanyakazi',
      'jobs': 'Kazi',
      'home': 'Nyumbani',
      'user': 'Mtumiaji',
      'employer': 'Mwajiri',
      'worker': 'Meneja wa Nyumba',
      'agent': 'Wakala / Ofisi',
      'account': 'Akaunti',
      'details': 'Maelezo',
      'identifier_label': 'Username, Email au Simu',
      'required_error': 'Lazima ujaze hapa',
      'password_error': 'Angalau herufi 6',
      'no_account_action': 'Huna akaunti? Jisajili',
      'next_step': 'HATUA IFUATAYO',
      'complete_setup': 'KAMILISHA USAJILI',
      'id_required': 'Kitambulisho (Mbele) - Lazima',
    },
  };

  String translate(String key) {
    return _localizedValues[_locale.languageCode]?[key] ?? key;
  }

  ThemeProvider() {
    _loadFromPrefs();
  }

  void toggleTheme(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  void setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    String languageCode = prefs.getString('languageCode') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
