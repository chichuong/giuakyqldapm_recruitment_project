// lib/app/modules/admin_dashboard/views/admin_dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => controller.logout(),
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.stats.value == null) {
          return Center(child: Text('Không thể tải dữ liệu thống kê.'));
        }
        final stats = controller.stats.value!;
        return RefreshIndicator(
          onRefresh: () => controller.fetchStats(),
          child: GridView.count(
            padding: EdgeInsets.all(16.0),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              InkWell(
                onTap: () => Get.toNamed(Routes.ADMIN_USER_LIST),
                child: _buildStatCard(
                  'Tổng Người Dùng',
                  stats.totalUsers.toString(),
                  Icons.people_outline,
                  Colors.blue,
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed(Routes.ADMIN_COMPANY_LIST),
                child: _buildStatCard(
                  'Tổng Công Ty',
                  stats.totalCompanies.toString(),
                  Icons.business,
                  Colors.orange,
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed(Routes.ADMIN_JOB_LIST),
                child: _buildStatCard(
                  'Tổng Việc Làm',
                  stats.totalJobs.toString(),
                  Icons.work_outline,
                  Colors.green,
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed(Routes.ADMIN_APPLICATION_LIST),
                child: _buildStatCard(
                  'Tổng Hồ Sơ',
                  stats.totalApplications.toString(),
                  Icons.folder_copy_outlined,
                  Colors.purple,
                ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 12),
              Text(
                value,
                style: Get.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: Get.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
