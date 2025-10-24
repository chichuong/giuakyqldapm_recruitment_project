// lib/app/modules/admin_job_list/views/admin_job_list_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import HomeView để có thể tái sử dụng JobCard
import '../../home/views/home_view.dart';
import '../controllers/admin_job_list_controller.dart';

class AdminJobListView extends GetView<AdminJobListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý Việc làm')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchJobs(),
          child: ListView.builder(
            itemCount: controller.jobList.length,
            itemBuilder: (context, index) {
              final job = controller.jobList[index];
              // Tái sử dụng JobCard cho giao diện đồng nhất
              return JobCard(job: job);
            },
          ),
        );
      }),
    );
  }
}
