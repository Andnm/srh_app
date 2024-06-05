import 'dart:async';

import 'package:cus_dbs_app/common/apis/customer_api.dart';
import 'package:cus_dbs_app/common/entities/customer.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerRegisterController extends GetxController {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final state = CustomerRegisterState();

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future<void> handleCustomerRegister() async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      late CustomerRegister registeredCustomer;
      state.email.value = emailController.text.trim();
      state.name.value = nameController.text.trim();
      state.password.value = passwordController.text.trim();
      state.confirmPassword.value = confirmPasswordController.text.trim();

      if (state.email.value == '' ||
          state.name.value == '' ||
          state.password.value == '' ||
          state.confirmPassword.value == '') {
        Get.snackbar(
          'Cảnh báo',
          'Vui lòng nhập đầy đủ thông tin',
          backgroundColor: Colors.white,
          colorText: Colors.red,
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
        EasyLoading.dismiss();
        return;
      }

      saveFullName(nameController.text.trim());

      registeredCustomer = CustomerRegister(
          email: state.email.value,
          userName: state.email.value,
          password: state.confirmPassword.value);
      if (state.password.value != state.confirmPassword.value) {
        Get.snackbar('Error', 'Passwords do not match');
        EasyLoading.dismiss();

        return;
      }
      // CALL API để check xem email đó exist hay không
      // nếu có exist thì  báo là tài khoản đã tồn tại
      // còn nếu không exist thì chuyển đến màn hình create_profile_customer.dart

      final dataEmail = {"email": state.email.value};
      state.existEmail.value =
          await CustomerAPI.checkExistUserWithEmail(email: dataEmail);

      if (state.existEmail.value) {
        String emailValue = emailController.text;
        Get.snackbar(
          'Cảnh báo',
          'Tài khoản với email $emailValue đã tồn tại',
          backgroundColor: Colors.white,
          colorText: Colors.red,
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
        EasyLoading.dismiss();
      } else {
        await asyncPostAllDataCustomerByRegister(registeredCustomer);
        Get.offAllNamed(AppRoutes.createInfoAfterLoginWithEmailPassword);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Try again');
      EasyLoading.dismiss();
    }
  }

  Future<void> asyncPostAllDataCustomerByRegister(
      CustomerRegister registeredCustomer) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      String token = await CustomerAPI.register(params: registeredCustomer);
      if (token != null) {
        await UserStore.to.setToken(token);
        EasyLoading.dismiss();

        await loginCustomerAfterRegister();
      }
    } on DioException catch (e) {
      // Get.snackbar("Error", e.response.toString());
      EasyLoading.dismiss();
    }
  }

  Future<void> loginCustomerAfterRegister() async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      late CustomerItem? internalLogin;
      state.email.value = emailController.text;
      state.password.value = passwordController.text;

      internalLogin = CustomerItem(
          email: state.email.value, password: state.password.value);
      if (internalLogin != null) {
        await asyncPostAllDataCustomerByInternalLoginAfterRegister(
            internalLogin);
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print("...error login with $e");
      }
    }
  }

  Future<void> asyncPostAllDataCustomerByInternalLoginAfterRegister(
      CustomerItem login) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      var result = await CustomerAPI.loginWithEmailAndPassword(params: login);
      if (result.access_token != null) {
        await UserStore.to.saveCustomerProfile(CustomerItem(
            access_token: result.access_token,
            tokenType: result.tokenType,
            userID: result.userID,
            expiresIn: result.expiresIn,
            userName: result.userName,
            email: result.email,
            phoneNumber: result.phoneNumber,
            name: result.name,
            avatar: result.avatar,
            dateLogin: DateTime.now().toString()));
        EasyLoading.dismiss();
      }
    } on DioException catch (e) {
      Get.snackbar("Error", e.response.toString());
      EasyLoading.dismiss();
    }
  }

// xử lý vấn đề liên quan đến việc cập nhập tài khoản sau khi register
  Future<void> saveFullName(String fullName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', fullName);
  }

  Future<String?> getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fullName');
  }

  Future<void> clearFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('fullName');
  }

  @override
  void onClose() {
    super.onClose();
  }
}
