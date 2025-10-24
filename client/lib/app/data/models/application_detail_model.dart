// lib/app/data/models/application_detail_model.dart
class ApplicationDetail {
  final String status;
  final String? rejectionReason;
  final String jobTitle;
  final String recruiterName;
  final int? interviewId;
  final String? interviewStatus;
  final DateTime? interviewDate;
  final String? interviewLocation;
  final String? interviewNotes;
  final DateTime? confirmationDeadline;
  final int? offerId;
  final String? offerLetterContent;
  final String? offerStatus;

  ApplicationDetail({
    required this.status,
    this.rejectionReason,
    required this.jobTitle,
    required this.recruiterName,
    this.interviewId,
    this.interviewStatus,
    this.interviewDate,
    this.interviewLocation,
    this.interviewNotes,
    this.confirmationDeadline,
    this.offerId,
    this.offerLetterContent,
    this.offerStatus,
  });

  factory ApplicationDetail.fromJson(Map<String, dynamic> json) =>
      ApplicationDetail(
        status: json["status"],
        rejectionReason: json["rejection_reason"],
        jobTitle: json["job_title"],
        recruiterName: json["recruiter_name"],
        // Sửa lại key JSON cho đúng với backend
        interviewId: json["interview_id"],
        interviewStatus: json["interview_status"],
        interviewDate: json["interview_date"] == null
            ? null
            : DateTime.parse(json["interview_date"]),
        interviewLocation: json["interview_location"],
        interviewNotes: json["interview_notes"],
        confirmationDeadline: json["confirmation_deadline"] == null
            ? null
            : DateTime.parse(json["confirmation_deadline"]),
        offerId: json["offer_id"],
        offerLetterContent: json["offer_letter_content"],
        offerStatus: json["offer_status"],
      );
}
