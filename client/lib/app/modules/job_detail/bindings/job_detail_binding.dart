// lib/app/modules/job_detail/bindings/job_detail_binding.dart
import 'package:get/get.dart';
import '../controllers/job_detail_controller.dart';

class JobDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobDetailController>(() => JobDetailController());
  }
}
