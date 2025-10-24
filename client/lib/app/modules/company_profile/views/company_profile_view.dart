// lib/app/modules/company_profile/views/company_profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_profile_controller.dart';

class CompanyProfileView extends GetView<CompanyProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hồ sơ công ty')),
      body: Obx(() {
        if (controller.isLoading.value && controller.company.value == null) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: controller.company.value?.logoUrl != null
                          ? NetworkImage(controller.company.value!.logoUrl!)
                          : null,
                      child: controller.company.value?.logoUrl == null
                          ? Icon(
                              Icons.business,
                              size: 60,
                              color: Colors.grey.shade400,
                            )
                          : null,
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: FloatingActionButton(
                        onPressed: () => controller.pickAndUploadLogo(),
                        child: Icon(Icons.camera_alt, size: 20),
                        tooltip: 'Đổi logo',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(labelText: 'Tên công ty'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: controller.addressController,
                decoration: InputDecoration(labelText: 'Địa chỉ'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: controller.descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả công ty'),
                maxLines: 5,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.saveCompanyProfile(),
                child: Obx(
                  () => controller.isLoading.value
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Text('Lưu thay đổi'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
