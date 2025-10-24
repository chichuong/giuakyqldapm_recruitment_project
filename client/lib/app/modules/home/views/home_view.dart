// lib/app/modules/home/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../data/models/job_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../profile/views/profile_view.dart';
import '../../my_applications/views/my_applications_view.dart';
import '../../saved_jobs/views/saved_jobs_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildJobListPage(context),
      SavedJobsView(),
      MyApplicationsView(),
      ProfileView(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.tabIndex.value, children: pages),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTabIndex,
          type: BottomNavigationBarType.fixed, // Quan trọng để hiển thị 4 item
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              label: 'Việc làm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: 'Đã lưu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_copy_outlined),
              label: 'Hồ sơ',
            ),
            // Đổi lại tên tab cho rõ ràng
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Cá nhân',
            ),
          ],
        ),
      ),
    );
  }

  // Widget này xây dựng giao diện cho tab "Việc làm"
  Widget _buildJobListPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Việc làm nổi bật'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => controller.logout(),
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo chức danh...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.jobList.isEmpty) {
                return _buildShimmerList();
              }
              if (controller.jobList.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.search_off,
                  title: 'Không tìm thấy việc làm',
                  message:
                      'Không có công việc nào phù hợp với tiêu chí tìm kiếm của bạn.',
                );
              }
              return RefreshIndicator(
                onRefresh: () => controller.refreshJobs(),
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.only(top: 16),
                  itemCount:
                      controller.jobList.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < controller.jobList.length) {
                      final job = controller.jobList[index];
                      return JobCard(job: job);
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Widget tạo hiệu ứng shimmer khi tải dữ liệu
  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (_, __) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                Container(width: 150.0, height: 16.0, color: Colors.white),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Container(width: 80.0, height: 14.0, color: Colors.white),
                    const SizedBox(width: 16.0),
                    Container(width: 100.0, height: 14.0, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final Job job;
  const JobCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController? homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;

    return Card(
      child: InkWell(
        onTap: () => Get.toNamed(Routes.JOB_DETAIL, arguments: job),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Text(
                      job.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.companyName ?? 'Công ty ẩn danh',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          job.location ?? 'Chưa cập nhật',
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              if (homeController != null)
                Positioned(
                  top: -12,
                  right: -12,
                  child: Obx(() {
                    final isSaved = homeController.savedJobIds.contains(job.id);
                    return IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      onPressed: () => homeController.toggleSaveJob(job),
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
