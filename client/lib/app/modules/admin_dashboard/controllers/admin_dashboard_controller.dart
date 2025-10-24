// lib/app/modules/admin_dashboard/controllers/admin_dashboard_controller.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/system_stats_model.dart';
import '../../../data/repositories/admin_repository.dart';
import '../../../data/services/socket_service.dart';
import '../../../routes/app_pages.dart';

class AdminDashboardController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();

  var stats = Rxn<SystemStats>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      isLoading(true);
      final result = await _adminRepository.getSystemStats();
      stats.value = result;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    Get.find<SocketService>().disconnect();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.LOGIN);
  }
}
