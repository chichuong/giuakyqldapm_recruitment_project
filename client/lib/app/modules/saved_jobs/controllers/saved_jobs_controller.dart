// lib/app/modules/saved_jobs/controllers/saved_jobs_controller.dart

import 'package:get/get.dart';
import '../../../data/models/job_model.dart';
import '../../../data/repositories/job_repository.dart';

class SavedJobsController extends GetxController {
  final JobRepository _jobRepository = JobRepository();

  var savedJobsList = <Job>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavedJobs();
  }

  Future<void> fetchSavedJobs() async {
    try {
      isLoading(true);
      final result = await _jobRepository.getSavedJobs();
      savedJobsList.value = result;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
