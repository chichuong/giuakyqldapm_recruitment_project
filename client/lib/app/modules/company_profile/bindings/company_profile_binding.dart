// lib/app/modules/company_profile/bindings/company_profile_binding.dart

import 'package:get/get.dart';
import '../../../data/repositories/company_repository.dart';
import '../controllers/company_profile_controller.dart';

class CompanyProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyRepository>(() => CompanyRepository());
    Get.lazyPut<CompanyProfileController>(() => CompanyProfileController());
  }
}
