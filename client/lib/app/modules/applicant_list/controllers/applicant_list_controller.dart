// lib/app/modules/applicant_list/controllers/applicant_list_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/constants/api_constants.dart';
import '../../../data/models/applicant_model.dart';
import '../../../data/repositories/application_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as DateTimePicker;
import 'package:intl/intl.dart';
import '../../../data/repositories/job_repository.dart';
import '../../recruiter_dashboard/controllers/recruiter_dashboard_controller.dart';
import '../../../data/repositories/application_repository.dart'
    show JobApplicantsResponse;

class ApplicantListController extends GetxController {
  final int jobId = Get.arguments;
  final ApplicationRepository _repo = ApplicationRepository();
  final JobRepository _jobRepo = JobRepository();
  var applicantList = <Applicant>[].obs;
  var isLoading = true.obs;
  var jobStatus = 'open'.obs;
  var isUpdatingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApplicants();
  }

  Future<void> fetchApplicants() async {
    try {
      isLoading(true);
      // Nhận kết quả từ repo
      final JobApplicantsResponse result = await _repo.getJobApplicants(jobId);
      applicantList.value = result.applicants;
      jobStatus.value = result.jobStatus; // <-- Lưu trạng thái job
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
      jobStatus.value = 'unknown'; // Đặt trạng thái lỗi nếu không tải được
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateStatus(int applicationId, String newStatus) async {
    try {
      await _repo.updateApplicationStatus(applicationId, newStatus);
      Get.snackbar('Thành công', 'Cập nhật trạng thái thành công.');
      fetchApplicants();
    } catch (e) {
      Get.snackbar('Thất bại', e.toString());
    }
  }

  void showScheduleInterviewDialog(int applicationId) {
    final locationController = TextEditingController();
    final notesController = TextEditingController();

    DateTimePicker.DatePicker.showDateTimePicker(
      Get.context!,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime(2101, 12, 31),
      onConfirm: (date) {
        Get.defaultDialog(
          title: "Thông tin bổ sung",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ngày giờ phỏng vấn đã chọn:\n${DateFormat('dd/MM/yyyy, HH:mm').format(date)}',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "Địa điểm",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: "Ghi chú (tùy chọn)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          confirm: ElevatedButton(
            onPressed: () {
              Get.back(); // Đóng dialog
              String formattedDateTime = date.toIso8601String();
              _scheduleInterview(
                applicationId,
                formattedDateTime,
                locationController.text,
                notesController.text,
              );
            },
            child: Text("Lên lịch"),
          ),
          cancel: TextButton(onPressed: () => Get.back(), child: Text("Hủy")),
        );
      },
      currentTime: DateTime.now(),
      locale: DateTimePicker.LocaleType.vi,
    );
  }

  Future<void> _scheduleInterview(
    int applicationId,
    String interviewDate,
    String location,
    String notes,
  ) async {
    try {
      await _repo.scheduleInterview(
        applicationId,
        interviewDate,
        location,
        notes,
      );
      Get.snackbar('Thành công', 'Lên lịch phỏng vấn thành công');
      fetchApplicants();
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    }
  }

  void showRecordResultDialog(int applicationId) {
    final commentsController = TextEditingController();
    RxString result = 'pass'.obs;

    Get.dialog(
      AlertDialog(
        title: Text("Nhập kết quả phỏng vấn"),
        content: SizedBox(
          width: Get.width, // Chiếm gần hết chiều rộng màn hình
          // Bọc nội dung trong SingleChildScrollView để cho phép cuộn
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => RadioListTile<String>(
                    title: const Text('Đạt (Pass)'),
                    value: 'pass',
                    groupValue: result.value,
                    onChanged: (value) => result.value = value!,
                  ),
                ),
                Obx(
                  () => RadioListTile<String>(
                    title: const Text('Không đạt (Fail)'),
                    value: 'fail',
                    groupValue: result.value,
                    onChanged: (value) => result.value = value!,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: commentsController,
                  decoration: InputDecoration(
                    labelText: 'Nhận xét / Lời nhắn (sẽ gửi qua email)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4, // Tăng số dòng
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("Hủy")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Gọi hàm _recordResult với comments
              _recordResult(
                applicationId,
                result.value,
                commentsController.text,
              );
            },
            child: Text("Lưu & Gửi mail"),
          ),
        ],
      ),
    );
  }

  // --- HÀM GỌI API  ---
  Future<void> _recordResult(
    int applicationId,
    String result,
    String comments,
  ) async {
    try {
      // Gọi hàm mới từ _repo
      await _repo.recordInterviewResult(applicationId, result, comments);
      Get.snackbar('Thành công', 'Đã lưu kết quả và gửi email.');
      fetchApplicants(); // Tải lại danh sách
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    }
  }

  void showCreateOfferDialog(int applicationId) {
    final offerContentController = TextEditingController(
      text:
          "Kính gửi [Tên ứng viên],\n\nCông ty [Tên công ty] trân trọng mời bạn vào vị trí [Tên vị trí]...\n\nMức lương: ...\nNgày bắt đầu: ...\n\nTrân trọng.",
    );
    Get.defaultDialog(
      title: "Tạo thư mời nhận việc",
      content: TextField(
        controller: offerContentController,
        decoration: InputDecoration(
          labelText: 'Nội dung thư mời',
          border: OutlineInputBorder(),
        ),
        maxLines: 8,
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          _createOffer(applicationId, offerContentController.text);
        },
        child: Text("Gửi thư mời"),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text("Hủy")),
    );
  }

  Future<void> _createOffer(int applicationId, String content) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}/api/applications/$applicationId/offer',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'offerLetterContent': content}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 201) {
        Get.snackbar('Thành công', data['message']);
        fetchApplicants(); // Tải lại danh sách
      } else {
        Get.snackbar('Thất bại', data['message']);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Lỗi kết nối: $e');
    }
  }

  Future<void> viewCv(String? cvUrl) async {
    if (cvUrl == null || cvUrl.isEmpty) {
      Get.snackbar('Thông báo', 'Ứng viên này chưa cung cấp CV.');
      return;
    }

    final Uri url = Uri.parse(cvUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Lỗi', 'Không thể mở đường dẫn CV. Vui lòng thử lại.');
    }
  }

  Future<void> closeJob() async {
    Get.defaultDialog(
      title: 'Xác nhận đóng tin',
      middleText: 'Bạn có chắc muốn đóng tin tuyển dụng này?',
      confirm: TextButton(
        onPressed: () async {
          Get.back();
          isUpdatingStatus(true); // Bắt đầu loading
          try {
            await _jobRepo.updateJobStatus(jobId, 'closed');
            jobStatus.value = 'closed'; // Cập nhật trạng thái ngay lập tức
            Get.snackbar('Thành công', 'Đã đóng tin tuyển dụng.');
            // Refresh dashboard list silently in background (optional)
            Get.find<RecruiterDashboardController>().fetchMyJobs();
          } catch (e) {
            Get.snackbar('Lỗi', 'Không thể đóng tin: ${e.toString()}');
          } finally {
            isUpdatingStatus(false); // Kết thúc loading
          }
        },
        child: Text('Đóng tin', style: TextStyle(color: Colors.orange)),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text('Hủy')),
    );
  }

  Future<void> openJob() async {
    isUpdatingStatus(true); // Bắt đầu loading
    try {
      await _jobRepo.updateJobStatus(jobId, 'open');
      jobStatus.value = 'open'; // Cập nhật trạng thái
      Get.snackbar('Thành công', 'Đã mở lại tin tuyển dụng.');
      Get.find<RecruiterDashboardController>().fetchMyJobs();
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể mở tin: ${e.toString()}');
    } finally {
      isUpdatingStatus(false); // Kết thúc loading
    }
  }

  Future<void> deleteJob() async {
    Get.defaultDialog(
      title: 'Xác nhận xóa tin',
      middleText: 'Bạn có chắc chắn muốn xóa tin tuyển dụng này vĩnh viễn?',
      confirm: TextButton(
        onPressed: () async {
          Get.back();
          isUpdatingStatus(true); // Bắt đầu loading
          try {
            await _jobRepo.deleteJob(jobId);
            Get.snackbar('Thành công', 'Đã xóa tin tuyển dụng.');
            // Quay về dashboard sau khi xóa
            Get.find<RecruiterDashboardController>().fetchMyJobs();
            Get.back(); // Quay về dashboard
          } catch (e) {
            Get.snackbar('Lỗi', 'Không thể xóa tin: ${e.toString()}');
          } finally {
            isUpdatingStatus(false); // Kết thúc loading
          }
        },
        child: Text('Xóa vĩnh viễn', style: TextStyle(color: Colors.red)),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text('Hủy')),
    );
  }
}
