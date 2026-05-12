import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Register with Email and Password
  Future<String?> registerWithEmailAndPassword({
    required String name,
    required String phone,
    required String password,
    required String role,
    String? county,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      // Create user with phone-based email
      final String email = "$phone@nyumbani.com";
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      if (result.user != null) {
        // Save user profile to Firestore using UserModel
        final userModel = UserModel(
          uid: result.user!.uid,
          name: name,
          role: role,
          phone: phone,
          county: county ?? 'Nairobi',
          createdAt: DateTime.now(),
        );

        await _db.collection('Users').doc(result.user!.uid).set({
          ...userModel.toMap(),
          ...?extraData,
        });
        return null; // Success
      }
      return "Registration failed. Please try again.";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') return 'The password provided is too weak.';
      if (e.code == 'email-already-in-use') return 'The account already exists for this phone number.';
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // 🔹 Sign In with Email and Password
  Future<Map<String, dynamic>?> signInWithEmailAndPassword(String identifier, String password) async {
    try {
      final String email = identifier.contains('@') ? identifier : "$identifier@nyumbani.com";
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      if (result.user != null) {
        DocumentSnapshot userDoc = await _db.collection('Users').doc(result.user!.uid).get();
        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          return {
            'uid': result.user!.uid,
            'role': data['role'],
            'name': data['name'],
            'phone': data['phone'],
          };
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') throw 'No user found for that phone number.';
      if (e.code == 'wrong-password') throw 'Wrong password provided.';
      throw e.message ?? 'An unknown error occurred.';
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  // 🔹 Reset Password
  Future<String?> resetPassword(String identifier) async {
    try {
      final String email = identifier.contains('@') ? identifier : "$identifier@nyumbani.com";
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // 🔹 Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 🔹 Current User
  User? get currentUser => _auth.currentUser;
}
