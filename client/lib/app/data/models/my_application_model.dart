// lib/app/data/models/my_application_model.dart

import 'dart:convert';

List<MyApplication> myApplicationFromJson(String str) =>
    List<MyApplication>.from(
      json.decode(str).map((x) => MyApplication.fromJson(x)),
    );

class MyApplication {
  final int applicationId;
  final String status;
  final DateTime appliedAt;
  final String jobTitle;
  final String? location;
  final String recruiterName;

  MyApplication({
    required this.applicationId,
    required this.status,
    required this.appliedAt,
    required this.jobTitle,
    this.location,
    required this.recruiterName,
  });

  factory MyApplication.fromJson(Map<String, dynamic> json) => MyApplication(
    applicationId: json["applicationId"],
    status: json["status"],
    appliedAt: DateTime.parse(json["applied_at"]),
    jobTitle: json["job_title"],
    location: json["location"],
    recruiterName: json["recruiter_name"],
  );
}
