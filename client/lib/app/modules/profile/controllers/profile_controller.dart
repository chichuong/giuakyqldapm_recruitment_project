// lib/app/modules/profile/controllers/profile_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/education_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/work_experience_model.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../home/controllers/home_controller.dart';
import '../../recruiter_dashboard/controllers/recruiter_dashboard_controller.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  final ProfileRepository _profileRepository =
      ProfileRepository(); // Repo for CV Online
  final ImagePicker _picker = ImagePicker();

  var user = Rxn<User>();
  var experiences = <WorkExperience>[].obs; // List for work experience
  var educations = <Education>[].obs; // List for education
  var isLoading = true.obs;
  var isCvLoading = false.obs; // Separate loading state for CV parts

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  // Fetches both basic user info and CV Online data if applicable
  Future<void> fetchInitialData() async {
    isLoading(true); // Start overall loading
    await fetchUserProfile();
    // Only fetch CV data if the user is a candidate
    if (user.value?.role == 'candidate') {
      await fetchCvProfile();
    }
    isLoading(false); // End overall loading
  }

  // Fetches basic user profile information
  Future<void> fetchUserProfile() async {
    try {
      // Don't set isLoading(true) here if called within fetchInitialData
      final result = await _userRepository.getMe();
      user.value = result;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải thông tin cá nhân: ${e.toString()}');
    }
    // isLoading(false) is handled by fetchInitialData
  }

  // Fetches CV Online data (experience, education)
  Future<void> fetchCvProfile() async {
    isCvLoading(true); // Use separate loading state for CV parts
    try {
      final profileData = await _profileRepository.getProfile();
      experiences.value = profileData['experiences'];
      educations.value = profileData['educations'];
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải hồ sơ CV: ${e.toString()}');
    } finally {
      isCvLoading(false);
    }
  }

  // --- Function 1: Update Avatar ---
  Future<void> pickAndUploadAvatar() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      try {
        isLoading(true); // Show loading indicator
        await _userRepository.uploadAvatar(File(image.path));
        await fetchUserProfile(); // Reload profile to show new avatar
        Get.snackbar('Thành công', 'Cập nhật ảnh đại diện thành công.');
      } catch (e) {
        Get.snackbar('Lỗi', e.toString());
      } finally {
        isLoading(false);
      }
    }
  }

  // --- Function 2: Edit Basic Info ---
  void showEditProfileDialog() {
    final nameController = TextEditingController(text: user.value?.fullName);
    final phoneController = TextEditingController(
      text: user.value?.phoneNumber,
    );
    final headlineController = TextEditingController(
      text: user.value?.headline,
    );
    final bioController = TextEditingController(text: user.value?.bio);
    final linkedinController = TextEditingController(
      text: user.value?.linkedinUrl,
    );
    final githubController = TextEditingController(text: user.value?.githubUrl);

    Get.dialog(
      AlertDialog(
        title: Text("Chỉnh sửa thông tin"),
        content: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Họ và tên'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Số điện thoại'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: headlineController,
                  decoration: InputDecoration(labelText: 'Chức danh'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: bioController,
                  decoration: InputDecoration(labelText: 'Giới thiệu ngắn'),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: linkedinController,
                  decoration: InputDecoration(labelText: 'Link LinkedIn'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: githubController,
                  decoration: InputDecoration(labelText: 'Link Github'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("Hủy")),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close dialog first
              try {
                isLoading(true);
                await _userRepository.updateProfile(
                  fullName: nameController.text,
                  phoneNumber: phoneController.text,
                  headline: headlineController.text,
                  bio: bioController.text,
                  linkedinUrl: linkedinController.text,
                  githubUrl: githubController.text,
                );
                await fetchUserProfile(); // Reload profile data
                Get.snackbar('Thành công', 'Cập nhật thông tin thành công.');
              } catch (e) {
                Get.snackbar('Lỗi', e.toString());
              } finally {
                isLoading(false);
              }
            },
            child: Text('Lưu'),
          ),
        ],
      ),
    );
  }

  // --- Function 3: Change Password ---
  void showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.defaultDialog(
      // Using defaultDialog here for simplicity
      title: "Đổi mật khẩu",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: oldPasswordController,
            decoration: InputDecoration(labelText: 'Mật khẩu cũ'),
            obscureText: true,
          ),
          SizedBox(height: 16),
          TextField(
            controller: newPasswordController,
            decoration: InputDecoration(labelText: 'Mật khẩu mới'),
            obscureText: true,
          ),
          SizedBox(height: 16),
          TextField(
            controller: confirmPasswordController,
            decoration: InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
            obscureText: true,
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          if (newPasswordController.text != confirmPasswordController.text) {
            Get.snackbar('Lỗi', 'Mật khẩu mới không khớp.');
            return;
          }
          if (newPasswordController.text.isEmpty ||
              oldPasswordController.text.isEmpty) {
            Get.snackbar('Lỗi', 'Vui lòng điền đầy đủ thông tin.');
            return;
          }
          Get.back(); // Close dialog first
          try {
            isLoading(true);
            await _userRepository.changePassword(
              oldPassword: oldPasswordController.text,
              newPassword: newPasswordController.text,
            );
            Get.snackbar('Thành công', 'Đổi mật khẩu thành công.');
          } catch (e) {
            Get.snackbar('Lỗi', e.toString());
          } finally {
            isLoading(false);
          }
        },
        child: Text('Xác nhận'),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text('Hủy')),
    );
  }

  // --- Logic for Work Experience (CV Online part) ---
  void showExperienceForm({WorkExperience? experience}) {
    final isEditing = experience != null;
    final titleController = TextEditingController(text: experience?.jobTitle);
    final companyController = TextEditingController(
      text: experience?.companyName,
    );
    final descController = TextEditingController(text: experience?.description);

    Rx<DateTime> startDate = (experience?.startDate ?? DateTime.now()).obs;
    Rx<DateTime?> endDate = (experience?.endDate).obs;
    RxBool isCurrent = (experience?.endDate == null && experience != null)
        .obs; // Correct initial state

    Get.dialog(
      AlertDialog(
        title: Text(isEditing ? 'Sửa kinh nghiệm' : 'Thêm kinh nghiệm'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Chức danh'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: companyController,
                decoration: InputDecoration(labelText: 'Tên công ty'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Mô tả công việc'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: Get.context!,
                    initialDate: startDate.value,
                    firstDate: DateTime(1980),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) startDate.value = picked;
                },
                child: Obx(
                  () => Text(
                    'Ngày bắt đầu: ${DateFormat('dd/MM/yyyy').format(startDate.value)}',
                  ),
                ),
              ),
              SizedBox(height: 8),
              Obx(
                () => CheckboxListTile(
                  title: Text("Tôi vẫn đang làm ở đây"),
                  value: isCurrent.value,
                  onChanged: (bool? value) {
                    isCurrent.value = value ?? false;
                    if (isCurrent.value) endDate.value = null;
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Obx(
                () => isCurrent.value
                    ? SizedBox.shrink()
                    : ElevatedButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: Get.context!,
                            initialDate: endDate.value ?? DateTime.now(),
                            firstDate: DateTime(1980),
                            lastDate: DateTime.now(),
                          );
                          endDate.value = picked;
                        },
                        child: Text(
                          endDate.value == null
                              ? 'Chọn ngày kết thúc'
                              : 'Ngày kết thúc: ${DateFormat('dd/MM/yyyy').format(endDate.value!)}',
                        ),
                      ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              // Basic validation
              if (titleController.text.isEmpty ||
                  companyController.text.isEmpty) {
                Get.snackbar('Lỗi', 'Vui lòng điền Chức danh và Tên công ty.');
                return;
              }
              Get.back();
              final data = {
                'job_title': titleController.text,
                'company_name': companyController.text,
                'start_date': startDate.value.toIso8601String().substring(
                  0,
                  10,
                ),
                'end_date': isCurrent.value
                    ? null
                    : endDate.value?.toIso8601String().substring(0, 10),
                'description': descController.text,
              };
              try {
                isLoading(true);
                if (isEditing) {
                  await _profileRepository.updateExperience(
                    experience!.id,
                    data,
                  );
                } else {
                  await _profileRepository.addExperience(data);
                }
                await fetchCvProfile(); // Reload CV data only
              } catch (e) {
                Get.snackbar('Lỗi', e.toString());
              } finally {
                isLoading(false);
              }
            },
            child: Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void deleteExperience(int id) {
    Get.defaultDialog(
      title: 'Xác nhận xóa',
      middleText: 'Bạn có chắc chắn muốn xóa kinh nghiệm này không?',
      confirm: TextButton(
        onPressed: () async {
          Get.back();
          try {
            isLoading(true);
            await _profileRepository.deleteExperience(id);
            await fetchCvProfile();
            Get.snackbar('Thành công', 'Đã xóa kinh nghiệm.');
          } catch (e) {
            Get.snackbar('Lỗi', e.toString());
          } finally {
            isLoading(false);
          }
        },
        child: Text('Xóa', style: TextStyle(color: Colors.red)),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text('Hủy')),
    );
  }

  // --- Logic for Education (CV Online part) ---
  void showEducationForm({Education? education}) {
    final isEditing = education != null;
    final schoolController = TextEditingController(text: education?.school);
    final degreeController = TextEditingController(text: education?.degree);
    final fieldController = TextEditingController(
      text: education?.fieldOfStudy,
    );

    Rx<DateTime> startDate = (education?.startDate ?? DateTime.now()).obs;
    Rx<DateTime?> endDate = (education?.endDate).obs;
    RxBool isCurrent = (education?.endDate == null && education != null)
        .obs; // Correct initial state

    Get.dialog(
      AlertDialog(
        title: Text(isEditing ? 'Sửa học vấn' : 'Thêm học vấn'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: schoolController,
                decoration: InputDecoration(labelText: 'Tên trường/Tổ chức'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: degreeController,
                decoration: InputDecoration(labelText: 'Bằng cấp/Chứng chỉ'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: fieldController,
                decoration: InputDecoration(labelText: 'Chuyên ngành'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: Get.context!,
                    initialDate: startDate.value,
                    firstDate: DateTime(1980),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) startDate.value = picked;
                },
                child: Obx(
                  () => Text(
                    'Ngày bắt đầu: ${DateFormat('dd/MM/yyyy').format(startDate.value)}',
                  ),
                ),
              ),
              SizedBox(height: 8),
              Obx(
                () => CheckboxListTile(
                  title: Text("Tôi vẫn đang học ở đây"),
                  value: isCurrent.value,
                  onChanged: (bool? value) {
                    isCurrent.value = value ?? false;
                    if (isCurrent.value) endDate.value = null;
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Obx(
                () => isCurrent.value
                    ? SizedBox.shrink()
                    : ElevatedButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: Get.context!,
                            initialDate: endDate.value ?? DateTime.now(),
                            firstDate: DateTime(1980),
                            lastDate: DateTime.now(),
                          );
                          endDate.value = picked;
                        },
                        child: Text(
                          endDate.value == null
                              ? 'Chọn ngày kết thúc'
                              : 'Ngày kết thúc: ${DateFormat('dd/MM/yyyy').format(endDate.value!)}',
                        ),
                      ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              // Basic validation
              if (schoolController.text.isEmpty ||
                  degreeController.text.isEmpty) {
                Get.snackbar('Lỗi', 'Vui lòng điền Tên trường và Bằng cấp.');
                return;
              }
              Get.back();
              final data = {
                'school': schoolController.text,
                'degree': degreeController.text,
                'field_of_study': fieldController.text,
                'start_date': startDate.value.toIso8601String().substring(
                  0,
                  10,
                ),
                'end_date': isCurrent.value
                    ? null
                    : endDate.value?.toIso8601String().substring(0, 10),
              };
              try {
                isLoading(true);
                if (isEditing) {
                  await _profileRepository.updateEducation(education!.id, data);
                } else {
                  await _profileRepository.addEducation(data);
                }
                await fetchCvProfile(); // Reload CV data only
              } catch (e) {
                Get.snackbar('Lỗi', e.toString());
              } finally {
                isLoading(false);
              }
            },
            child: Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void deleteEducation(int id) {
    Get.defaultDialog(
      title: 'Xác nhận xóa',
      middleText: 'Bạn có chắc chắn muốn xóa mục học vấn này không?',
      confirm: TextButton(
        onPressed: () async {
          Get.back();
          try {
            isLoading(true);
            await _profileRepository.deleteEducation(id);
            await fetchCvProfile();
            Get.snackbar('Thành công', 'Đã xóa mục học vấn.');
          } catch (e) {
            Get.snackbar('Lỗi', e.toString());
          } finally {
            isLoading(false);
          }
        },
        child: Text('Xóa', style: TextStyle(color: Colors.red)),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text('Hủy')),
    );
  }

  // --- Function 4: Logout ---
  void logout() {
    // Determine the current context (Home or RecruiterDashboard) and call logout
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().logout();
    } else if (Get.isRegistered<RecruiterDashboardController>()) {
      Get.find<RecruiterDashboardController>().logout();
    } else {
      // Fallback in case neither is found (e.g., direct navigation to profile)
      // Basic logout without socket disconnect
      SharedPreferences.getInstance().then((prefs) {
        prefs.clear();
        Get.offAllNamed(Routes.LOGIN);
      });
    }
  }
}
