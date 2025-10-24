// lib/app/modules/admin_user_list/bindings/admin_user_list_binding.dart
import 'package:get/get.dart';
import '../controllers/admin_user_list_controller.dart';

class AdminUserListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminUserListController>(() => AdminUserListController());
  }
}
