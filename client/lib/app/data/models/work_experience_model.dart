// lib/app/data/models/work_experience_model.dart
class WorkExperience {
  final int id;
  final String jobTitle;
  final String companyName;
  final DateTime startDate;
  final DateTime? endDate;
  final String? description;

  WorkExperience({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.startDate,
    this.endDate,
    this.description,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) => WorkExperience(
    id: json["id"],
    jobTitle: json["job_title"],
    companyName: json["company_name"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    description: json["description"],
  );
}
