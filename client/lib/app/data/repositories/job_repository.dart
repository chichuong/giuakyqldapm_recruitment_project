// lib/app/data/repositories/job_repository.dart

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../models/job_model.dart';

// Model for paginated data
class PaginatedJobs {
  final List<Job> jobs;
  final int totalPages;
  PaginatedJobs({required this.jobs, required this.totalPages});
}

class JobRepository {
  final Dio _dio = Dio();

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token ?? '';
  }

  String _handleDioError(DioException e) {
    if (e.response != null &&
        e.response?.data is Map &&
        e.response?.data['message'] != null) {
      // If the server provides a specific error message
      return e.response?.data['message'];
    } else if (e.response != null) {
      // If there's a response but no specific message (like 404)
      return 'Lỗi Server: ${e.response?.statusCode}. Vui lòng thử lại.';
    } else {
      // Network errors, connection refused, etc.
      return 'Lỗi kết nối. Vui lòng kiểm tra mạng của bạn.';
    }
  }

  // Fetch all jobs (public, paginated, searchable)
  Future<PaginatedJobs> fetchAllJobs({
    int page = 1,
    String? search,
    String? location,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'limit': 10, // Or your preferred page size
      };
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (location != null && location.isNotEmpty) {
        queryParameters['location'] = location;
      }

      final response = await _dio.get(
        ApiConstants.jobsUrl,
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jobListJson = response.data['jobs'] ?? [];
        final jobs = jobListJson.map((json) => Job.fromJson(json)).toList();
        return PaginatedJobs(
          jobs: jobs,
          totalPages: response.data['totalPages'] ?? 1,
        );
      } else {
        throw Exception('Không thể tải danh sách công việc.');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // Fetch jobs posted by the current recruiter
  Future<List<Job>> fetchMyJobs() async {
    try {
      final token = await _getToken();
      if (token.isEmpty) throw Exception('Chưa đăng nhập.'); // Need token here

      final response = await _dio.get(
        '${ApiConstants.jobsUrl}/my',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jobListJson = response.data ?? [];
        return jobListJson.map((json) => Job.fromJson(json)).toList();
      } else {
        throw Exception('Không thể tải danh sách công việc của bạn.');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // Get details for a specific job, including 'hasApplied' status if logged in
  Future<Job> getJobById(int jobId) async {
    try {
      final token =
          await _getToken(); // Get token (might be empty if not logged in)
      Options? options;
      if (token.isNotEmpty) {
        options = Options(headers: {'Authorization': 'Bearer $token'});
      }

      final response = await _dio.get(
        '${ApiConstants.jobsUrl}/$jobId',
        options: options, // Send token if available
      );
      if (response.statusCode == 200 && response.data != null) {
        return Job.fromJson(response.data);
      } else {
        throw Exception('Không thể tải chi tiết công việc.');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // Get saved jobs for the current candidate
  Future<List<Job>> getSavedJobs() async {
    try {
      final token = await _getToken();
      if (token.isEmpty) throw Exception('Chưa đăng nhập.'); // Need token here

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/saved-jobs', // Assuming this is the correct endpoint
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data ?? [];
        return data.map((json) => Job.fromJson(json)).toList();
      } else {
        throw Exception('Không thể tải danh sách việc làm đã lưu.');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // Save a job for the current candidate
  Future<void> saveJob(int jobId) async {
    try {
      final token = await _getToken();
      if (token.isEmpty) throw Exception('Chưa đăng nhập.'); // Need token here

      await _dio.post(
        '${ApiConstants.baseUrl}/api/saved-jobs/$jobId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      // Handle potential 409 conflict (already saved) gracefully if needed
      throw Exception(_handleDioError(e));
    }
  }

  // Unsave a job for the current candidate
  Future<void> unsaveJob(int jobId) async {
    try {
      final token = await _getToken();
      if (token.isEmpty) throw Exception('Chưa đăng nhập.'); // Need token here

      await _dio.delete(
        '${ApiConstants.baseUrl}/api/saved-jobs/$jobId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> updateJobStatus(int jobId, String status) async {
    try {
      final token = await _getToken();
      // Gọi API PUT /api/jobs/:id với chỉ trường status
      await _dio.put(
        '${ApiConstants.jobsUrl}/$jobId', // API update job đã có
        data: {'status': status}, // Chỉ gửi trường status
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteJob(int jobId) async {
    try {
      final token = await _getToken();
      await _dio.delete(
        '${ApiConstants.jobsUrl}/$jobId', // API delete job đã có
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
}
