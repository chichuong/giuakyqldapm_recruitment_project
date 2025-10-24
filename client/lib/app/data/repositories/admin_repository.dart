// lib/app/data/repositories/admin_repository.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../models/system_stats_model.dart';
import '../models/admin_user_list_model.dart';
import '../models/company_model.dart';
import '../models/job_model.dart';
import '../models/admin_application_list_model.dart';

class AdminRepository {
  final Dio _dio = Dio();

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');
    return token;
  }

  Future<SystemStats> getSystemStats() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/admin/stats',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return SystemStats.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Không thể tải thống kê.');
    }
  }

  Future<PaginatedAdminUsers> getAllUsers({int page = 1}) async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/admin/users',
        queryParameters: {'page': page, 'limit': 15},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> userListJson = response.data['users'];
      final users = userListJson
          .map((json) => AdminUserListItem.fromJson(json))
          .toList();
      return PaginatedAdminUsers(
        users: users,
        totalPages: response.data['totalPages'],
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Không thể tải danh sách người dùng.',
      );
    }
  }

  Future<List<Company>> getAllCompanies() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/admin/companies',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> companyListJson = response.data['companies'];
      final companies = companyListJson
          .map((json) => Company.fromJson(json))
          .toList();
      return companies;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Không thể tải danh sách công ty.',
      );
    }
  }

  Future<List<Job>> getAllJobs() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/admin/jobs',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> jobListJson = response.data['jobs'];
      final jobs = jobListJson.map((json) => Job.fromJson(json)).toList();
      return jobs;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Không thể tải danh sách việc làm.',
      );
    }
  }

  Future<List<AdminApplicationListItem>> getAllApplications() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/admin/applications',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> listJson = response.data['applications'];
      final applications = listJson
          .map((json) => AdminApplicationListItem.fromJson(json))
          .toList();
      return applications;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Không thể tải danh sách hồ sơ.',
      );
    }
  }
}
