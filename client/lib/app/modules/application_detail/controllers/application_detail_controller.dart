// lib/app/modules/application_detail/controllers/application_detail_controller.dart
import 'package:get/get.dart';
import '../../../data/models/application_detail_model.dart';
import '../../../data/repositories/application_repository.dart';

class ApplicationDetailController extends GetxController {
  final ApplicationRepository _repo = ApplicationRepository();
  final int applicationId = Get.arguments;

  var applicationDetail = Rxn<ApplicationDetail>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try {
      isLoading(true);
      final result = await _repo.getApplicationDetails(applicationId);
      applicationDetail.value = result;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải chi tiết hồ sơ.');
    } finally {
      isLoading(false);
    }
  }

  // Hàm phản hồi lịch phỏng vấn (Đã có từ trước)
  Future<void> respondToInterview(String status) async {
    if (applicationDetail.value?.interviewId == null) return;
    // Add loading state if desired
    try {
      await _repo.updateInterviewStatus(
        applicationDetail.value!.interviewId!,
        status,
      );
      Get.snackbar('Thành công', 'Đã gửi phản hồi của bạn.');
      fetchDetails(); // Reload to update UI
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      // Stop loading state
    }
  }

  Future<void> respondToOffer(String status) async {
    if (applicationDetail.value?.offerId == null) return;
    try {
      // Có thể thêm isLoading nếu muốn
      await _repo.respondToOffer(applicationDetail.value!.offerId!, status);
      Get.snackbar('Thành công', 'Đã gửi phản hồi thư mời.');
      fetchDetails(); // Tải lại để cập nhật giao diện
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      // Tắt isLoading nếu có
    }
  }
}
