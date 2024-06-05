import 'dart:async';
import 'dart:convert';
import 'package:cus_dbs_app/common/apis/customer_api.dart';
import 'package:cus_dbs_app/common/entities/customer.dart';
import 'package:cus_dbs_app/pages/auth/customer/register/index.dart';
import 'package:cus_dbs_app/pages/main/account/account_controller.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'index.dart';

class CustomerUpdateProfileController extends GetxController {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();

  DateTime? _selectedDate;

  final state = CustomerUpdateProfileState();

  CustomerRegisterController get _customerRegisterController =>
      Get.find<CustomerRegisterController>();
  AccountController get _accountController => Get.find<AccountController>();

  @override
  void onInit() {
    super.onInit();
    fetchCustomerProfileFromApi();
    update();
  }

  void toggleEditMode() {
    state.editMode.value = !state.editMode.value;
    update();
  }

  Future<Map<String, dynamic>?> _asyncGetCustomerProfile() async {
    try {
      Map<String, dynamic> response = await CustomerAPI.getCustomerProfile();
      return response;
    } catch (e) {
      print('Error fetching customer profile: $e');
      return null;
    }
  }

  Future<void> fetchCustomerProfileFromApi() async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    state.selectedAvatar.value = XFile("");

    try {
      Map<String, dynamic>? response = await _asyncGetCustomerProfile();
      if (response != null) {
        state.name.value = response['name'] ?? '';
        state.address.value = response['address'] ?? '';
        state.avatar.value = response['avatar'] ?? '';
        state.phoneNumber.value = response['phoneNumber'] ?? '';
        state.gender.value = response['gender'] ?? '';
        state.dob.value = response['dob'] ?? '';

        nameController.text = response['name'] ?? '';
        addressController.text = response['address'] ?? '';
        phoneNumberController.text = response['phoneNumber'] ?? '';
        genderController.text = response['gender'] ?? '';
        dobController.text = response['dob'] ?? '';

        update();
      } else {
        // Get.(
        //     'Error fetching customer profile:', 'Unable to retrieve data');
      }
    } catch (e) {
      print('Error fetching customer profile: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  bool isValidPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) return false;

    if (phoneNumber.startsWith('0') || phoneNumber.startsWith('84')) {
      return phoneNumber.length == 10 || phoneNumber.length == 11;
    } else {
      return false;
    }
  }

  bool isValidAge(String? dob) {
    if (dob == null || dob.isEmpty) return false;
    DateTime birthDate = DateTime.parse(dob);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age >= 18;
  }

// xử lý update
  Future<void> handleCustomerUpdateProfile() async {
    try {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true,
      );

      state.name.value = nameController.text.trim();
      state.address.value = addressController.text.trim();
      state.phoneNumber.value = phoneNumberController.text.trim();

      bool hasError = false;

      if (state.phoneNumber.value != '') {
        if (!isValidPhoneNumber(state.phoneNumber.value)) {
          state.errorPhoneNumber.value = 'Phone number is not valid';
          hasError = true;
        }
      }

      if (state.dob.value != '') {
        if (!isValidAge(state.dob.value)) {
          state.errorDob.value = 'User must be at least 18 years old';
          hasError = true;
        }
      }

      if (hasError) {
        EasyLoading.dismiss();
        return;
      }

      late CustomerUpdateProfile updatedCustomer;

      updatedCustomer = CustomerUpdateProfile(
        name: state.name.value,
        address: state.address.value,
        phoneNumber: state.phoneNumber.value,
        gender: state.gender.value,
        dob: state.dob.value,
      );

      if (state.selectedAvatar.value.path != '') {
        await _asyncUpdateCustomerAvatar();
      }

      if (updatedCustomer != null) {
        await _asyncUpdateCustomerInfo(updatedCustomer);
      }

      // Get.snackbar('Thành công', 'Cập nhập hồ sơ thành công!');
      state.editMode.value = false;
      update();
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
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);

      Map<String, dynamic> data =
          await CustomerAPI.updateProfile(params: updatedCustomer);

      await _customerRegisterController.clearFullName();
    } catch (e) {
      Get.snackbar("Error", e.toString());
      EasyLoading.dismiss();
    }
  }

  Future<void> _asyncUpdateCustomerAvatar() async {
    try {
      dio.FormData imageUrl = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
            state.selectedAvatar.value.path,
            filename: state.selectedAvatar.value.name),
      });

      var response = await CustomerAPI.changeAvatarProfile(imageUrl: imageUrl);

      state.avatar.value = response.avatar ?? '';

      //xử lý để cập nhập lại avatar trong account page state
    } catch (e) {
      Get.snackbar("Error", e.toString());
      EasyLoading.dismiss();
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

  //Gallery
  Future pickImageFromGallery(BuildContext context) async {
    XFile? returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnImage == null) return;
    List<int> imageBytes = await returnImage.readAsBytes();

    state.selectedAvatar.value = returnImage;
    state.avatar.value = base64Encode(imageBytes);
    state.selectedAvatarBase64.value = base64Encode(imageBytes);

    Navigator.of(context).pop();
  }

//Camera
  Future pickImageFromCamera(BuildContext context) async {
    XFile? returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    List<int> imageBytes = await returnImage.readAsBytes();

    state.selectedAvatar.value = returnImage;
    state.avatar.value = base64Encode(imageBytes);
    state.selectedAvatarBase64.value = base64Encode(imageBytes);

    Navigator.of(context).pop();
  }

  //update after register
  bool isButtonEnabled() {
    return state.phoneNumber.value == "";
  }

  Future<void> handleCustomerUpdateProfileAfterRegister() async {
    try {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true,
      );

      state.phoneNumber.value = phoneNumberController.text.trim();

      String? fullNameCustomerRegister =
          await _customerRegisterController.getFullName();

      String sdt = state.phoneNumber.value;

      if (state.phoneNumber.value != '') {
        if (!isValidPhoneNumber(state.phoneNumber.value)) {
          state.errorPhoneNumber.value = 'Phone number is not valid';
          state.hasError.value = true;
        }
      }

      if (state.dob.value != '') {
        if (!isValidAge(state.dob.value)) {
          state.errorDob.value = 'User must be at least 18 years old';
          state.hasError.value = true;
        }
      }

      if (state.hasError.value) {
        EasyLoading.dismiss();
        return;
      }
      late CustomerUpdateProfile updatedCustomer;

      updatedCustomer = CustomerUpdateProfile(
        name: fullNameCustomerRegister,
        address: state.address.value,
        phoneNumber: state.phoneNumber.value,
        gender: state.gender.value,
        dob: state.dob.value,
      );

      if (updatedCustomer != null) {
        await _asyncUpdateCustomerInfo(updatedCustomer);
      }

      Get.snackbar('Thành công', 'Cập nhập hồ sơ thành công!');
      state.editMode.value = false;
      update();
      EasyLoading.dismiss();
    } catch (e) {
      print('error');
      print(e);
      Get.snackbar('Error', 'Something went wrong. Try again');
      EasyLoading.dismiss();
    }
  }

  bool checkDataIsNew() {
    return state.name.value != '' ||
        state.address.value != '' ||
        state.phoneNumber.value != '' ||
        state.avatar.value != '' ||
        state.gender.value != '' ||
        state.dob.value != '';
  }

  void clearData() {
    state.selectedAvatarBase64.value = "";
  }

  @override
  void onClose() {
    super.onClose();
  }
}
