// lib/app/modules/home/bindings/home_binding.dart
import 'package:get/get.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../my_applications/controllers/my_applications_controller.dart';
import '../../saved_jobs/controllers/saved_jobs_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SavedJobsController>(() => SavedJobsController());
    Get.lazyPut<MyApplicationsController>(() => MyApplicationsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
