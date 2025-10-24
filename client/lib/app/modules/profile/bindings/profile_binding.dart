// lib/app/modules/profile/bindings/profile_binding.dart
import 'package:get/get.dart';
import '../../../data/repositories/profile_repository.dart'; // Thêm repo CV
import '../../../data/repositories/user_repository.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Đăng ký cả hai repository cần thiết
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<ProfileRepository>(() => ProfileRepository());
    // Khởi tạo Controller
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
