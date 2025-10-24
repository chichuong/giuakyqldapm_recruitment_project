// lib/app/modules/saved_jobs/views/saved_jobs_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../home/views/home_view.dart'; // Tái sử dụng JobCard
import '../controllers/saved_jobs_controller.dart';

class SavedJobsView extends GetView<SavedJobsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Việc làm đã lưu')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.savedJobsList.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.bookmark_border,
            title: 'Chưa có việc làm nào được lưu',
            message:
                'Hãy nhấn vào biểu tượng bookmark để lưu lại các công việc bạn quan tâm!',
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchSavedJobs(),
          child: ListView.builder(
            itemCount: controller.savedJobsList.length,
            itemBuilder: (context, index) {
              final job = controller.savedJobsList[index];
              // Tái sử dụng JobCard từ màn hình Home
              return JobCard(job: job);
            },
          ),
        );
      }),
    );
  }
}
