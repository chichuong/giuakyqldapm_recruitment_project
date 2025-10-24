// lib/app/data/models/education_model.dart
class Education {
  final int id;
  final String school;
  final String degree;
  final String? fieldOfStudy;
  final DateTime startDate;
  final DateTime? endDate;

  Education({
    required this.id,
    required this.school,
    required this.degree,
    this.fieldOfStudy,
    required this.startDate,
    this.endDate,
  });

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    id: json["id"],
    school: json["school"],
    degree: json["degree"],
    fieldOfStudy: json["field_of_study"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
  );
}
