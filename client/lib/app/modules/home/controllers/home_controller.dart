// lib/app/modules/home/controllers/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/job_model.dart';
import '../../../data/repositories/job_repository.dart';
import '../../../data/services/socket_service.dart';
import '../../../routes/app_pages.dart';
import '../../my_applications/controllers/my_applications_controller.dart';
import '../../saved_jobs/controllers/saved_jobs_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class HomeController extends GetxController {
  final JobRepository _jobRepository = JobRepository();

  var jobList = <Job>[].obs;
  var isLoading = true.obs;
  final TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;

  final ScrollController scrollController = ScrollController();
  var isLoadingMore = false.obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;

  var savedJobIds = <int>{}.obs;

  // BIẾN QUẢN LÝ TAB
  var tabIndex = 0.obs;
  void changeTabIndex(int index) {
    // Tải lại dữ liệu tương ứng khi người dùng chuyển tab
    switch (index) {
      case 1:
        Get.find<SavedJobsController>().fetchSavedJobs();
        break;
      case 2:
        Get.find<MyApplicationsController>().fetchApplications();
        break;
      case 3:
        Get.find<ProfileController>().fetchUserProfile();
        break;
    }
    tabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Đảm bảo các controller con được "đánh thức"
    Get.find<SavedJobsController>();
    Get.find<MyApplicationsController>();
    Get.find<ProfileController>();

    fetchInitialData();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          hasMoreData.value &&
          !isLoadingMore.value) {
        fetchJobs();
      }
    });

    debounce(
      searchQuery,
      (_) => fetchJobs(isInitial: true),
      time: const Duration(milliseconds: 500),
    );
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  Future<void> fetchInitialData() async {
    await fetchJobs(isInitial: true);
    await fetchSavedJobIds();
  }

  Future<void> fetchSavedJobIds() async {
    try {
      final savedJobs = await _jobRepository.getSavedJobs();
      savedJobIds.value = savedJobs.map((job) => job.id).toSet();
    } catch (e) {
      // Bỏ qua lỗi ở đây
    }
  }

  Future<void> toggleSaveJob(Job job) async {
    final isCurrentlySaved = savedJobIds.contains(job.id);
    try {
      if (isCurrentlySaved) {
        await _jobRepository.unsaveJob(job.id);
        savedJobIds.remove(job.id);
        Get.snackbar('Thông báo', 'Đã bỏ lưu việc làm.');
      } else {
        await _jobRepository.saveJob(job.id);
        savedJobIds.add(job.id);
        Get.snackbar('Thông báo', 'Đã lưu việc làm thành công.');
      }
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    }
  }

  Future<void> fetchJobs({bool isInitial = false}) async {
    if (isInitial) {
      isLoading.value = true;
      currentPage.value = 1;
      hasMoreData.value = true;
      jobList.clear();
    } else {
      isLoadingMore.value = true;
    }

    try {
      final result = await _jobRepository.fetchAllJobs(
        page: currentPage.value,
        search: searchQuery.value,
      );
      if (result.jobs.isEmpty) {
        hasMoreData.value = false;
      } else {
        jobList.addAll(result.jobs);
        currentPage.value++;
      }
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshJobs() async {
    await fetchJobs(isInitial: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> logout() async {
    Get.find<SocketService>().disconnect();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.LOGIN);
  }
}
