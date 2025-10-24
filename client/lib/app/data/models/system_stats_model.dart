// lib/app/data/models/system_stats_model.dart
class SystemStats {
  final int totalUsers;
  final int totalCompanies;
  final int totalJobs;
  final int totalApplications;

  SystemStats({
    required this.totalUsers,
    required this.totalCompanies,
    required this.totalJobs,
    required this.totalApplications,
  });

  factory SystemStats.fromJson(Map<String, dynamic> json) => SystemStats(
    totalUsers: json["totalUsers"],
    totalCompanies: json["totalCompanies"],
    totalJobs: json["totalJobs"],
    totalApplications: json["totalApplications"],
  );
}
