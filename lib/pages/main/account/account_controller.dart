import 'dart:async';
import 'package:cus_dbs_app/common/apis/customer_api.dart';
import 'package:cus_dbs_app/common/apis/driver_api.dart';
import 'package:cus_dbs_app/common/entities/driver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'index.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AccountController extends GetxController {
  final state = AccountState();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchCustomerProfileFromApi() async {
    try {
      Map<String, dynamic>? response = await CustomerAPI.getCustomerProfile();
      state.updatedAvatar.value = response['avatar'] ?? '';
      state.name.value = response['name'] ?? '';
      state.email.value = response['email'] ?? '';
    } catch (e) {
      print('Error fetching avatar profile: $e');
      // Get.snackbar('Error fetching avatar profile:', '$e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
