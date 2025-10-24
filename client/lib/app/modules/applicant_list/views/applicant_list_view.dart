// lib/app/modules/applicant_list/views/applicant_list_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import for date formatting if needed later
import '../../../data/models/applicant_model.dart'; // Ensure model is imported
import '../../../widgets/empty_state_widget.dart'; // Import empty state widget
import '../controllers/applicant_list_controller.dart';

class ApplicantListView extends GetView<ApplicantListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách ứng viên'),
        centerTitle: true, // Center title for better aesthetics
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.applicantList.isEmpty) {
          // Show shimmer or simple loading indicator on initial load
          return Center(child: CircularProgressIndicator());
        }
        if (controller.applicantList.isEmpty) {
          return EmptyStateWidget(
            // Use the custom empty state widget
            icon: Icons.person_search_sharp,
            title: 'Chưa có ứng viên',
            message: 'Khi có ứng viên nộp hồ sơ, họ sẽ xuất hiện ở đây.',
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchApplicants(),
          child: ListView.builder(
            itemCount: controller.applicantList.length,
            itemBuilder: (context, index) {
              final applicant = controller.applicantList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    applicant.fullName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(applicant.email),
                  // Updated Status Chip
                  leading: Tooltip(
                    // SỬA DÒNG NÀY
                    message: _getDetailedStatusTooltip(
                      applicant.applicationStatus,
                      applicant.interviewStatus,
                      applicant.offerStatus,
                    ),
                    child: Chip(
                      label: Text(
                        // SỬA DÒNG NÀY
                        _getShortStatus(
                          applicant.applicationStatus,
                          applicant.interviewStatus,
                          applicant.offerStatus,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // SỬA DÒNG NÀY
                      backgroundColor: _getStatusColor(
                        applicant.applicationStatus,
                        applicant.interviewStatus,
                        applicant.offerStatus,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                  // Updated Action Menu
                  trailing: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert),
                    tooltip: "Tùy chọn", // Add tooltip for accessibility
                    onSelected: (String value) {
                      // Handle actions based on selected value
                      switch (value) {
                        case 'view_cv':
                          // Call view CV function (Ensure applicant model has cvUrl)
                          controller.viewCv(applicant.cvUrl);
                          break;
                        case 'schedule':
                          controller.showScheduleInterviewDialog(applicant.id);
                          break;
                        case 'result':
                          controller.showRecordResultDialog(applicant.id);
                          break;
                        case 'offer':
                          controller.showCreateOfferDialog(applicant.id);
                          break;
                        case 'reject':
                          controller.updateStatus(
                            applicant.id,
                            'rejected',
                          ); // Directly reject application
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      // Dynamically build menu items based on status
                      List<PopupMenuEntry<String>> menuItems = [];
                      final appStatus = applicant.applicationStatus;
                      final interviewStatus = applicant.interviewStatus;

                      // Always show View CV if available
                      if (applicant.cvUrl != null &&
                          applicant.cvUrl!.isNotEmpty) {
                        menuItems.add(
                          PopupMenuItem<String>(
                            value: 'view_cv',
                            child: Text('Xem CV'),
                          ),
                        );
                      }

                      // Can schedule if no interview OR previous one was declined
                      if (interviewStatus == null ||
                          interviewStatus == 'declined') {
                        menuItems.add(
                          PopupMenuItem<String>(
                            value: 'schedule',
                            child: Text('Lên lịch phỏng vấn'),
                          ),
                        );
                      }

                      // Can record result IF interview was confirmed
                      if (interviewStatus == 'confirmed') {
                        menuItems.add(
                          PopupMenuItem<String>(
                            value: 'result',
                            child: Text('Nhập kết quả PV'),
                          ),
                        );
                      }

                      // Can make offer if status is suitable (e.g., after interview confirmation or passing result)
                      // Adjust this condition based on your specific workflow
                      if (appStatus == 'interviewing' &&
                          interviewStatus == 'confirmed') {
                        menuItems.add(
                          PopupMenuItem<String>(
                            value: 'offer',
                            child: Text('Tạo thư mời'),
                          ),
                        );
                      }

                      // Can always reject if not already rejected or offered
                      if (appStatus != 'rejected' && appStatus != 'offered') {
                        menuItems.add(
                          PopupMenuItem<String>(
                            value: 'reject',
                            child: Text('Từ chối hồ sơ'),
                          ),
                        );
                      }

                      // Prevent empty menu if no actions available
                      if (menuItems.isEmpty) {
                        menuItems.add(
                          PopupMenuItem<String>(
                            enabled: false,
                            child: Text('Không có hành động'),
                          ),
                        );
                      }

                      return menuItems;
                    },
                  ),
                  onTap: () {
                    // Optionally navigate to a detailed applicant view if created
                    // Or show details in a dialog
                    _showApplicantDetailsDialog(
                      context,
                      applicant,
                    ); // Example using dialog
                  },
                ),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        // Dùng Obx để lắng nghe cả jobStatus và isUpdatingStatus
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Hiển thị nút Đóng hoặc Mở dựa trên jobStatus
              if (controller.jobStatus.value == 'open')
                OutlinedButton.icon(
                  icon: controller.isUpdatingStatus.value
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.close_rounded),
                  label: Text("Đóng tin"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange.shade800,
                    side: BorderSide(color: Colors.orange.shade800),
                  ),
                  // Vô hiệu hóa nút khi đang xử lý
                  onPressed: controller.isUpdatingStatus.value
                      ? null
                      : () => controller.closeJob(),
                )
              else if (controller.jobStatus.value == 'closed')
                OutlinedButton.icon(
                  icon: controller.isUpdatingStatus.value
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.check_rounded), // Icon khác cho nút Mở
                  label: Text("Mở lại tin"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green.shade700,
                    side: BorderSide(color: Colors.green.shade700),
                  ), // Màu khác
                  onPressed: controller.isUpdatingStatus.value
                      ? null
                      : () => controller.openJob(),
                )
              else // Trường hợp status là unknown hoặc đang load ban đầu
                SizedBox(width: 120), // Giữ chỗ trống
              // Nút Xóa tin (logic tương tự)
              OutlinedButton.icon(
                icon:
                    controller
                        .isUpdatingStatus
                        .value // Dùng chung isUpdatingStatus
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.delete_forever_outlined),
                label: Text("Xóa tin"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade700),
                ),
                onPressed: controller.isUpdatingStatus.value
                    ? null
                    : () => controller.deleteJob(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Functions (Updated) ---

  // Dialog to show basic applicant details when tapping the ListTile
  void _showApplicantDetailsDialog(BuildContext context, Applicant applicant) {
    Get.defaultDialog(
      title: applicant.fullName,
      titleStyle: Get.textTheme.headlineSmall,
      contentPadding: EdgeInsets.all(20),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDetailRow(Icons.email_outlined, applicant.email),
          _buildDetailRow(
            Icons.phone_outlined,
            applicant.phoneNumber ?? 'Chưa cập nhật',
          ),
          _buildDetailRow(
            Icons.calendar_today_outlined,
            "Nộp ngày: ${DateFormat('dd/MM/yyyy').format(applicant.appliedAt)}",
          ),
          SizedBox(height: 24),
          if (applicant.cvUrl != null && applicant.cvUrl!.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.description_outlined),
                label: Text("Xem CV"),
                onPressed: () {
                  controller.viewCv(applicant.cvUrl);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                ),
              ),
            ),
        ],
      ),
      confirm: TextButton(onPressed: () => Get.back(), child: Text("Đóng")),
    );
  }

  // Helper to build rows in the detail dialog
  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Get.textTheme.bodyMedium?.color),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: Get.textTheme.bodyLarge)),
        ],
      ),
    );
  }

  // Returns color based on the combination of statuses
  Color _getStatusColor(
    String appStatus,
    String? interviewStatus,
    String? offerStatus,
  ) {
    if (offerStatus == 'accepted') return Colors.teal.shade700;
    if (offerStatus == 'declined') return Colors.pink.shade700;
    if (appStatus == 'passed_interview') return Colors.lightGreen.shade700;

    if (interviewStatus == 'confirmed') return Colors.orange.shade700;
    if (interviewStatus == 'scheduled') return Colors.yellow.shade800;
    if (interviewStatus == 'declined') return Colors.grey.shade600;

    if (appStatus == 'offered') return Colors.green.shade700;
    if (appStatus == 'rejected') return Colors.red.shade700;
    if (appStatus == 'screening') return Colors.blue.shade700;
    if (appStatus == 'interviewing') return Colors.deepOrange.shade400;

    return Colors.grey.shade500; // Default/pending
  }

  String _getShortStatus(
    String appStatus,
    String? interviewStatus,
    String? offerStatus,
  ) {
    if (offerStatus == 'accepted') return 'Đã nhận việc';
    if (offerStatus == 'declined') return 'Từ chối việc';
    // THÊM TEXT CHO TRẠNG THÁI MỚI// Text ngắn gọn

    if (interviewStatus == 'confirmed') return 'Chờ KQ';
    if (interviewStatus == 'scheduled') return 'Chờ XN';
    if (interviewStatus == 'declined') return 'Từ chối PV';

    if (appStatus == 'offered') return 'Đã mời';
    if (appStatus == 'rejected') return 'Loại';
    if (appStatus == 'screening') return 'Duyệt';
    if (appStatus == 'interviewing') return 'PV';

    return 'Chờ'; // Pending
  }

  String _getDetailedStatusTooltip(
    String appStatus,
    String? interviewStatus,
    String? offerStatus,
  ) {
    if (offerStatus == 'accepted')
      return 'Trạng thái cuối cùng: Đã chấp nhận thư mời.';
    if (offerStatus == 'declined')
      return 'Trạng thái cuối cùng: Đã từ chối thư mời.';
    // THÊM TOOLTIP CHO TRẠNG THÁI MỚI
    if (appStatus == 'passed_interview')
      return 'Kết quả: Đạt phỏng vấn. Chờ thư mời.';

    String appText = 'Hồ sơ: ${appStatus.capitalizeFirst ?? appStatus}';
    String interviewText = '';
    if (interviewStatus != null) {
      interviewText =
          ' | Phỏng vấn: ${interviewStatus.capitalizeFirst ?? interviewStatus}';
    }
    return appText + interviewText;
  }
}
