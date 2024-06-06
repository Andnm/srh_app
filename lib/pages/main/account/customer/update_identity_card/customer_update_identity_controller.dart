import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'dart:io';
import 'dart:convert';

import 'package:cus_dbs_app/common/apis/identity_api.dart';
import 'package:cus_dbs_app/common/entities/identity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'index.dart';
import 'package:image_picker/image_picker.dart';

class CustomerUpdateIdentityController extends GetxController {
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

  final state = CustomerUpdateIdentityState();

  @override
  void onInit() {
    super.onInit();
  }

  void handleLoading() {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
  }

  Future<bool> checkExistIdentity() async {
    bool response = await IdentityAPI.checkExistIdentity();
    return response;
  }

  Future<void> fetchLoadingAllIdentityInfo() async {
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
  }

  void swapToEditMode() {
    state.editMode.value = true;
  }

  void handleDisplayFrontImage(image) {
    if (state.selectedAddImageFront?.value != null) {
      state.selectedAddImageFront?.value = image;
      state.addImageFront.value = File(image.path).readAsBytesSync();
      state.imageUploadedFront.value = true;
    }
  }

  void handleDisplayBehindImage(image) {
    if (state.selectedAddImageFront?.value != null) {
      state.selectedAddImageFront?.value = image;
      state.addImageBehind.value = File(image.path).readAsBytesSync();
      state.imageUploadedBack.value = true;
    }
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
//get thông tin
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

//UPDATE IDENTITY
//đặt tên hơi ngu, bấm nút cập nhập nhưng xử lý logic cho cả add new và update
  Future<void> handleCustomerUpdateIdentityCard() async {
    try {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true,
      );

      state.identityCardNumber.value = identityCardNumberController.text.trim();
      state.fullName.value = fullNameController.text.trim();
      state.dob.value = dobController.text.trim();
      //
      state.nationality.value = nationalityController.text.trim();
      state.placeOrigin.value = placeOriginController.text.trim();
      state.placeResidence.value = placeResidenceController.text.trim();
      state.personalIdentification.value =
          personalIdentificationController.text.trim();
      state.expiredDate.value = expiredDateController.text.trim();

      bool hasError = false;
      if (state.dob.value != '') {
        if (!isValidAge(state.dob.value)) {
          state.errorDob.value = 'Khách hàng ít nhất phải 18 tuổi';
          hasError = true;
        }
      }

      if (state.identityCardNumber.value == '') {
        state.errorIdCard.value = 'Vui lòng nhập số CCCD!';
        hasError = true;
      }

      if (state.identityCardNumber.value.length != 12) {
        state.errorIdCard.value = 'CCCD không hợp lệ!';
        hasError = true;
      }

      if (hasError) {
        return;
      }

      late IdentityCardInfo updatedIdentity;

      updatedIdentity = IdentityCardInfo(
        identityCardNumber: state.identityCardNumber.value,
        fullName: state.fullName.value,
        dob: state.dob.value,
        gender: state.gender.value,
        nationality: state.nationality.value,
        placeOrigin: state.placeOrigin.value,
        placeResidence: state.placeResidence.value,
        personalIdentification: state.personalIdentification.value,
        expiredDate: state.expiredDate.value,
      );

      if (await checkExistIdentity()) {
        if (updatedIdentity != null) {
          await _asyncUpdateIdentityCard(updatedIdentity);
        }
      } else {
        //chưa có identity thì tạo identity

        state.id.value = await IdentityAPI.createIdentityCard(
            identityCardInfo: updatedIdentity);
      }

      // kiểm tra xem là đã có identity card img chưa
      // nếu có thì gọi hàm update
      // còn nếu không thì gọi hàm create
      //tạm thời để false

      if (state.haveExistedImgFront.value) {
        //UPDATE
        await _callApiToUpdateIdentityCardImageFront(state.id.value);
      } else {
        //ADD NEW
        await _callApiToAddNewIdentityCardImageFront(state.id.value);
      }

      if (state.haveExistedImgBehind.value) {
        //UPDATE
        await _callApiToUpdateIdentityCardImageBehind(state.id.value);
      } else {
        //ADD NEW
        await _callApiToAddNewIdentityCardImageBehind(state.id.value);
      }

      Get.snackbar(
        'Thông báo',
        'Cập nhập CCCD thành công!',
        backgroundColor: Colors.white,
        colorText: Colors.green,
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

      toggleEditMode();
      state.selectedAddImageFront.value.path == '';
      state.selectedAddImageBehind.value.path == '';
    } catch (e) {
      // Get.snackbar('Error', 'Something went wrong. Try again');
    } finally {
      EasyLoading.dismiss();
    }
  }

//update image
  Future<void> _callApiToUpdateIdentityCardImageFront(
      String identityCardId) async {
    try {
      if (state.selectedAddImageFront.value.path != '') {
        dio.FormData formDataFront = dio.FormData.fromMap({
          'identityCardId': identityCardId,
          'file': await dio.MultipartFile.fromFile(
              state.selectedAddImageFront.value.path,
              filename: state.selectedAddImageFront.value.name),
          'isFront': true,
        });

        IdentityCardImage response = await IdentityAPI.updateIdentityCardImage(
            identityCardImage: formDataFront,
            identityCardImageId: state.imageFrontId.value);

        state.imageFrontId.value = response.id ?? '';
      }
    } catch (e) {
      print('Error call api update identity image front: $e');
    }
  }

  Future<void> _callApiToUpdateIdentityCardImageBehind(
      String identityCardId) async {
    try {
      if (state.selectedAddImageBehind.value.path != '') {
        dio.FormData formDataBehind = dio.FormData.fromMap({
          'identityCardId': identityCardId,
          'file': await dio.MultipartFile.fromFile(
              state.selectedAddImageBehind.value.path,
              filename: state.selectedAddImageBehind.value.name),
          'isFront': false,
        });

        IdentityCardImage response = await IdentityAPI.updateIdentityCardImage(
          identityCardImage: formDataBehind,
          identityCardImageId: state.imageBehindId.value,
        );

        state.imageBehindId.value = response.id ?? '';
      }
    } catch (e) {
      print('Error call api update identity image behind: $e');
    }
  }
//TẠO IDENTITY
//post image

  Future<void> _callApiToAddNewIdentityCardImageFront(
      String identityCardId) async {
    try {
      if (state.selectedAddImageFront.value.path != '') {
        dio.FormData formDataFront = dio.FormData.fromMap({
          'identityCardId': identityCardId,
          'isFront': 'true',
          'file': await dio.MultipartFile.fromFile(
              state.selectedAddImageFront.value.path,
              filename: state.selectedAddImageFront.value.name),
        });

        await IdentityAPI.addNewIdentityCardImage(
            identityCardImage: formDataFront);
      }
    } catch (e) {
      print('Error call api add identity card image front: $e');
    }
  }

  Future<void> _callApiToAddNewIdentityCardImageBehind(
      String identityCardId) async {
    try {
      if (state.selectedAddImageBehind.value.path != '') {
        dio.FormData formDataBehind = dio.FormData.fromMap({
          'identityCardId': identityCardId,
          'isFront': 'false',
          'file': await dio.MultipartFile.fromFile(
              state.selectedAddImageBehind.value.path,
              filename: state.selectedAddImageBehind.value.name),
        });

        await IdentityAPI.addNewIdentityCardImage(
            identityCardImage: formDataBehind);
      }
    } catch (e) {
      print('Error call api add identity card image behind: $e');
    }
  }

  Future<void> _asyncUpdateIdentityCard(
      IdentityCardInfo updatedIdentity) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);

      Map<String, dynamic> data =
          await IdentityAPI.updateIdentityCard(data: updatedIdentity);
    } on DioException catch (e) {
      // Get.snackbar("Error", e.response.toString());
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

  Future<void> asyncCreateIdentityCard() async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);

      late IdentityCardInfo createIdentityCard;

      state.identityCardNumber.value = identityCardNumberController.text.trim();
      state.fullName.value = fullNameController.text.trim();
      state.dob.value = dobController.text.trim();
      //gender
      state.nationality.value = nationalityController.text.trim();
      state.placeOrigin.value = placeOriginController.text.trim();
      state.placeResidence.value = placeResidenceController.text.trim();
      state.personalIdentification.value =
          personalIdentificationController.text.trim();
      state.expiredDate.value = expiredDateController.text.trim();

      createIdentityCard = IdentityCardInfo(
        identityCardNumber: state.identityCardNumber.value,
        fullName: state.fullName.value,
        dob: state.dob.value,
        gender: state.gender.value,
        nationality: state.nationality.value,
        placeOrigin: state.placeOrigin.value,
        placeResidence: state.placeResidence.value,
        personalIdentification: state.personalIdentification.value,
        expiredDate: state.expiredDate.value,
      );

      bool hasError = false;
      if (state.dob.value != '') {
        if (!isValidAge(state.dob.value)) {
          state.errorDob.value = 'Khách hàng ít nhất phải 18 tuổi';
          hasError = true;
        }
      }

      if (state.identityCardNumber.value == '') {
        state.errorIdCard.value = 'Vui lòng nhập số CCCD!';
        hasError = true;
      }

      if (state.identityCardNumber.value.length != 12) {
        state.errorIdCard.value = 'CCCD không hợp lệ!';
        hasError = true;
      }

      if (hasError) {
        return;
      }

      String identityCardId = await IdentityAPI.createIdentityCard(
          identityCardInfo: createIdentityCard);
      state.errorIdentityCard.value = false;

      await _callApiToAddNewIdentityCardImageFront(identityCardId);
      await _callApiToAddNewIdentityCardImageBehind(identityCardId);
    } catch (e) {
      state.errorIdentityCard.value = true;
      state.errorIdCard.value = 'CCCD đã tồn tại trong hệ thống!';
    } finally {
      EasyLoading.dismiss();
    }
  }

  //Gallery
  Future pickImageFromGallery(BuildContext context, String imageType) async {
    swapToEditMode();
    XFile? returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnImage == null) return;
    List<int> imageBytes = await returnImage.readAsBytes();

    switch (imageType) {
      case "Front":
        state.selectedAddImageFront.value = returnImage;
        state.addImageFront.value = File(returnImage.path).readAsBytesSync();
        state.imageFront.value = base64Encode(imageBytes);
      case "Behind":
        state.selectedAddImageBehind.value = returnImage;
        state.addImageBehind.value = File(returnImage.path).readAsBytesSync();
        state.imageBehind.value = base64Encode(imageBytes);

        break;
      default:
    }

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

//Camera
  Future pickImageFromCamera(BuildContext context, String imageType) async {
    swapToEditMode();
    XFile? returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    List<int> imageBytes = await returnImage.readAsBytes();

    switch (imageType) {
      case "Front":
        state.selectedAddImageFront.value = returnImage;
        state.addImageFront.value = File(returnImage.path).readAsBytesSync();
        state.imageFront.value = base64Encode(imageBytes);

      case "Behind":
        state.selectedAddImageBehind.value = returnImage;
        state.addImageBehind.value = File(returnImage.path).readAsBytesSync();
        state.imageBehind.value = base64Encode(imageBytes);

      default:
    }
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
