// lib/app/modules/admin_user_list/controllers/admin_user_list_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/admin_user_list_model.dart';
import '../../../data/repositories/admin_repository.dart';

class AdminUserListController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();

  var userList = <AdminUserListItem>[].obs;
  var isLoading = true.obs;

  final ScrollController scrollController = ScrollController();
  var isLoadingMore = false.obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers(isInitial: true);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          hasMoreData.value &&
          !isLoadingMore.value) {
        fetchUsers();
      }
    });
  }

  Future<void> fetchUsers({bool isInitial = false}) async {
    if (isInitial) {
      isLoading.value = true;
      currentPage.value = 1;
      hasMoreData.value = true;
      userList.clear();
    } else {
      isLoadingMore.value = true;
    }

    try {
      final result = await _adminRepository.getAllUsers(
        page: currentPage.value,
      );
      if (result.users.isEmpty) {
        hasMoreData.value = false;
      } else {
        userList.addAll(result.users);
        currentPage.value++;
      }
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
