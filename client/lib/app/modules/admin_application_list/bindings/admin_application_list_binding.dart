// lib/app/modules/admin_application_list/bindings/admin_application_list_binding.dart
import 'package:get/get.dart';
import '../controllers/admin_application_list_controller.dart';

class AdminApplicationListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminApplicationListController>(
      () => AdminApplicationListController(),
    );
  }
}
