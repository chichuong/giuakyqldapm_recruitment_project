// lib/app/modules/recruiter_dashboard/bindings/recruiter_dashboard_binding.dart
import 'package:get/get.dart';
import '../../profile/controllers/profile_controller.dart'; // <-- Thêm import này
import '../controllers/recruiter_dashboard_controller.dart';

class RecruiterDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecruiterDashboardController>(
      () => RecruiterDashboardController(),
    );
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
