// lib/app/modules/admin_job_list/controllers/admin_job_list_controller.dart
import 'package:get/get.dart';
import '../../../data/models/job_model.dart';
import '../../../data/repositories/admin_repository.dart';

class AdminJobListController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();
  var jobList = <Job>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      isLoading(true);
      final result = await _adminRepository.getAllJobs();
      jobList.value = result;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
