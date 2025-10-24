// lib/app/modules/admin_user_list/views/admin_user_list_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_user_list_controller.dart';

class AdminUserListView extends GetView<AdminUserListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý Người dùng')),
      body: Obx(() {
        if (controller.isLoading.value && controller.userList.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchUsers(isInitial: true),
          child: ListView.builder(
            controller: controller.scrollController,
            itemCount:
                controller.userList.length +
                (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.userList.length) {
                final user = controller.userList[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(_getIconForRole(user.role)),
                    ),
                    title: Text(
                      user.fullName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${user.email}\nNgày tạo: ${DateFormat('dd/MM/yyyy').format(user.createdAt)}',
                    ),
                    trailing: Chip(
                      label: Text(user.role.capitalizeFirst ?? ''),
                      backgroundColor: _getColorForRole(user.role),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
      }),
    );
  }

  IconData _getIconForRole(String role) {
    switch (role) {
      case 'admin':
        return Icons.security;
      case 'recruiter':
        return Icons.business_center_outlined;
      default:
        return Icons.person_outline;
    }
  }

  Color _getColorForRole(String role) {
    switch (role) {
      case 'admin':
        return Colors.red.shade700;
      case 'recruiter':
        return Colors.blue.shade700;
      default:
        return Colors.green.shade700;
    }
  }
}
