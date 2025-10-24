// lib/app/modules/my_applications/bindings/my_applications_binding.dart
import 'package:get/get.dart';
import '../controllers/my_applications_controller.dart';

class MyApplicationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyApplicationsController>(() => MyApplicationsController());
  }
}
