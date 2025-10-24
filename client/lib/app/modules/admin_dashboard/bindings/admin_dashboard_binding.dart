// lib/app/modules/admin_dashboard/bindings/admin_dashboard_binding.dart
import 'package:get/get.dart';
import '../../../data/repositories/admin_repository.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminRepository>(() => AdminRepository());
    Get.lazyPut<AdminDashboardController>(() => AdminDashboardController());
  }
}
