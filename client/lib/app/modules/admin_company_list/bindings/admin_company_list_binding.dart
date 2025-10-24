import 'package:get/get.dart';
import '../controllers/admin_company_list_controller.dart';

class AdminCompanyListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCompanyListController>(() => AdminCompanyListController());
  }
}
