import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 LOGIN with Firebase
  static Future<Map<String, dynamic>?> login(String identifier, String password) async {
    try {
      // Using phone number as a virtual email for Firebase Auth
      final String email = identifier.contains('@') ? identifier : "$identifier@nyumbani.com";
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      if (result.user != null) {
        // Fetch user role and details from Firestore
        DocumentSnapshot userDoc = await _db.collection('Users').doc(result.user!.uid).get();
        
        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          return {
            "access": await result.user!.getIdToken(),
            "role": data['role'],
            "phone": data['phone'] ?? identifier,
            "name": data['name'],
          };
        }
      }
    } catch (e) {
      print("Firebase Login Error: $e");
    }
    return null;
  }

  // 🔹 REGISTER with Firebase
  static Future<bool> register({
    required String name,
    required String phone,
    required String password,
    required String role,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      final String email = "$phone@nyumbani.com";
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      if (result.user != null) {
        // Create Firestore User Document
        await _db.collection('Users').doc(result.user!.uid).set({
          'uid': result.user!.uid,
          'name': name,
          'phone': phone,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          ...?extraData,
        });
        return true;
      }
    } catch (e) {
      print("Firebase Registration Error: $e");
    }
    return false;
  }

  // 🔹 LOGOUT
  static Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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