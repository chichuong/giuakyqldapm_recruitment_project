// lib/app/data/repositories/company_repository.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../models/company_model.dart';

class CompanyRepository {
  final Dio _dio = Dio();

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');
    return token;
  }

  // Lấy thông tin công ty của nhà tuyển dụng
  Future<Company?> getMyCompany() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/companies/my',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      // API có thể trả về null nếu chưa có công ty
      if (response.data == null) {
        return null;
      }
      return Company.fromJson(response.data);
    } on DioException catch (e) {
      // Bỏ qua lỗi 404 (chưa tạo công ty)
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception(_handleDioError(e));
    }
  }

  // Tạo hoặc cập nhật thông tin công ty
  Future<void> createOrUpdateCompany({
    required String name,
    String? description,
    String? address,
  }) async {
    try {
      final token = await _getToken();
      await _dio.post(
        '${ApiConstants.baseUrl}/api/companies/my',
        data: {'name': name, 'description': description, 'address': address},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // Upload logo công ty
  Future<String> uploadLogo(File imageFile) async {
    try {
      final token = await _getToken();
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "logo": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/upload/company-logo',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['url'];
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data is Map) {
      return e.response?.data['message'] ?? 'Lỗi không xác định từ server.';
    } else if (e.response != null) {
      return 'Lỗi server: ${e.response?.statusCode}. Vui lòng thử lại.';
    } else {
      return 'Lỗi kết nối. Vui lòng kiểm tra mạng của bạn.';
    }
  }
}
