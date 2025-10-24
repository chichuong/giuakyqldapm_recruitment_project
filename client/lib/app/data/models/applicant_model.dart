// lib/app/data/models/applicant_model.dart
import 'dart:convert';

List<Applicant> applicantFromJson(String str) =>
    List<Applicant>.from(json.decode(str).map((x) => Applicant.fromJson(x)));

class Applicant {
  final int id;
  final DateTime appliedAt;
  final String? cvUrl;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String applicationStatus;
  final String? interviewStatus;
  final String? offerStatus;

  Applicant({
    required this.id,
    required this.appliedAt,
    this.cvUrl,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.applicationStatus,
    this.interviewStatus,
    this.offerStatus,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) => Applicant(
    id: json["id"],
    appliedAt: DateTime.tryParse(json["applied_at"] ?? '') ?? DateTime.now(),
    cvUrl: json["cv_url"],
    fullName: json["full_name"] ?? 'Không rõ tên',
    email: json["email"] ?? 'N/A',
    phoneNumber: json["phone_number"],
    applicationStatus: json["applicationStatus"] ?? 'pending',
    interviewStatus: json["interviewStatus"],
    offerStatus: json["offerStatus"],
  );
}
