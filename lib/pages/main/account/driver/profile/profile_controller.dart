import 'dart:async';
import 'package:cus_dbs_app/common/apis/driver_api.dart';
import 'package:cus_dbs_app/common/entities/driver.dart';
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
    fetchDriverProfileFromApi();
    update();
  }

  Future<Map<String, dynamic>?> _asyncGetDriverProfile() async {
    try {
      Map<String, dynamic> response = await DriverAPI.getDriverProfile();
      return response;
    } catch (e) {
      print('Error fetching driver profile: $e');
      return null;
    }
  }

  Future<void> fetchDriverProfileFromApi() async {
    try {
      Map<String, dynamic>? response = await _asyncGetDriverProfile();
      if (response != null) {
        String name = response['name'];
        String address = response['address'];
        String phoneNumber = response['phoneNumber'];
        String gender = response['gender'];
        String dob = response['dob'];
        String email = response['email'];

        state.name.value = name;
        state.address.value = address;
        state.phoneNumber.value = phoneNumber;
        state.gender.value = gender;
        state.dob.value = dob;
        state.email.value = dob;
        state.isPublicGender.value = response['isPublicGender'];

        nameController.text = name;
        addressController.text = address;
        phoneNumberController.text = phoneNumber;
        genderController.text = gender;
        dobController.text = dob;

        update();
      } else {
        // Get.snackbar(
        //     'Error fetching driver profile:', 'Unable to retrieve data');
      }
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
