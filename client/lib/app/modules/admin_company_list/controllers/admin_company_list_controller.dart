import 'package:get/get.dart';
import '../../../data/models/company_model.dart';
import '../../../data/repositories/admin_repository.dart';

class AdminCompanyListController extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();
  var companyList = <Company>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    try {
      isLoading(true);
      final result = await _adminRepository.getAllCompanies();
      companyList.value = result;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
