// lib/app/modules/register/views/register_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo tài khoản'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: controller.fullNameController,
              decoration: InputDecoration(labelText: 'Họ và tên'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: controller.emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: controller.passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            Text('Bạn là:', style: Theme.of(context).textTheme.titleMedium),
            Obx(
              () => DropdownButton<String>(
                value: controller.selectedRole.value,
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: 'candidate',
                    child: Text('Ứng viên tìm việc'),
                  ),
                  DropdownMenuItem(
                    value: 'recruiter',
                    child: Text('Nhà tuyển dụng'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedRole.value = value;
                  }
                },
              ),
            ),
            SizedBox(height: 32),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.register(),
                child: controller.isLoading.value
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text('Đăng ký'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
