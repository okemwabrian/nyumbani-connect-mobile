import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static Future<void> saveSession(String token, String role, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('role', role);
    await prefs.setString('phone', phone);
  }

  static Future<Map<String, String?>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return null;

    return {
      'token': token,
      'role': prefs.getString('role'),
      'phone': prefs.getString('phone'),
    };
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}