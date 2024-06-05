import 'dart:async';

import 'package:cus_dbs_app/common/apis/driving_license_api.dart';
import 'package:cus_dbs_app/common/entities/driving_license.dart';
import 'package:cus_dbs_app/common/entities/identity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'index.dart';

class DriverDlcController extends GetxController {
  final typeController = TextEditingController();
  final issueDateController = TextEditingController();
  final expiredDateController = TextEditingController();

  DateTime? _selectedDate;

  final state = DriverDlcState();

  final imgFront = IdentityCardImage();
  final imgBack = IdentityCardImage();

  @override
  void onInit() {
    super.onInit();
    // include identity card and identity card image
    _fetchLoadingAllDrivingLicenseInfo();
  }

  Future<void> _fetchLoadingAllDrivingLicenseInfo() async {
    handleLoading();
    try {
      await fetchDlcFromApi();
      if (state.drivingLicenseId.value.isNotEmpty) {
        await fetchDlcImageFromApi();
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> fetchDlcFromApi() async {
    try {
      List<DrivingLicense>? response =
          await DrivingLicenseAPI.getAllDrivingLicense();

      state.drivingLicenseId.value = response[0].id ?? "";
      typeController.text = response[0].type ?? "";
      issueDateController.text = response[0].issueDate ?? "";
      expiredDateController.text = response[0].expiredDate ?? "";
    } catch (e) {
      print('Error fetching dlc card: $e');
      // Get.snackbar('Error fetching identity card:', '$e');
    }
  }

//Dlc Image

  Future<void> fetchDlcImageFromApi() async {
    handleLoading();

    try {
      List<DrivingLicenseImage> response =
          await DrivingLicenseAPI.getAllDrivingLicenseImage(
              drivingLicenseId: state.drivingLicenseId.value);

      state.dataDlcImages.value = response;

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
    } catch (e) {
      print('Error fetching dlc image: $e');
      Get.snackbar('Error fetching dlc  image:', '$e');
    } finally {
      EasyLoading.dismiss();
    }
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

  Future<void> selectIssueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      String formattedDate =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';

      issueDateController.text = formattedDate;
      state.issueDate.value = formattedDate;
    }
  }

  void handleLoading() {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
