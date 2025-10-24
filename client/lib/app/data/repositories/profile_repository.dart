// lib/app/data/repositories/profile_repository.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../models/education_model.dart';
import '../models/work_experience_model.dart';

class ProfileRepository {
  final Dio _dio = Dio();

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

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final experiences = (response.data['experiences'] as List)
          .map((e) => WorkExperience.fromJson(e))
          .toList();
      final educations = (response.data['educations'] as List)
          .map((e) => Education.fromJson(e))
          .toList();
      return {'experiences': experiences, 'educations': educations};
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // === CRUD cho Kinh nghiệm làm việc ===
  Future<void> addExperience(Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      await _dio.post(
        '${ApiConstants.baseUrl}/api/profile/experience',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> updateExperience(int id, Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      await _dio.put(
        '${ApiConstants.baseUrl}/api/profile/experience/$id',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteExperience(int id) async {
    try {
      final token = await _getToken();
      await _dio.delete(
        '${ApiConstants.baseUrl}/api/profile/experience/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // CRUD HỌC VẤN
  Future<void> addEducation(Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      await _dio.post(
        '${ApiConstants.baseUrl}/api/profile/education',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> updateEducation(int id, Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      await _dio.put(
        '${ApiConstants.baseUrl}/api/profile/education/$id',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteEducation(int id) async {
    try {
      final token = await _getToken();
      await _dio.delete(
        '${ApiConstants.baseUrl}/api/profile/education/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
}
