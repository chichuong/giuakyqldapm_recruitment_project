// lib/app/modules/report/views/report_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Báo cáo thống kê'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.statistics.value == null) {
          return Center(child: Text('Không có dữ liệu để hiển thị.'));
        }

        final stats = controller.statistics.value!;
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatCard(
                'Tổng số tin đã đăng',
                stats.totalJobs.toString(),
                Icons.work,
                Colors.blue,
              ),
              _buildStatCard(
                'Tổng số hồ sơ đã nhận',
                stats.totalApplications.toString(),
                Icons.people,
                Colors.green,
              ),
              SizedBox(height: 20),
              Text('Thống kê theo trạng thái', style: Get.textTheme.titleLarge),
              SizedBox(height: 10),
              _buildStatusRow(
                'Chờ duyệt (Pending)',
                stats.statusCounts.pending,
              ),
              _buildStatusRow(
                'Đang sàng lọc (Screening)',
                stats.statusCounts.screening,
              ),
              _buildStatusRow(
                'Phỏng vấn (Interviewing)',
                stats.statusCounts.interviewing,
              ),
              _buildStatusRow('Đã mời (Offered)', stats.statusCounts.offered),
              _buildStatusRow(
                'Đã từ chối (Rejected)',
                stats.statusCounts.rejected,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Get.textTheme.titleMedium),
                Text(
                  value,
                  style: Get.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String statusName, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(statusName, style: Get.textTheme.bodyLarge),
          Text(
            count.toString(),
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
