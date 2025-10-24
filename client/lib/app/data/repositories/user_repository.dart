// lib/app/data/repositories/user_repository.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../models/user_model.dart';

class UserRepository {
  final Dio _dio = Dio();

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');
    return token;
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data is Map) {
      // Nếu lỗi trả về là JSON và có key 'message'
      return e.response?.data['message'] ?? 'Lỗi không xác định từ server.';
    } else if (e.response != null) {
      // Nếu lỗi trả về không phải JSON
      return 'Lỗi server: ${e.response?.statusCode}. Vui lòng thử lại.';
    } else {
      // Lỗi mạng hoặc lỗi kết nối
      return 'Lỗi kết nối. Vui lòng kiểm tra mạng của bạn.';
    }
  }

  Future<User> getMe() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Không thể tải thông tin người dùng.',
      );
    }
  }

  Future<void> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? headline,
    String? bio,
    String? linkedinUrl,
    String? githubUrl,
  }) async {
    try {
      final token = await _getToken();
      await _dio.put(
        '${ApiConstants.baseUrl}/api/users/me',
        data: {
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'headline': headline,
          'bio': bio,
          'linkedinUrl': linkedinUrl,
          'githubUrl': githubUrl,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Cập nhật thất bại.');
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final token = await _getToken();
      await _dio.put(
        '${ApiConstants.baseUrl}/api/users/change-password',
        data: {'oldPassword': oldPassword, 'newPassword': newPassword},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Đổi mật khẩu thất bại.');
    }
  }

  Future<String> uploadAvatar(File imageFile) async {
    try {
      final token = await _getToken();
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "avatar": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/upload/avatar',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['url'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Tải ảnh lên thất bại.');
    }
  }
}
