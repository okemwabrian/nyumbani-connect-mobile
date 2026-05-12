import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  final String applicationId;
  final String jobId;
  final String workerId;
  final String employerId;
  final String status; // "Pending", "Shortlisted", "Rejected"
  final DateTime appliedAt;
  final String jobTitle; // Denormalized for easier display

  ApplicationModel({
    required this.applicationId,
    required this.jobId,
    required this.workerId,
    required this.employerId,
    required this.status,
    required this.appliedAt,
    required this.jobTitle,
  });

  Map<String, dynamic> toMap() {
    return {
      'applicationId': applicationId,
      'jobId': jobId,
      'workerId': workerId,
      'employerId': employerId,
      'status': status,
      'appliedAt': Timestamp.fromDate(appliedAt),
      'jobTitle': jobTitle,
    };
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map, String id) {
    return ApplicationModel(
      applicationId: id,
      jobId: map['jobId'] ?? '',
      workerId: map['workerId'] ?? '',
      employerId: map['employerId'] ?? '',
      status: map['status'] ?? 'Pending',
      appliedAt: (map['appliedAt'] as Timestamp).toDate(),
      jobTitle: map['jobTitle'] ?? '',
    );
  }
}
