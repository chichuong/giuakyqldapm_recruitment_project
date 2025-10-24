import 'package:get/get.dart';
import '../controllers/applicant_list_controller.dart';

class ApplicantListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicantListController>(() => ApplicantListController());
  }
}
