// lib/app/bindings/initial_binding.dart

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_pages.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {}

  static Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role');

    // Đợi một chút để Splash Screen hiển thị cho đẹp
    await Future.delayed(const Duration(seconds: 1));

    if (token != null && role != null) {
      // Logic điều hướng dựa trên vai trò đã được làm sạch
      if (role.trim() == 'admin') {
        Get.offAllNamed(Routes.ADMIN_DASHBOARD);
      } else if (role.trim() == 'recruiter') {
        Get.offAllNamed(Routes.RECRUITER_DASHBOARD);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
