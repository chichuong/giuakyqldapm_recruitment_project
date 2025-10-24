import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_company_list_controller.dart';

class AdminCompanyListView extends GetView<AdminCompanyListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý Công ty')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchCompanies(),
          child: ListView.builder(
            itemCount: controller.companyList.length,
            itemBuilder: (context, index) {
              final company = controller.companyList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: company.logoUrl != null
                        ? NetworkImage(company.logoUrl!)
                        : null,
                    child: company.logoUrl == null
                        ? Icon(Icons.business)
                        : null,
                  ),
                  title: Text(
                    company.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(company.address ?? 'Chưa có địa chỉ'),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
