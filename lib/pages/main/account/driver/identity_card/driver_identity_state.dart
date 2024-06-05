import 'package:cus_dbs_app/common/entities/identity.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class DriverIdentityState {
  Rx<String> id = ''.obs;
  Rx<String> identityCardNumber = ''.obs;
  Rx<String> fullName = ''.obs;
  Rx<String> dob = ''.obs;
  Rx<String> gender = ''.obs;
  Rx<String> nationality = ''.obs;
  Rx<String> placeOrigin = ''.obs;
  Rx<String> placeResidence = ''.obs;
  Rx<String> personalIdentification = ''.obs;
  Rx<String> expiredDate = ''.obs;
  RxList<String> genderList = <String>['', 'Male', 'Female', 'Other'].obs;

  //Biến kiểm tra ảnh tồn tại trong database trước hay chưa
  Rx<bool> haveExistedImgFront = false.obs;
  Rx<bool> haveExistedImgBehind = false.obs;

  // ảnh lấy khi get
  Rx<String> imageFrontId = ''.obs;
  Rx<String> imageBehindId = ''.obs;
  Rx<List<IdentityCardImage>> dataIdentityImages =
      Rx<List<IdentityCardImage>>([]);
  Rx<String> imageFront = ''.obs;
  Rx<String> imageBehind = ''.obs;

  // xử lý khi add image
  Rx<Uint8List?> addImageFront = Rx<Uint8List?>(null);
  Rx<Uint8List?> addImageBehind = Rx<Uint8List?>(null);

  Rx<XFile> selectedAddImageFront = XFile("").obs;
  Rx<XFile> selectedAddImageBehind = XFile("").obs;

  Rx<bool> imageUploadedFront = false.obs;
  Rx<bool> imageUploadedBack = false.obs;

  Rx<bool> editMode = false.obs;

  // error
  Rx<String> errorDob = ''.obs;

  Rx<bool> errorIdentityCard = false.obs;
}
