// lib/app/modules/register/controllers/register_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var selectedRole = 'candidate'.obs; // Mặc định là ứng viên

  var isLoading = false.obs;

  Future<void> register() async {
    // Thêm validation ở đây nếu cần
    isLoading.value = true;
    try {
      await _authRepository.register(
        email: emailController.text,
        password: passwordController.text,
        fullName: fullNameController.text,
        role: selectedRole.value,
      );
      Get.back(); // Quay lại màn hình đăng nhập
      Get.snackbar(
        'Thành công',
        'Tạo tài khoản thành công! Vui lòng đăng nhập.',
      );
    } catch (e) {
      Get.snackbar('Lỗi đăng ký', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
