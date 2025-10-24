import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_job_controller.dart';

class CreateJobView extends GetView<CreateJobController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng tin tuyển dụng mới'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                controller: controller.titleController,
                labelText: 'Tiêu đề công việc',
                validator: (value) =>
                    value!.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
              ),
              _buildTextFormField(
                controller: controller.descriptionController,
                labelText: 'Mô tả công việc',
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? 'Vui lòng nhập mô tả' : null,
              ),
              _buildTextFormField(
                controller: controller.requirementsController,
                labelText: 'Yêu cầu ứng viên',
                maxLines: 5,
              ),
              _buildTextFormField(
                controller: controller.salaryController,
                labelText: 'Mức lương (VD: Thỏa thuận)',
              ),
              _buildTextFormField(
                controller: controller.locationController,
                labelText: 'Địa điểm làm việc',
              ),
              _buildTextFormField(
                controller: controller.limitController,
                labelText: 'Số lượng tuyển (để trống nếu không giới hạn)',
                keyboardType: TextInputType.number, // Chỉ cho nhập số
              ),
              SizedBox(height: 24),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.createJob();
                        },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Đăng tin'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: validator,
      ),
    );
  }
}
