// lib/app/modules/job_detail/controllers/job_detail_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../../data/constants/api_constants.dart';
import '../../../data/models/job_model.dart';
import '../../../data/repositories/application_repository.dart';
import '../../../data/repositories/job_repository.dart';

class JobDetailController extends GetxController {
  final JobRepository _jobRepository = JobRepository();
  final ApplicationRepository _applicationRepository = ApplicationRepository();

  // Giữ job ban đầu được truyền qua arguments
  final Job initialJobData = Get.arguments;
  // Tạo Rx biến để lưu job chi tiết
  var jobDetail = Rxn<Job>();

  var isLoading = false.obs;
  var isPageLoading = true.obs;
  var hasApplied = false.obs;
  var selectedCvFile = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    fetchJobDetails();
  }

  // TẢI CHI TIẾT JOB (BAO GỒM hasApplied)
  Future<void> fetchJobDetails() async {
    try {
      isPageLoading(true);
      final result = await _jobRepository.getJobById(initialJobData.id);
      jobDetail.value = result;
      hasApplied.value = result.hasApplied;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải chi tiết công việc.');

      jobDetail.value = initialJobData;
    } finally {
      isPageLoading(false);
    }
  }

  Future<void> pickCvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      selectedCvFile.value = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }
  }

  Future<String?> _uploadCv(File cvFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      Dio dio = Dio();

      String fileName = cvFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "cv": await MultipartFile.fromFile(cvFile.path, filename: fileName),
      });

      final response = await dio.post(
        '${ApiConstants.baseUrl}/api/upload/cv',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['url'];
      }
      return null;
    } catch (e) {
      Get.snackbar('Lỗi Upload', 'Không thể tải file CV lên server.');
      return null;
    }
  }

  Future<void> applyToJob() async {
    // 1. Check if already applied
    if (hasApplied.value) {
      Get.snackbar('Thông báo', 'Bạn đã ứng tuyển vào công việc này rồi.');
      return;
    }

    // 2. Check if CV is selected
    if (selectedCvFile.value == null) {
      Get.snackbar(
        'Thiếu thông tin',
        'Vui lòng chọn một file CV để ứng tuyển.',
      );
      return;
    }

    isLoading.value = true; // Start loading indicator
    try {
      // 3. Upload CV via Repository
      // Assuming _uploadCv handles calling the repository internally
      // If not, call repository directly: final cvUrl = await _applicationRepository.uploadCv(selectedCvFile.value!);
      final cvUrl = await _uploadCv(
        selectedCvFile.value!,
      ); // Using existing helper

      if (cvUrl == null) {
        // Stop if CV upload failed (error snackbar is shown in _uploadCv)
        isLoading.value = false;
        return;
      }

      // 4. Apply for the Job via Repository
      // Use jobDetail.value?.id if jobDetail is loaded, otherwise fallback to initial data
      final jobId = jobDetail.value?.id ?? initialJobData.id;
      await _applicationRepository.applyToJob(jobId, cvUrl);

      // 5. Update application status locally
      hasApplied.value = true;
      Get.snackbar(
        'Thành công',
        'Nộp hồ sơ thành công!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Show specific error from repository/backend if possible
      Get.snackbar(
        'Lỗi',
        'Nộp hồ sơ thất bại: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; // Stop loading indicator
    }
  }
}
