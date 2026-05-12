import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String role;
  final String phone;
  final String county;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.role,
    required this.phone,
    required this.county,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'role': role,
      'phone': phone,
      'county': county,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      phone: map['phone'] ?? '',
      county: map['county'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
