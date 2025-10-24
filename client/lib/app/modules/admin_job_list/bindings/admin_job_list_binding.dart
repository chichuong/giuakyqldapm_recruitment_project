// lib/app/modules/admin_job_list/bindings/admin_job_list_binding.dart
import 'package:get/get.dart';
import '../controllers/admin_job_list_controller.dart';

class AdminJobListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminJobListController>(() => AdminJobListController());
  }
}
