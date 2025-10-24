// lib/app/data/models/admin_application_list_model.dart

class AdminApplicationListItem {
  final int id;
  final String status;
  final String candidateName;
  final String jobTitle;

  AdminApplicationListItem({
    required this.id,
    required this.status,
    required this.candidateName,
    required this.jobTitle,
  });

  factory AdminApplicationListItem.fromJson(Map<String, dynamic> json) =>
      AdminApplicationListItem(
        id: json["id"],
        status: json["status"],
        candidateName: json["candidate_name"],
        jobTitle: json["job_title"],
      );
}
