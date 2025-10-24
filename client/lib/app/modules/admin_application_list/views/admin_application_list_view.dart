// lib/app/modules/admin_application_list/views/admin_application_list_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_application_list_controller.dart';

class AdminApplicationListView extends GetView<AdminApplicationListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý Hồ sơ')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchApplications(),
          child: ListView.builder(
            itemCount: controller.applicationList.length,
            itemBuilder: (context, index) {
              final app = controller.applicationList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    'Ứng viên: ${app.candidateName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Vị trí: ${app.jobTitle}'),
                  trailing: Chip(
                    label: Text(app.status.capitalizeFirst ?? ''),
                    backgroundColor: _getStatusColor(app.status),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'screening':
        return Colors.blue.shade700;
      case 'interviewing':
        return Colors.orange.shade700;
      case 'offered':
        return Colors.green.shade700;
      case 'rejected':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade500;
    }
  }
}
