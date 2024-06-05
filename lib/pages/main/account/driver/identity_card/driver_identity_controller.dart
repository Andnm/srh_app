import 'dart:async';

import 'package:cus_dbs_app/common/apis/identity_api.dart';
import 'package:cus_dbs_app/common/entities/identity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'index.dart';

class DriverIdentityController extends GetxController {
  final identityCardNumberController = TextEditingController();
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();
  final nationalityController = TextEditingController();
  final placeOriginController = TextEditingController();
  final placeResidenceController = TextEditingController();
  final personalIdentificationController = TextEditingController();
  final expiredDateController = TextEditingController();

  DateTime? _selectedDate;

  final state = DriverIdentityState();

  final imgFront = IdentityCardImage();
  final imgBack = IdentityCardImage();

  @override
  void onInit() async {
    super.onInit();
    // include identity card and identity card image

    var isExist = await checkExistIdentity();

    if (isExist == true) {
      _fetchLoadingAllIdentityInfo();
    }
  }

  Future<bool> checkExistIdentity() async {
    bool response = await IdentityAPI.checkExistIdentity();
    return response;
  }

  Future<void> _fetchLoadingAllIdentityInfo() async {
    handleLoading();
    try {
      await fetchIdentityCardFromApi();
      if (state.id.value.isNotEmpty) {
        await fetchIdentityCardImageFromApi();
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void toggleEditMode() {
    state.editMode.value = !state.editMode.value;
    update();
  }

  Future<void> fetchIdentityCardFromApi() async {
    try {
      IdentityCardInfo? response = await IdentityAPI.getIdentityCard();

      state.id.value = response.id ?? '';
      state.gender.value = response.gender ?? '';

      identityCardNumberController.text = response.identityCardNumber ?? '';
      fullNameController.text = response.fullName ?? '';
      dobController.text = response.dob ?? '';
      genderController.text = response.gender ?? '';
      nationalityController.text = response.nationality ?? '';
      placeOriginController.text = response.placeOrigin ?? '';
      placeResidenceController.text = response.placeResidence ?? '';
      personalIdentificationController.text =
          response.personalIdentification ?? '';
      expiredDateController.text = response.expiredDate ?? '';
    } catch (e) {
      print('Error fetching identity card: $e');
      // Get.snackbar('Error fetching identity card:', '$e');
    }
  }

  //Identity Image

  Future<void> fetchIdentityCardImageFromApi() async {
    handleLoading();
    try {
      state.haveExistedImgFront.value = await checkExistedIdCardImg(true);
      state.haveExistedImgBehind.value = await checkExistedIdCardImg(false);

      if (state.haveExistedImgFront.value || state.haveExistedImgBehind.value) {
        List<IdentityCardImage> response =
            await IdentityAPI.getAllIdentityCardImage(
                identityCardId: state.id.value);

        state.dataIdentityImages.value = response;

        response.forEach(
          (identityCardImageItem) {
            switch (identityCardImageItem.isFront) {
              case true:
                state.imageFront.value = identityCardImageItem.imageUrl ?? '';
                state.imageFrontId.value = identityCardImageItem.id ?? '';
                break;
              case false:
                state.imageBehind.value = identityCardImageItem.imageUrl ?? '';
                state.imageBehindId.value = identityCardImageItem.id ?? '';
                break;
              default:
                break;
            }
          },
        );
      }
    } catch (e) {
      print('Error fetching identity card image: $e');
    } finally {
      EasyLoading.dismiss();
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

  Future<void> selectExpiredDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(9999),
    );
    if (picked != null && picked != _selectedDate) {
      String formattedDate =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';

      expiredDateController.text = formattedDate;
      state.expiredDate.value = formattedDate;
    }
  }

  Future<void> selectDobDate(BuildContext context) async {
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

  void handleLoading() {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
  }

  //kiểm tra ảnh có tồn tại hay không
  Future<bool> checkExistedIdCardImg(bool isFront) async {
    handleLoading();

    try {
      return await IdentityAPI.checkExistIdentityCardImage(isFront);
    } catch (e) {
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
