import 'dart:async';

import 'package:cus_dbs_app/common/apis/driver_api.dart';
import 'package:cus_dbs_app/common/entities/driver.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'index.dart';

class DriverRegisterController extends GetxController {
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final state = DriverRegisterState();
  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future<void> handleDriverRegister() async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      late DriverItem registeredDriver;
      state.email.value = emailController.text.trim();
      state.userName.value = userNameController.text.trim();
      state.password.value = passwordController.text.trim();
      state.confirmPassword.value = confirmPasswordController.text.trim();
      registeredDriver = DriverItem(
          email: state.email.value,
          userName: state.userName.value,
          password: state.password.value);
      print(registeredDriver);
      if (state.password.value != state.confirmPassword.value) {
        Get.snackbar('Error', 'Passwords do not match');
        EasyLoading.dismiss();

        return;
      }
      if (registeredDriver != null) {
        await asyncPostAllDataDriverByRegister(registeredDriver);
      }

      // var result = await DriverAPI.register(params: params);
      // EasyLoading.dismiss();

      // if (result.access_token != null) {
      //   Get.offAllNamed(AppRoutes.driverSignIn);
      // } else {
      //   Get.snackbar('Error', 'Registration failed');
      // }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Try again');
      EasyLoading.dismiss();
    }
  }

  Future<void> asyncPostAllDataDriverByRegister(
      DriverItem registeredDriver) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      String token = await DriverAPI.register(params: registeredDriver);

      await UserStore.to.setToken(token);
      EasyLoading.dismiss();
      Get.toNamed(AppRoutes.driverSignIn);
    } on DioException catch (e) {
      Get.snackbar("Error", e.response.toString());
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
