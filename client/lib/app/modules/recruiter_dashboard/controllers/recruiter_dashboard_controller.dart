import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/job_model.dart';
import '../../../data/repositories/job_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/socket_service.dart';
import '../../profile/controllers/profile_controller.dart';

class RecruiterDashboardController extends GetxController {
  final JobRepository _jobRepository = JobRepository();
  var myJobs = <Job>[].obs;
  var isLoading = true.obs;
  var tabIndex = 0.obs;
  void changeTabIndex(int index) {
    tabIndex.value = index;
    if (index == 1) {
      Get.find<ProfileController>().fetchUserProfile();
    }
  }

  @override
  void onInit() {
    super.onInit();
    Get.find<ProfileController>();
    fetchMyJobs();
  }

  Future<void> fetchMyJobs() async {
    try {
      isLoading(true);
      final jobs = await _jobRepository.fetchMyJobs();
      myJobs.value = jobs;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    Get.find<SocketService>().disconnect();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    Get.offAllNamed(Routes.LOGIN);
  }
}
