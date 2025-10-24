// lib/app/modules/login/controllers/login_controller.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/socket_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập đầy đủ thông tin');
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authRepository.login(
        emailController.text,
        passwordController.text,
      );

      final userRole = user['role'];

      // Kiểm tra null và làm sạch dữ liệu vai trò
      if (userRole == null) {
        throw Exception('Server không trả về vai trò người dùng.');
      }

      // Kết nối real-time
      Get.find<SocketService>().connectAndListen(user['id'].toString());
      Get.snackbar('Thành công', 'Đăng nhập thành công!');

      // Logic điều hướng dựa trên vai trò đã được làm sạch
      if (userRole.toString().trim() == 'admin') {
        Get.offAllNamed(Routes.ADMIN_DASHBOARD);
      } else if (userRole.toString().trim() == 'recruiter') {
        Get.offAllNamed(Routes.RECRUITER_DASHBOARD);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      Get.snackbar('Lỗi đăng nhập', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
