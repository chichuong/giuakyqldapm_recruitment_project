// lib/app/data/models/job_model.dart
import 'dart:convert';

// Hàm để parse một list JSON thành List<Job>
List<Job> jobFromJson(String str) =>
    List<Job>.from(json.decode(str).map((x) => Job.fromJson(x)));

class Job {
  final int id;
  final String title;
  final String description;
  final String? requirements;
  final String? salary;
  final String? location;
  final String recruiterName;
  final String? companyName;
  final String? companyLogoUrl;
  final bool hasApplied;

  Job({
    required this.id,
    required this.title,
    required this.description,
    this.requirements,
    this.salary,
    this.location,
    required this.recruiterName,
    this.companyName,
    this.companyLogoUrl,
    this.hasApplied = false,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    requirements: json["requirements"],
    salary: json["salary"],
    location: json["location"],
    recruiterName: json["recruiterName"] ?? 'Không rõ',
    companyName: json["company_name"],
    companyLogoUrl: json["company_logo_url"],
    hasApplied: json["hasApplied"] ?? false,
  );
}
