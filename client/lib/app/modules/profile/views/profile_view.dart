// lib/app/modules/profile/views/profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/education_model.dart';
import '../../../data/models/work_experience_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar không cần nút back vì là tab
      appBar: AppBar(
        title: Text('Hồ sơ cá nhân'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.user.value == null) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.user.value == null) {
          return Center(child: Text('Không thể tải dữ liệu người dùng.'));
        }
        final user = controller.user.value!;
        final isCandidate = user.role == 'candidate'; // Kiểm tra vai trò

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchUserProfile();
            if (isCandidate) {
              await controller
                  .fetchCvProfile(); // Tải lại cả CV nếu là ứng viên
            }
          },
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              // --- Phần Thông tin chung ---
              _buildUserInfoSection(context, user),
              SizedBox(height: 24),

              // --- Phần CV Online (Chỉ hiển thị cho Ứng viên) ---
              if (isCandidate) ...[
                _buildCvSection(
                  context,
                  title: 'Kinh nghiệm làm việc',
                  onAdd: () => controller.showExperienceForm(),
                  itemCount: controller.experiences.length,
                  itemBuilder: (context, index) {
                    final exp = controller.experiences[index];
                    return _buildExperienceTile(exp);
                  },
                ),
                SizedBox(height: 24),
                _buildCvSection(
                  context,
                  title: 'Học vấn',
                  onAdd: () => controller.showEducationForm(),
                  itemCount: controller.educations.length,
                  itemBuilder: (context, index) {
                    final edu = controller.educations[index];
                    return _buildEducationTile(edu);
                  },
                ),
                SizedBox(height: 24),
              ],

              // --- Phần Cài đặt ---
              _buildActionsCard(context),
            ],
          ),
        );
      }),
    );
  }

  // Widget hiển thị thông tin cơ bản (Avatar, Tên, Email...)
  Widget _buildUserInfoSection(BuildContext context, dynamic user) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Obx(
                () => CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: controller.user.value?.avatarUrl != null
                      ? NetworkImage(controller.user.value!.avatarUrl!)
                      : null,
                  child: controller.user.value?.avatarUrl == null
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey.shade400,
                        )
                      : null,
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  onPressed: () => controller.pickAndUploadAvatar(),
                  child: Icon(Icons.camera_alt, size: 20),
                  tooltip: 'Đổi ảnh đại diện',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text(
          user.fullName,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        if (user.headline != null && user.headline.isNotEmpty) ...[
          SizedBox(height: 4),
          Text(
            user.headline,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        SizedBox(height: 8),
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        if (user.phoneNumber != null && user.phoneNumber.isNotEmpty) ...[
          SizedBox(height: 4),
          Text(
            user.phoneNumber,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
        if (user.bio != null && user.bio.isNotEmpty) ...[
          SizedBox(height: 16),
          Text(
            user.bio,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  // Widget chung để xây dựng các mục CV Online
  Widget _buildCvSection(
    BuildContext context, {
    required String title,
    required VoidCallback onAdd,
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: onAdd,
              tooltip: 'Thêm mới',
            ),
          ],
        ),
        Divider(thickness: 1),
        if (itemCount == 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Chưa có thông tin. Hãy nhấn (+) để thêm mới.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        else
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: itemBuilder,
            separatorBuilder: (context, index) => SizedBox(height: 8),
          ),
      ],
    );
  }

  // Widget hiển thị một mục Kinh nghiệm
  Widget _buildExperienceTile(WorkExperience exp) {
    final dateFormat = DateFormat('MM/yyyy');
    final period =
        '${dateFormat.format(exp.startDate)} - ${exp.endDate != null ? dateFormat.format(exp.endDate!) : 'Hiện tại'}';
    return Card(
      margin: EdgeInsets.zero, // Bỏ margin của Card con
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          exp.jobTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${exp.companyName}\n$period'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.blue.shade700),
              onPressed: () => controller.showExperienceForm(experience: exp),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
              onPressed: () => controller.deleteExperience(exp.id),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị một mục Học vấn
  Widget _buildEducationTile(Education edu) {
    final dateFormat = DateFormat('MM/yyyy');
    final period =
        '${dateFormat.format(edu.startDate)} - ${edu.endDate != null ? dateFormat.format(edu.endDate!) : 'Hiện tại'}';
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(edu.school, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${edu.degree} - ${edu.fieldOfStudy ?? ''}\n$period'),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.blue.shade700),
              onPressed: () => controller.showEducationForm(education: edu),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
              onPressed: () => controller.deleteEducation(edu.id),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị các nút Cài đặt
  Widget _buildActionsCard(BuildContext context) {
    final isRecruiter = controller.user.value?.role == 'recruiter';
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (isRecruiter) ...[
            ListTile(
              leading: Icon(Icons.business_outlined),
              title: Text('Quản lý công ty'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Get.toNamed(Routes.COMPANY_PROFILE);
              },
            ),
            Divider(height: 1), // Sử dụng Divider không có indent
          ],
          ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Chỉnh sửa thông tin'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => controller.showEditProfileDialog(),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Đổi mật khẩu'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => controller.showChangePasswordDialog(),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text('Đăng xuất', style: TextStyle(color: Colors.redAccent)),
            onTap: () => controller.logout(),
          ),
        ],
      ),
    );
  }
}
