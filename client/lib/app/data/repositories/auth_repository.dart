// lib/app/data/repositories/auth_repository.dart

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class AuthRepository {
  final Dio _dio = Dio();

  // Hàm đăng nhập
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginUrl,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Lưu token và role vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('role', data['user']['role']);
        return data['user']; // Trả về thông tin người dùng
      } else {
        // Dio sẽ tự ném lỗi cho các status code thất bại, nhưng để dự phòng
        throw Exception('Đăng nhập thất bại.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Ném ra thông báo lỗi từ server nếu có
        throw Exception(e.response?.data['message'] ?? 'Lỗi không xác định.');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String role, // 'candidate' hoặc 'recruiter'
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.registerUrl,
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
          'role': role,
        },
      );

      if (response.statusCode != 201) {
        throw Exception('Tạo tài khoản thất bại.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Lỗi không xác định.');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    }
  }
}
