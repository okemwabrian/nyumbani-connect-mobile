import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:8000/api";

  // 🔐 Get headers with token
  static Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // 🔹 LOGIN
  static Future<Map<String, dynamic>?> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "phone": phone,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  // 🔹 GET AVAILABLE WORKERS
  static Future<List> getAvailableWorkers() async {
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse("$baseUrl/workers/available/"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  // 🔹 CREATE JOB
  static Future<bool> createJob(String description, String county) async {
    final headers = await getHeaders();

    final response = await http.post(
      Uri.parse("$baseUrl/jobs/create/"),
      headers: headers,
      body: jsonEncode({
        "description": description,
        "county": county,
      }),
    );

    return response.statusCode == 200;
  }

  // 🔹 AGENT: GET WORKERS
  static Future<List> getAllWorkers() async {
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse("$baseUrl/workers/"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  // 🔹 AGENT: APPROVE WORKER
  static Future<void> approveWorker(int id) async {
    final headers = await getHeaders();

    await http.post(
      Uri.parse("$baseUrl/workers/$id/approve/"),
      headers: headers,
    );
  }
  static Future<Map<String, dynamic>?> getWorkerProfile() async {
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse("$baseUrl/worker/profile/"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }
  // 🔹 ASSIGN WORKER TO JOB
  static Future<void> assignWorker(int jobId, int workerId) async {
    final headers = await getHeaders();

    await http.post(
      Uri.parse("$baseUrl/jobs/$jobId/assign/"),
      headers: headers,
      body: jsonEncode({
        "worker_id": workerId,
      }),
    );
  }
}