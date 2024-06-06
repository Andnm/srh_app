import 'dart:async';
import 'package:cus_dbs_app/common/apis/driver_api.dart';
import 'package:cus_dbs_app/common/entities/driver.dart';
import 'package:cus_dbs_app/common/entities/user_general.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'index.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DriverProfileController extends GetxController {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();
  Rx<DriverItem> driver = DriverItem().obs;

  final state = DriverProfileState();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchDriverProfileFromApi() async {
    try {
      User response = await DriverAPI.getDriverProfile();
      state.dataDriver.value = response;
      addressController.text = state.dataDriver.value.address ?? "";
      nameController.text = state.dataDriver.value.name ?? "";
      phoneNumberController.text = state.dataDriver.value.phoneNumber ?? "";
      dobController.text = state.dataDriver.value.dob ?? "";
      state.isPublicGender.value = state.dataDriver.value.isPublicGender!;
    } catch (e) {
      print('Error fetching driver profile: $e');
      // Get.snackbar('Error fetching driver profile:', '$e');
    }
  }

  Future<void> handleToggleChangePublicGender() async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    try {
      await DriverAPI.changePublicGender(
          isPublicGender: state.isPublicGender.value);

      String msgNoti = state.isPublicGender.value
          ? 'Giới tính của bạn đã được công khai'
          : 'Giới tính của bạn đã được ẩn đi';

      Get.snackbar(
        'Thành công',
        msgNoti,
        backgroundColor: Colors.white,
        colorText: Colors.green.shade700,
        borderWidth: 1,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      );
    } catch (e) {
      print('Error to change public gender: $e');
      Get.snackbar(
        'Lỗi khi thay đổi trạng thái công khai giới tính:',
        ' $e',
        backgroundColor: Colors.white,
        colorText: Colors.red.shade700,
        borderWidth: 1,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
