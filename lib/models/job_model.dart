import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String jobId;
  final String employerId;
  final String employerName;
  final String title;
  final String description;
  final String county;
  final String budget;
  final DateTime postedAt;

  JobModel({
    required this.jobId,
    required this.employerId,
    required this.employerName,
    required this.title,
    required this.description,
    required this.county,
    required this.budget,
    required this.postedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'employerId': employerId,
      'employerName': employerName,
      'title': title,
      'description': description,
      'county': county,
      'budget': budget,
      'postedAt': Timestamp.fromDate(postedAt),
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map, String id) {
    return JobModel(
      jobId: id,
      employerId: map['employerId'] ?? '',
      employerName: map['employerName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      county: map['county'] ?? '',
      budget: map['budget'] ?? '',
      postedAt: (map['postedAt'] as Timestamp).toDate(),
    );
  }
}
