// lib/app/modules/my_applications/controllers/my_applications_controller.dart

import 'package:get/get.dart';
import '../../../data/models/my_application_model.dart';
import '../../../data/repositories/application_repository.dart';
import '../../../data/services/socket_service.dart';

class MyApplicationsController extends GetxController {
  final ApplicationRepository _repo = ApplicationRepository();
  final SocketService _socketService = Get.find();

  var applicationList = <MyApplication>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApplications();
    // Lắng nghe sự kiện real-time
    _socketService.socket?.on('status_update', (data) {
      // Khi có cập nhật, chỉ cần tải lại toàn bộ danh sách
      fetchApplications();
    });
  }

  Future<void> fetchApplications() async {
    try {
      isLoading(true);
      final result = await _repo.getMyApplications();
      applicationList.value = result;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    // Hủy lắng nghe sự kiện để tránh rò rỉ bộ nhớ
    _socketService.socket?.off('status_update');
    super.onClose();
  }
}
