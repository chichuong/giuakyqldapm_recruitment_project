// lib/app/data/repositories/application_repository.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../models/applicant_model.dart';
import '../models/my_application_model.dart';
import '../models/application_detail_model.dart';

class JobApplicantsResponse {
  final String jobStatus;
  final List<Applicant> applicants;

  JobApplicantsResponse({required this.jobStatus, required this.applicants});
}

class ApplicationRepository {
  final Dio _dio = Dio();

  // Lấy token từ SharedPreferences
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');
    return token;
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data is Map) {
      return e.response?.data['message'] ?? 'Lỗi không xác định từ server.';
    } else if (e.response != null) {
      return 'Lỗi server: ${e.response?.statusCode}.';
    } else {
      return 'Lỗi kết nối mạng.';
    }
  }

  // Tải file CV lên
  Future<String> uploadCv(File cvFile) async {
    final token = await _getToken();
    String fileName = cvFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      "cv": await MultipartFile.fromFile(cvFile.path, filename: fileName),
    });

    final response = await _dio.post(
      '${ApiConstants.baseUrl}/api/upload/cv',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['url'];
  }

  // Nộp hồ sơ
  Future<void> applyToJob(int jobId, String cvUrl) async {
    final token = await _getToken();
    await _dio.post(
      '${ApiConstants.baseUrl}/api/applications/$jobId/apply',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: {'cv_url': cvUrl},
    );
  }

  // Lấy danh sách ứng viên
  Future<JobApplicantsResponse> getJobApplicants(int jobId) async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/applications/$jobId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      // Parse dữ liệu theo cấu trúc mới
      final String status = response.data['jobStatus'] ?? 'unknown';
      final List<dynamic> applicantListJson = response.data['applicants'] ?? [];
      final applicants = applicantListJson
          .map((json) => Applicant.fromJson(json))
          .toList();
      return JobApplicantsResponse(jobStatus: status, applicants: applicants);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // Cập nhật trạng thái
  Future<void> updateApplicationStatus(
    int applicationId,
    String status, {
    String? rejectionReason,
  }) async {
    try {
      final token = await _getToken();
      await _dio.put(
        '${ApiConstants.baseUrl}/api/applications/$applicationId/status',
        data: {'status': status, 'rejectionReason': rejectionReason},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // Lên lịch phỏng vấn
  Future<void> scheduleInterview(
    int applicationId,
    String interviewDate,
    String location,
    String notes,
  ) async {
    final token = await _getToken();
    await _dio.post(
      '${ApiConstants.baseUrl}/api/interviews/schedule',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: {
        'applicationId': applicationId,
        'interviewDate': interviewDate,
        'location': location,
        'notes': notes,
      },
    );
  }

  Future<List<MyApplication>> getMyApplications() async {
    final token = await _getToken();
    final response = await _dio.get(
      '${ApiConstants.baseUrl}/api/applications/my',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final List<dynamic> data = response.data;
    // Dùng fromJson của model mới
    return data.map((json) => MyApplication.fromJson(json)).toList();
  }

  Future<ApplicationDetail> getApplicationDetails(int applicationId) async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/applications/$applicationId/details',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return ApplicationDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> updateInterviewStatus(int interviewId, String status) async {
    try {
      final token = await _getToken();
      await _dio.put(
        '${ApiConstants.baseUrl}/api/interviews/$interviewId/status',
        data: {'status': status},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> respondToOffer(int offerId, String status) async {
    try {
      final token = await _getToken();
      await _dio.put(
        '${ApiConstants.baseUrl}/api/offers/$offerId/respond',
        data: {'status': status},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> recordInterviewResult(
    int applicationId,
    String result,
    String comments,
  ) async {
    try {
      final token = await _getToken();
      await _dio.post(
        '${ApiConstants.baseUrl}/api/applications/$applicationId/result',
        data: {'result': result, 'comments': comments},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
}
