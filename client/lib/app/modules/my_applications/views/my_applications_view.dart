// lib/app/modules/my_applications/views/my_applications_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_pages.dart'; // Import Routes
import '../../../widgets/empty_state_widget.dart';
import '../controllers/my_applications_controller.dart';

class MyApplicationsView extends GetView<MyApplicationsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ đã nộp'),
        automaticallyImplyLeading: false, // Ẩn nút back vì là tab
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.applicationList.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.folder_off_outlined, // Icon khác
            title: 'Chưa có hồ sơ nào',
            message: 'Các công việc bạn đã ứng tuyển sẽ xuất hiện ở đây.',
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchApplications(),
          child: ListView.builder(
            itemCount: controller.applicationList.length,
            itemBuilder: (context, index) {
              final application = controller.applicationList[index];
              return Card(
                child: InkWell(
                  // Bọc trong InkWell để có thể bấm vào xem chi tiết
                  onTap: () {
                    // Điều hướng đến trang chi tiết hồ sơ
                    Get.toNamed(
                      Routes.APPLICATION_DETAIL,
                      arguments: application.applicationId,
                    );
                  },
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Bo góc cho hiệu ứng nhấn
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.jobTitle,
                          style: Get.textTheme.titleLarge,
                        ),
                        SizedBox(height: 8),
                        Text(
                          application.recruiterName,
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: Get.theme.textTheme.bodyMedium?.color,
                          ),
                        ), // Màu chữ phụ
                        SizedBox(height: 12),
                        // --- SỬA LỖI OVERFLOW Ở ROW NÀY ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                              label: Text(
                                _getShortStatusText(application.status),
                              ), // Dùng hàm helper cho text ngắn gọn
                              backgroundColor: _getStatusColor(
                                application.status,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ), // Cỡ chữ nhỏ hơn
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ), // Padding nhỏ hơn
                            ),
                            SizedBox(width: 8), // Thêm khoảng cách nhỏ
                            // Bọc Text ngày nộp trong Expanded
                            Expanded(
                              child: Text(
                                'Ngày nộp: ${DateFormat('dd/MM/yyyy').format(application.appliedAt)}',
                                style: Get.textTheme.bodyMedium,
                                textAlign: TextAlign.right, // Căn phải cho đẹp
                                overflow: TextOverflow
                                    .ellipsis, // Hiển thị ... nếu vẫn quá dài
                              ),
                            ),
                          ],
                        ),
                        // --- KẾT THÚC SỬA LỖI ---
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // Hàm helper để lấy màu trạng thái (có thể copy từ file khác nếu đã có)
  Color _getStatusColor(String status) {
    switch (status) {
      case 'screening':
        return Colors.blue.shade700;
      case 'interviewing':
        return Colors.orange.shade700;
      case 'passed_interview':
        return Colors.lightGreen.shade700; // Thêm trạng thái mới
      case 'offered':
        return Colors.green.shade700;
      case 'rejected':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade500; // pending
    }
  }

  // Hàm helper để lấy text trạng thái ngắn gọn
  String _getShortStatusText(String status) {
    switch (status) {
      case 'screening':
        return 'Đang duyệt';
      case 'interviewing':
        return 'Phỏng vấn';
      case 'passed_interview':
        return 'Đạt PV';
      case 'offered':
        return 'Đã mời';
      case 'rejected':
        return 'Bị loại';
      default:
        return 'Đang chờ'; // pending
    }
  }
}
