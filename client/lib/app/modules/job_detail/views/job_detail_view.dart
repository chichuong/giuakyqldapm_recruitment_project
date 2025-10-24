// lib/app/modules/job_detail/views/job_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/job_detail_controller.dart';

class JobDetailView extends GetView<JobDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết công việc')),
      // Dùng Obx để lắng nghe cả isPageLoading và jobDetail
      body: Obx(() {
        // Hiển thị loading cho cả trang
        if (controller.isPageLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        // Kiểm tra nếu jobDetail vẫn null sau khi tải (có lỗi)
        if (controller.jobDetail.value == null) {
          return Center(child: Text('Không thể tải chi tiết công việc.'));
        }

        // Sử dụng jobDetail đã được tải
        final job = controller.jobDetail.value!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.title,
                style: Get.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Hiển thị tên công ty
              Text(
                job.companyName ?? 'Công ty ẩn danh',
                style: Get.textTheme.titleMedium,
              ),
              SizedBox(height: 16),
              _buildInfoRow(Icons.location_on, job.location ?? 'Chưa cập nhật'),
              _buildInfoRow(Icons.attach_money, job.salary ?? 'Thỏa thuận'),
              SizedBox(height: 16),
              _buildSectionTitle('Mô tả công việc'),
              Text(job.description), // Giả sử model Job có description
              SizedBox(height: 16),
              _buildSectionTitle('Yêu cầu ứng viên'),
              Text(
                job.requirements ?? 'Chưa cập nhật',
              ), // Giả sử model Job có requirements
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Hiển thị loading hoặc nút bấm dựa trên isPageLoading
          if (controller.isPageLoading.value) {
            return SizedBox(height: 50); // Giữ chỗ trống khi đang tải
          }

          // Kiểm tra nếu jobDetail null thì không hiện nút
          if (controller.jobDetail.value == null) {
            return SizedBox.shrink();
          }

          final alreadyApplied = controller.hasApplied.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Chỉ hiển thị phần chọn CV nếu chưa ứng tuyển
              if (!alreadyApplied) ...[
                OutlinedButton.icon(
                  icon: Icon(Icons.upload_file),
                  label: Text("Chọn file CV"),
                  onPressed: () => controller.pickCvFile(),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                SizedBox(height: 8),
                Obx(
                  () => controller.selectedCvFile.value != null
                      ? Text(
                          'Đã chọn: ${controller.selectedCvFile.value!.path.split('/').last}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green.shade800),
                        )
                      : SizedBox.shrink(),
                ),
                SizedBox(height: 16),
              ],
              // NÚT BẤM CHÍNH (NỘP HỒ SƠ / ĐÃ ỨNG TUYỂN)
              ElevatedButton(
                // Vô hiệu hóa nếu đang loading hoặc đã ứng tuyển
                onPressed: controller.isLoading.value || alreadyApplied
                    ? null
                    : () => controller.applyToJob(),
                child: controller.isLoading.value
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        alreadyApplied ? 'Bạn đã ứng tuyển' : 'Nộp hồ sơ ngay',
                      ),
                style: ElevatedButton.styleFrom(
                  // Có thể đổi màu nền nếu đã ứng tuyển
                  backgroundColor: alreadyApplied
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
