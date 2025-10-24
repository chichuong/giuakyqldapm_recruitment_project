// lib/app/modules/company_profile/controllers/company_profile_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/company_model.dart';
import '../../../data/repositories/company_repository.dart';

class CompanyProfileController extends GetxController {
  final CompanyRepository _companyRepository = CompanyRepository();
  final ImagePicker _picker = ImagePicker();

  var company = Rxn<Company>();
  var isLoading = true.obs;

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController addressController;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    addressController = TextEditingController();
    fetchCompanyProfile();
  }

  Future<void> fetchCompanyProfile() async {
    try {
      isLoading(true);
      final result = await _companyRepository.getMyCompany();
      company.value = result;
      // Điền thông tin vào form nếu có
      if (result != null) {
        nameController.text = result.name;
        descriptionController.text = result.description ?? '';
        addressController.text = result.address ?? '';
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải thông tin công ty.');
    } finally {
      isLoading(false);
    }
  }

  Future<void> saveCompanyProfile() async {
    try {
      isLoading(true);
      await _companyRepository.createOrUpdateCompany(
        name: nameController.text,
        description: descriptionController.text,
        address: addressController.text,
      );
      await fetchCompanyProfile(); // Tải lại để cập nhật UI
      Get.snackbar('Thành công', 'Lưu thông tin công ty thành công.');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> pickAndUploadLogo() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      try {
        isLoading(true);
        await _companyRepository.uploadLogo(File(image.path));
        await fetchCompanyProfile(); // Tải lại để cập nhật logo
        Get.snackbar('Thành công', 'Cập nhật logo thành công.');
      } catch (e) {
        Get.snackbar('Lỗi', e.toString());
      } finally {
        isLoading(false);
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
