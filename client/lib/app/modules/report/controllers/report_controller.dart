// lib/app/modules/report/controllers/report_controller.dart

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/constants/api_constants.dart';
import '../../../data/models/statistics_model.dart';

class ReportController extends GetxController {
  var statistics = Rxn<Statistics>(); // Cho phép giá trị null
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/reports/statistics'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        statistics.value = statisticsFromJson(response.body);
      } else {
        Get.snackbar('Lỗi', 'Không thể tải dữ liệu thống kê.');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Lỗi kết nối: $e');
    } finally {
      isLoading(false);
    }
  }
}
