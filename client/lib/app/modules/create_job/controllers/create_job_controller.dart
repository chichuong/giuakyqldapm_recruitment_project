// lib/app/modules/create_job/controllers/create_job_controller.dart

import 'package:dio/dio.dart'; // Sử dụng Dio cho nhất quán
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/constants/api_constants.dart';
// Import controller của dashboard để gọi refresh
import '../../recruiter_dashboard/controllers/recruiter_dashboard_controller.dart';

class CreateJobController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final requirementsController = TextEditingController();
  final salaryController = TextEditingController();
  final locationController = TextEditingController();
  // THÊM CONTROLLER MỚI
  final limitController = TextEditingController();

  var isLoading = false.obs;
  final Dio _dio = Dio(); // Sử dụng Dio

  Future<void> createJob() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Xử lý giá trị application_limit
      int? applicationLimit;
      if (limitController.text.isNotEmpty) {
        try {
          applicationLimit = int.parse(limitController.text);
          if (applicationLimit <= 0)
            applicationLimit = null; // Chỉ chấp nhận số dương
        } catch (e) {
          applicationLimit = null; // Bỏ qua nếu nhập không phải số
        }
      }

      final response = await _dio.post(
        ApiConstants.jobsUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'title': titleController.text,
          'description': descriptionController.text,
          'requirements': requirementsController.text,
          'salary': salaryController.text,
          'location': locationController.text,
          'application_limit': applicationLimit, // <-- Gửi giá trị limit
        },
      );

      final data = response.data;

      if (response.statusCode == 201) {
        // Tìm và gọi hàm fetchMyJobs() để refresh lại danh sách dashboard
        // Sử dụng tryFind để tránh lỗi nếu controller chưa được tạo
        final dashboardController =
            Get.isRegistered<RecruiterDashboardController>()
            ? Get.find<RecruiterDashboardController>()
            : null;
        dashboardController?.fetchMyJobs();

        Get.back(
          result: 'success',
        ); // Trả về success để dashboard biết cần refresh
        Get.snackbar(
          'Thành công',
          data['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Thất bại',
          data['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      // Bắt lỗi DioException
      Get.snackbar('Lỗi', e.response?.data['message'] ?? 'Lỗi kết nối');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    requirementsController.dispose();
    salaryController.dispose();
    locationController.dispose();
    limitController.dispose(); // <-- Nhớ dispose controller mới
    super.onClose();
  }
}
