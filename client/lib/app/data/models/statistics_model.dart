// lib/app/data/models/statistics_model.dart

import 'dart:convert';

Statistics statisticsFromJson(String str) =>
    Statistics.fromJson(json.decode(str));

class Statistics {
  final int totalJobs;
  final int totalApplications;
  final StatusCounts statusCounts;

  Statistics({
    required this.totalJobs,
    required this.totalApplications,
    required this.statusCounts,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    totalJobs: json["totalJobs"],
    totalApplications: json["totalApplications"],
    statusCounts: StatusCounts.fromJson(json["statusCounts"]),
  );
}

class StatusCounts {
  final int pending;
  final int screening;
  final int interviewing;
  final int offered;
  final int rejected;

  StatusCounts({
    required this.pending,
    required this.screening,
    required this.interviewing,
    required this.offered,
    required this.rejected,
  });

  factory StatusCounts.fromJson(Map<String, dynamic> json) => StatusCounts(
    pending: json["pending"],
    screening: json["screening"],
    interviewing: json["interviewing"],
    offered: json["offered"],
    rejected: json["rejected"],
  );
}
