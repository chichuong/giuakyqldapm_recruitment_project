// lib/app/modules/admin_application_list/controllers/admin_application_list_controller.dart
import 'package:get/get.dart';
import '../../../data/models/admin_application_list_model.dart';
import '../../../data/repositories/admin_repository.dart';

class AdminApplicationListController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();
  var applicationList = <AdminApplicationListItem>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    try {
      isLoading(true);
      final result = await _adminRepository.getAllApplications();
      applicationList.value = result;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
