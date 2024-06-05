import 'package:cus_dbs_app/common/entities/driving_license.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class DriverDlcState {
  Rx<String> drivingLicenseId = ''.obs;
  Rx<String> expiredDate = ''.obs;
  Rx<String> issueDate = ''.obs;

// state to handle img
   Rx<String> imageFrontId = ''.obs;
  Rx<String> imageBehindId = ''.obs;
  Rx<List<DrivingLicenseImage>> dataDlcImages =
      Rx<List<DrivingLicenseImage>>([]);
  Rx<String> imageFront = ''.obs;
  Rx<String> imageBehind = ''.obs;


  Rx<bool> editMode = false.obs;

  // error
  Rx<String> errorDob = ''.obs;
}
