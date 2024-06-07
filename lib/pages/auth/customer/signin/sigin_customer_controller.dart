import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cus_dbs_app/common/apis/customer_api.dart';
import 'package:cus_dbs_app/common/entities/customer.dart';
import 'package:cus_dbs_app/common/methods/common_methods.dart';
import 'package:cus_dbs_app/pages/auth/customer/register/index.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../utils/connectivity.dart';
import 'index.dart';

class CustomerSignInController extends GetxController {
  final myInputPhoneController = TextEditingController();
  final myInputEmailController = TextEditingController();
  final myInputPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  CustomerRegisterController get customerRegisterController =>
      Get.find<CustomerRegisterController>();

  // để phone đầu để mà auto qua trang login bằng số điện thoại trước.
  Rx<String> selectedLoginMethod = 'phone'.obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final state = CustomerSignInState();
  DateTime? _selectedDate;

  User? user;

  @override
  void onInit() async {
    super.onInit();
    await InternetChecker.startListening();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  bool isValidPhoneNumberWhenLogin() {
    final phoneNumber = myInputPhoneController.text;
    String? errorMessage;

    if (phoneNumber == null || phoneNumber.isEmpty) {
      errorMessage = 'Vui lòng nhập số điện thoại!';
    } else if (phoneNumber.startsWith('0') && phoneNumber.length != 10) {
      errorMessage = 'Số điện thoại không hợp lệ!';
    } else if (phoneNumber.startsWith('84') && phoneNumber.length != 11) {
      errorMessage = 'Số điện thoại không hợp lệ!';
    } else if (!phoneNumber.startsWith('0') &&
        !phoneNumber.startsWith('84') &&
        phoneNumber.length != 9) {
      errorMessage = 'Số điện thoại không hợp lệ!';
    }

    if (errorMessage != null) {
      Get.snackbar(
        "Cảnh báo",
        errorMessage,
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
      return false;
    }

    return true;
  }

  Future<void> handleCustomerSignIn(String type) async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    try {
// chống cháy OTP
      // final idToken =
      //     "eyJhbGciOiJSUzI1NiIsImtpZCI6ImYyOThjZDA3NTlkOGNmN2JjZTZhZWNhODExNmU4ZjYzMDlhNDQwMjAiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZGJzLWFwcC03MDM1MSIsImF1ZCI6ImRicy1hcHAtNzAzNTEiLCJhdXRoX3RpbWUiOjE3MTI5MjE1MzEsInVzZXJfaWQiOiJaWVhkM2pkbkRPWkJEOUQ3QXVaZ0c2Z3NTZnUyIiwic3ViIjoiWllYZDNqZG5ET1pCRDlEN0F1WmdHNmdzU2Z1MiIsImlhdCI6MTcxMjkyMTUzMSwiZXhwIjoxNzEyOTI1MTMxLCJwaG9uZV9udW1iZXIiOiIrODQ4MzgzMjM0MDMiLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7InBob25lIjpbIis4NDgzODMyMzQwMyJdfSwic2lnbl9pbl9wcm92aWRlciI6InBob25lIn19.AYhGsOUrN6dxCzFtHVlm2-2KrriMeECbAnaKCQE5qRMqp-sLE0_g2X8KGOtDufcay4fq8YKGTyJ28q1vG3ll5Jqq3Ogc43ykNQwezsHCcV94HtOXdqkyh3MWq56wHVD4CN_REZM98Q9YfuUvU-4o3h2bdMhWscRrCwvvCOL20Jy0J_33hw83dtKiS6IpL3k3efXGvdLvYVLNgkVVwjUkHo7Vk0imAx-SjTMNuk9-lO8pWjGlAYyXPVRHjd-2xIa6QpkubDl7n1OZwMw-BoGwsVGwO_tHac3i-CehqGTid13bzkxtLRxhvb0HZ77NdjkT23tAylbpQfxfUXyZbrdoLA";
      // String? providerId = "phone";

      // var externalLogin =
      //     CustomerExternalLogin(idToken: idToken, provider: providerId);
      // final dataPhoneNumber = {"phoneNumber": "838323403"};

      // state.existPhoneNumber.value =
      //     await CustomerAPI.checkExistUserWithPhoneNumber(
      //         phoneNumber: dataPhoneNumber);

      // if (state.existPhoneNumber.value == true) {
      //   await asyncPostAllDataCustomer(externalLogin);
      //   Get.offAllNamed(AppRoutes.main, parameters: {"tabSelected": "0"});
      // } else {
      //   await asyncPostAllDataCustomer(externalLogin);
      //   Get.toNamed(AppRoutes.createInfoAfterLoginWithPhoneNumber);
      // }

      //TẠM THỜI ẨN ĐI

      CustomerExternalLogin? externalLogin;

      switch (type) {
        case "phoneNumber":
          state.phoneNumber.value = myInputPhoneController.text;

          await auth.verifyPhoneNumber(
            phoneNumber: "+84${myInputPhoneController.text}",
            verificationCompleted: (credential) async {
              // final UserCredential userCredential =
              //     await auth.UsersignInWithCredential(credential);
            },
            codeSent: (verificationID, forceResendingToken) {
              state.verificationId.value = verificationID;
              startResendTimer();
              Get.toNamed(AppRoutes.otpConfirm);
            },
            codeAutoRetrievalTimeout: (verificationID) {
              state.verificationId.value = verificationID;
            },
            verificationFailed: (e) {
              startResendTimer();
              if (e.code == 'invalid-phone-number') {
                Get.snackbar('Error', 'The provided phone number is not valid');
              } else {
                print('verification failed $e');
                Get.snackbar('Error', 'Something went wrong. Try again');
              }
            },
          );
          break;
        case "google":
          GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
          final UserCredential userCredential =
              await auth.signInWithProvider(googleAuthProvider);
          final User user = userCredential.user!;
          print("user: $user");

          final idToken = await user.getIdToken();
          String? providerId = userCredential.additionalUserInfo!.providerId;
          externalLogin =
              CustomerExternalLogin(idToken: idToken, provider: providerId);

          log('idToken google $idToken');

          await asyncPostAllDataCustomer(externalLogin);
          final phoneNumber = UserStore.to.customerProfile.phoneNumber;

          if (phoneNumber == '' || phoneNumber == null) {
            Get.toNamed(AppRoutes.createInfoAfterLoginWithEmailPassword);
          } else {
            CommonMethods.checkRedirectRole();
          }

          break;
        case "facebook":
          if (kDebugMode) {
            print("... you are logging in with facebook");
          }
        case "userNameAndPassword":
          CustomerItem? internalLogin;
          state.email.value = myInputEmailController.text;
          state.password.value = myInputPasswordController.text;

          internalLogin = CustomerItem(
              email: state.email.value, password: state.password.value);
          print('INTERAL LOGIN: $internalLogin');

          await asyncPostAllDataCustomerByInternalLogin(internalLogin);
          break;
        default:
          if (kDebugMode) {
            print("...login type not sure...");
          }
          break;
      }
      if (externalLogin != null) {
        await asyncPostAllDataCustomer(externalLogin);
      }
    } catch (e) {
      if (kDebugMode) {
        print("...error login with $e");
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      var credential = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: state.verificationId.value, smsCode: otp));
      final User user = credential.user!;
      final idToken = await user.getIdToken();
      print('id token: $idToken');
      String? providerId = credential.additionalUserInfo!.providerId;
      if (Platform.isAndroid) {
        providerId = "phone";
      }
      var externalLogin =
          CustomerExternalLogin(idToken: idToken, provider: providerId);

      var phoneNumber = "+84${myInputPhoneController.text}";
      print('Phone number to check: $phoneNumber');
      final dataPhoneNumber = {"phoneNumber": phoneNumber};

      state.existPhoneNumber.value =
          await CustomerAPI.checkExistUserWithPhoneNumber(
              phoneNumber: dataPhoneNumber);

      if (state.existPhoneNumber.value == true) {
        await asyncPostAllDataCustomer(externalLogin);
        CommonMethods.checkRedirectRole(parameters: {"tabSelected": "0"});
      } else {
        await asyncPostAllDataCustomer(externalLogin);
        Get.toNamed(AppRoutes.createInfoAfterLoginWithPhoneNumber);
      }

      EasyLoading.dismiss();
    } catch (e) {
      print('error when check exist $e');
      // Get.snackbar('Error', 'Something went wrong. Try again');
      EasyLoading.dismiss();
    }
  }

  Future<void> resendOtp() async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      await auth.verifyPhoneNumber(
        phoneNumber: "+84${state.phoneNumber.value}",
        verificationCompleted: (credential) async {},
        codeSent: (verificationID, forceResendingToken) {
          state.verificationId.value = verificationID;
        },
        codeAutoRetrievalTimeout: (verificationID) {
          state.verificationId.value = verificationID;
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            Get.snackbar('Error', 'The provided phone number is not valid');
          } else {
            Get.snackbar('Error', 'Something went wrong. Try again');
          }
        },
      );
      EasyLoading.dismiss();
      startResendTimer();
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Try again');
      EasyLoading.dismiss();
    }
  }

  Future<void> asyncPostAllDataCustomerByInternalLogin(
      CustomerItem login) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      var result = await CustomerAPI.loginWithEmailAndPassword(params: login);
      print('RESULT ${result.toString()}');

      if (result.access_token != null) {
        await UserStore.to.saveCustomerProfile(CustomerItem(
            access_token: result.access_token,
            tokenType: result.tokenType,
            userID: result.userID,
            expiresIn: result.expiresIn,
            userName: result.userName,
            email: result.email,
            password: result.password,
            phoneNumber: result.phoneNumber,
            name: result.name,
            avatar: result.avatar,
            roles: result.roles,
            priority: result.priority,
            dateLogin: DateTime.now().toString()));
        EasyLoading.dismiss();
        //   Get.offAllNamed(AppRoutes.main);ß
        CommonMethods.checkRedirectRole();
      }
    } on DioException catch (e) {
      Get.snackbar("Error", e.response.toString());
      EasyLoading.dismiss();
    }
  }

  Future<void> asyncPostAllDataCustomer(
      CustomerExternalLogin externalLogin) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      var result = await CustomerAPI.login(params: externalLogin);

      if (result.access_token != null) {
        await UserStore.to.saveCustomerProfile(CustomerItem(
            access_token: result.access_token,
            tokenType: result.tokenType,
            userID: result.userID,
            expiresIn: result.expiresIn,
            userName: result.userName,
            phoneNumber: result.phoneNumber,
            email: result.email,
            name: result.name,
            avatar: result.avatar,
            priority: result.priority,
            roles: result.roles,
            dateLogin: DateTime.now().toString()));
        EasyLoading.dismiss();
        // CommonMethods.checkRedirectRole();
        //
      }
    } on DioException catch (e) {
      // Get.snackbar("Error", e.response.toString());
      print("error external login: ${e.response.toString()}");
      EasyLoading.dismiss();
    }
  }

  void startResendTimer() {
    state.canResend.value = false;
    state.secondsRemaining.value = 30;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining > 0) {
        state.secondsRemaining--;
      } else {
        timer.cancel();
        state.canResend.value = true;
      }
    });
  }

//  register
  bool isButtonEnabled() {
    // final name = nameController.text;
    // return name.isNotEmpty;
    return true;
  }

  Future<void> handleCustomerUpdateProfile() async {
    try {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true,
      );

      state.name.value = nameController.text.trim();
      state.email.value = myInputEmailController.text.trim();

      print(myInputEmailController.text.trim());

      late CustomerUpdateProfile updatedCustomer;

      updatedCustomer = CustomerUpdateProfile(
        email: state.email.value,
        name: state.name.value,
        gender: state.gender.value,
        dob: state.dob.value,
      );

      if (updatedCustomer != null) {
        await _asyncUpdateCustomerInfo(updatedCustomer);
      }

      EasyLoading.dismiss();
    } catch (e) {
      print('error');
      print(e);
      Get.snackbar('Error', 'Something went wrong. Try again');
      EasyLoading.dismiss();
    }
  }

  Future<void> _asyncUpdateCustomerInfo(
      CustomerUpdateProfile updatedCustomer) async {
    try {
      Map<dynamic, dynamic> data =
          await CustomerAPI.updateProfile(params: updatedCustomer);
    } catch (e) {
      print("Error when update " + e.toString());
      Get.snackbar("Error", 'Có lỗi khi cập nhập thông tin user');
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      String formattedDate =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';

      dobController.text = formattedDate;
      state.dob.value = formattedDate;
    }
  }

  Future<bool> checkExistUserWithPhoneNumber() async {
    bool response = await CustomerAPI.checkExistUserWithPhoneNumber(
        phoneNumber: state.phoneNumber.value);
    return response;
  }

  @override
  void onClose() async {
    await InternetChecker.stopListening();
    super.onClose();
  }
}
