// lib/app/modules/recruiter_dashboard/views/recruiter_dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../profile/views/profile_view.dart'; // <-- Thêm import
import '../controllers/recruiter_dashboard_controller.dart';

class RecruiterDashboardView extends GetView<RecruiterDashboardController> {
  @override
  Widget build(BuildContext context) {
    // Danh sách các trang con tương ứng với các tab
    final List<Widget> pages = [
      _buildDashboardPage(context), // Trang tab "Quản lý"
      ProfileView(), // Trang tab "Cá nhân"
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.tabIndex.value, children: pages),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTabIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Quản lý',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Cá nhân',
            ),
          ],
        ),
      ),
    );
  }

  // Toàn bộ giao diện cũ của bạn được chuyển vào trong hàm này
  // Nó trả về một Scaffold riêng cho tab quản lý
  Widget _buildDashboardPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý tin đăng'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () => Get.toNamed(Routes.REPORT),
            tooltip: 'Báo cáo',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.myJobs.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.post_add,
            title: 'Bạn chưa có tin đăng nào',
            message:
                'Hãy nhấn nút (+) ở góc dưới để bắt đầu đăng tin tuyển dụng đầu tiên của bạn!',
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchMyJobs(),
          child: ListView.builder(
            itemCount: controller.myJobs.length,
            itemBuilder: (context, index) {
              final job = controller.myJobs[index];
              return Card(
                child: InkWell(
                  onTap: () =>
                      Get.toNamed(Routes.APPLICANT_LIST, arguments: job.id),
                  borderRadius: BorderRadius.circular(12.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                            SizedBox(width: 4),
                            Text(
                              job.location ?? 'N/A',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () async {
          final result = await Get.toNamed(Routes.CREATE_JOB);
          if (result == 'success') {
            controller.fetchMyJobs();
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Đăng tin mới',
      ),
    );
  }
}
