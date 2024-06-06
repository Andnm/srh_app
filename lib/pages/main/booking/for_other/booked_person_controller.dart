import 'dart:async';
import 'dart:convert';
import 'package:cus_dbs_app/common/apis/car_api.dart';
import 'package:cus_dbs_app/common/apis/vehicle_api.dart';
import 'package:cus_dbs_app/common/entities/car_model.dart';
import 'package:cus_dbs_app/common/entities/vehicle.dart';
import 'package:cus_dbs_app/pages/main/booking/for_other/booked_person_state.dart';
import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../common/entities/search_request_model.dart';
import '../../../../routes/routes.dart';

class BookedPersonController extends GetxController {
  final state = BookedPersonState();
  final licensePlateController = TextEditingController();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final colorController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Rx<bool> allFieldsValid = false.obs;

  Rx<VehicleItem> bookingVehicle = VehicleItem().obs;
  CustomerBookedOnBehalf customerBookedOnBehalf = CustomerBookedOnBehalf();
  HomeController get homeController => Get.find<HomeController>();
  Rx<bool> editMode = true.obs;
  Rx<Uint8List?> addImageFront = Rx<Uint8List?>(null);
  Rx<Uint8List?> addCustomerOnBehalfImage = Rx<Uint8List?>(null);

  Rx<XFile> selectedAddImageFront = XFile("").obs;
  Rx<XFile> selectedCustomerOnBehalfImage = XFile("").obs;
  Rx<XFile> selectedAddImageBehind = XFile("").obs;
  Rx<XFile> selectedAddImageLeft = XFile("").obs;
  Rx<XFile> selectedAddImageRight = XFile("").obs;

  Rx<bool> errorCreateVehicle = false.obs;

  Rx<String> selectedBrand = ''.obs;
  Rx<String> selectedBrandId = ''.obs;
  Rx<String> selectedModel = ''.obs;
  Rx<String> errorSelectedModel = ''.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  void toggleEditMode() {
    editMode.value = !editMode.value;
  }

  //Gallery
  Future pickImageFromGallery(BuildContext context, String imageType) async {
    try {
      XFile? returnImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (returnImage == null) return;
      List<int> imageBytes = await returnImage.readAsBytes();

      switch (imageType) {
        case "CustomerOnBehalfImage":
          selectedCustomerOnBehalfImage.value = returnImage;
          addCustomerOnBehalfImage.value =
              File(returnImage.path).readAsBytesSync();
          try {
            EasyLoading.show(
                indicator: const CircularProgressIndicator(),
                maskType: EasyLoadingMaskType.clear,
                dismissOnTap: true);

            // Upload ảnh lên Firebase Storage
            Reference storageRef = FirebaseStorage.instance
                .ref()
                .child('images/${returnImage.name}');
            UploadTask uploadTask = storageRef.putFile(File(returnImage.path));
            TaskSnapshot taskSnapshot = await uploadTask;
            String downloadUrl = await taskSnapshot.ref.getDownloadURL();
            EasyLoading.dismiss();
            // Lưu link ảnh vào state
            state.imageCustomerOnBehalf.value = downloadUrl;

            // In ra link ảnh đã deploy
            print('Download URL: $downloadUrl');
          } catch (e) {
            print('Error uploading image to Firebase Storage: $e');
            // Xử lý lỗi tải lên ảnh
            // Ví dụ: Hiển thị thông báo lỗi cho người dùng
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Lỗi'),
                  content:
                      Text('Đã xảy ra lỗi khi tải lên ảnh. Vui lòng thử lại.'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                );
              },
            );
          }
          break;
        case "Front":
          selectedAddImageFront.value = returnImage;
          addImageFront.value = File(returnImage.path).readAsBytesSync();
          state.imageFront.value = base64Encode(imageBytes);

          try {
            // Upload ảnh lên Firebase Storage
            EasyLoading.show(
                indicator: const CircularProgressIndicator(),
                maskType: EasyLoadingMaskType.clear,
                dismissOnTap: true);

            Reference storageRef = await FirebaseStorage.instance
                .ref()
                .child('images/${returnImage.name}');
            UploadTask uploadTask = storageRef.putFile(File(returnImage.path));
            TaskSnapshot taskSnapshot = await uploadTask;
            String downloadUrl = await taskSnapshot.ref.getDownloadURL();
            EasyLoading.dismiss();
            // Lưu link ảnh vào state
            state.imageFront.value = downloadUrl;

            // In ra link ảnh đã deploy
            print('Download URL: $downloadUrl');
          } catch (e) {
            print('Error uploading image to Firebase Storage: $e');
            // Xử lý lỗi tải lên ảnh
            // Ví dụ: Hiển thị thông báo lỗi cho người dùng
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Lỗi'),
                  content:
                      Text('Đã xảy ra lỗi khi tải lên ảnh. Vui lòng thử lại.'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                );
              },
            );
          }

          break;
        default:
      }

      Get.back();
    } catch (e) {
      print('Error picking image from gallery: $e');
      // Xử lý lỗi chọn ảnh từ gallery
      // Ví dụ: Hiển thị thông báo lỗi cho người dùng
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text(
                'Đã xảy ra lỗi khi chọn ảnh từ gallery. Vui lòng thử lại.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future pickImageFromCamera(BuildContext context, String imageType) async {
    try {
      XFile? returnImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (returnImage == null) return;
      switch (imageType) {
        case "CustomerOnBehalfImage":
          selectedCustomerOnBehalfImage.value = returnImage;
          addCustomerOnBehalfImage.value =
              File(returnImage.path).readAsBytesSync();
          try {
            EasyLoading.show(
                indicator: const CircularProgressIndicator(),
                maskType: EasyLoadingMaskType.clear,
                dismissOnTap: true);

            // Upload ảnh lên Firebase Storage
            Reference storageRef = FirebaseStorage.instance
                .ref()
                .child('images/${returnImage.name}');
            UploadTask uploadTask = storageRef.putFile(File(returnImage.path));
            TaskSnapshot taskSnapshot = await uploadTask;
            String downloadUrl = await taskSnapshot.ref.getDownloadURL();
            EasyLoading.dismiss();
            // Lưu link ảnh vào state
            state.imageCustomerOnBehalf.value = downloadUrl;

            // In ra link ảnh đã deploy
            print('Download URL: $downloadUrl');
          } catch (e) {
            print('Error uploading image to Firebase Storage: $e');
            // Xử lý lỗi tải lên ảnh
            // Ví dụ: Hiển thị thông báo lỗi cho người dùng
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Lỗi'),
                  content:
                      Text('Đã xảy ra lỗi khi tải lên ảnh. Vui lòng thử lại.'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                );
              },
            );
          }

          break;
        case "Front":
          selectedAddImageFront.value = returnImage;
          addImageFront.value = File(returnImage.path).readAsBytesSync();

          try {
            EasyLoading.show(
                indicator: const CircularProgressIndicator(),
                maskType: EasyLoadingMaskType.clear,
                dismissOnTap: true);

            // Upload ảnh lên Firebase Storage
            Reference storageRef = FirebaseStorage.instance
                .ref()
                .child('images/${returnImage.name}');
            UploadTask uploadTask = storageRef.putFile(File(returnImage.path));
            TaskSnapshot taskSnapshot = await uploadTask;
            String downloadUrl = await taskSnapshot.ref.getDownloadURL();
            EasyLoading.dismiss();
            // Lưu link ảnh vào state
            state.imageFront.value = downloadUrl;

            // In ra link ảnh đã deploy
            print('Download URL: $downloadUrl');
          } catch (e) {
            print('Error uploading image to Firebase Storage: $e');
            // Xử lý lỗi tải lên ảnh
            // Ví dụ: Hiển thị thông báo lỗi cho người dùng
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Lỗi'),
                  content:
                      Text('Đã xảy ra lỗi khi tải lên ảnh. Vui lòng thử lại.'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                );
              },
            );
          }

          break;
        default:
      }
      Get.back();
    } catch (e) {
      print('Error picking image from camera: $e');
      // Xử lý lỗi chụp ảnh từ camera
      // Ví dụ: Hiển thị thông báo lỗi cho người dùng
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content:
                Text('Đã xảy ra lỗi khi chụp ảnh từ camera. Vui lòng thử lại.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        },
      );
    }
  }

//Camera

  void resetVehicleFormDataInput() {
    selectedAddImageFront.value = XFile("");
    selectedAddImageBehind.value = XFile("");
    selectedAddImageLeft.value = XFile("");
    selectedAddImageRight.value = XFile("");

    addImageFront.value = null;

    state.imageFront.value = '';
    state.imageBehind.value = '';
    state.imageLeft.value = '';
    state.imageRight.value = '';

    state.imageFrontId.value = '';
    state.imageBehindId.value = '';
    state.imageLeftId.value = '';
    state.imageRightId.value = '';

    licensePlateController.text = '';
    brandController.text = '';
    modelController.text = '';
    colorController.text = '';

    editMode.value = false;

    selectedBrand.value = '';
    selectedBrandId.value = '';
    selectedModel.value = '';
    errorSelectedModel.value = '';

    // update();
  }

  Future<void> fetchAllBrandOfCarFromApi() async {
    try {
      state.dataBrands.value = await CarAPI.getAllBrandOfCar();
    } catch (e) {
      print('Error fetching brand of car: $e');
    }
  }

  void changeBrandSelection(BrandEntity newSelectedBrand) {
    brandController.text = newSelectedBrand.brandName ?? "";
    selectedBrand.value = newSelectedBrand.brandName ?? "";
    selectedBrandId.value = newSelectedBrand.id ?? "";
    errorSelectedModel.value = "";

    modelController.text = "";
    selectedModel.value = "";
  }

  String getBrandLogoPath(String brandName) {
    switch (brandName) {
      case "Toyota":
        return 'assets/brand_logo/Toyota.png';
      case "Audi":
        return 'assets/brand_logo/Audi.png';
      case "BMW":
        return 'assets/brand_logo/BMW.png';
      case "KIA":
        return 'assets/brand_logo/Kia.png';
      case "Ford":
        return 'assets/brand_logo/Ford.png';
      case "Honda":
        return 'assets/brand_logo/Honda.png';
      case "Lexus":
        return 'assets/brand_logo/Lexus.png';
      case "Mazda":
        return 'assets/brand_logo/Mazda.png';
      case "Vinfast":
        return 'assets/brand_logo/Vinfast.png';
      case "Suzuki":
        return 'assets/brand_logo/Suzuki.png';
      case "Mercedes":
        return 'assets/brand_logo/Mercedes.png';
      case "Daewoo":
        return 'assets/brand_logo/Daewoo.png';
      case "Hyundai":
        return 'assets/brand_logo/Hyundai.png';
      default:
        return 'assets/images/car_driving.png';
    }
  }

  //model
  Future<void> fetchAllModelOfBrandFromApi() async {
    try {
      state.dataModels.value = await CarAPI.getAllModelByBrandOfCar(
          brandVehicleId: selectedBrandId.value);
    } catch (e) {
      print('Error fetching model of brand: $e');
    }
  }

  bool checkBrandValueExisted() {
    if (selectedBrand.value.isEmpty) {
      errorSelectedModel.value = "Vui lòng chọn nhãn hiệu trước!";
      return false;
    }
    return true;
  }

  void changeModelSelection(String newModelName) {
    modelController.text = newModelName;
    selectedModel.value = newModelName;
  }

  void updateAllFieldsValid() {
    allFieldsValid.value = nameController.text.isNotEmpty &&
        isValidPhoneNumber(phoneNumberController.text) &&
        addCustomerOnBehalfImage.value != null &&
        addImageFront.value != null &&
        colorController.text.isNotEmpty &&
        licensePlateController.text.isNotEmpty &&
        brandController.text.isNotEmpty &&
        modelController.text.isNotEmpty;
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r'^(0|\+84)[1-9][0-9]{8,9}$');
    return regex.hasMatch(phoneNumber);
  }

  void submit() {
    if (allFieldsValid.value) {
      bookingVehicle.value.licensePlate = licensePlateController.text;
      bookingVehicle.value.brand = brandController.text;
      bookingVehicle.value.model = modelController.text;
      bookingVehicle.value.color = colorController.text;

      customerBookedOnBehalf.name = nameController.text;
      customerBookedOnBehalf.phoneNumber = phoneNumberController.text;
      customerBookedOnBehalf.note = noteController.text;
      customerBookedOnBehalf.imageUrl = state.imageCustomerOnBehalf.value;

      homeController.state.requestCustomerBookedOnBehalf =
          customerBookedOnBehalf;
      homeController.state.requestVehicle.value = bookingVehicle.value;
      homeController.state.bookedOnBehalfVehicleImage.value =
          addImageFront.value;

      homeController.state.requestVehicle.refresh();
      if (homeController.isBottomSheet.value) {
        homeController.isBottomSheet.value = false;
        print("CcHECK: ${homeController.state.requestVehicle.value}");
        print(
            "CcHECK: ${homeController.state.bookedOnBehalfVehicleImage.value}");
        Get.back();
      } else {
        print("CcHECK: ${homeController.state.requestVehicle.value}");
        print(
            "CcHECK: ${homeController.state.bookedOnBehalfVehicleImage.value}");
        Get.toNamed(AppRoutes.mapCustomer);
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
