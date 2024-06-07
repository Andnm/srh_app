import 'dart:async';
import 'dart:convert';
import 'package:cus_dbs_app/common/apis/car_api.dart';
import 'package:cus_dbs_app/common/apis/vehicle_api.dart';
import 'package:cus_dbs_app/common/entities/car_model.dart';
import 'package:cus_dbs_app/common/entities/vehicle.dart';
import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'index.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VehicleController extends GetxController {
  final licensePlateController = TextEditingController();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final colorController = TextEditingController();

  final state = VehicleState();

  @override
  void onInit() async {
    super.onInit();
    await fetchVehicleListFromApi();
  }

  Future<void> fetchVehicleListFromApi() async {
    handleLoading();

    try {
      state.dataVehicles.value = await VehicleItemAPI.getAllVehicle();
    } catch (e) {
      print('Error fetching vehicle: $e');

      // Get.snackbar(
      //   'Error fetching vehicle:',
      //   ' $e',
      //   backgroundColor: Colors.white,
      //   colorText: Colors.red,
      //   borderWidth: 1,
      //   boxShadows: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.2),
      //       spreadRadius: 2,
      //       blurRadius: 4,
      //       offset: Offset(0, 2),
      //     ),
      //   ],
      // );
    } finally {
      EasyLoading.dismiss();
    }
  }

  void handleSelectedVehicle(VehicleItem vehicleItem) {
    state.id.value = vehicleItem.id ?? '';
    licensePlateController.text = vehicleItem.licensePlate ?? '';
    brandController.text = vehicleItem.brand ?? '';
    state.selectedBrand.value = vehicleItem.brand ?? '';
    modelController.text = vehicleItem.model ?? '';
    colorController.text = vehicleItem.color ?? '';

    //
    fetchVehicleImageFromApi();
  }

  Future<void> fetchVehicleImageFromApi() async {
    handleLoading();

    try {
      List<VehicleItemImage> response =
          await VehicleItemAPI.getAllVehicleImage(vehicleId: state.id.value);

      state.dataVehicleImages.value = response;

      response.forEach((vehicleItem) {
        switch (vehicleItem.vehicleImageType) {
          case "Front":
            state.imageFront.value = vehicleItem.imageUrl ?? '';
            state.imageFrontId.value = vehicleItem.id ?? '';
            break;
          case "Behind":
            state.imageBehind.value = vehicleItem.imageUrl ?? '';
            state.imageBehindId.value = vehicleItem.id ?? '';
            break;
          case "Left":
            state.imageLeft.value = vehicleItem.imageUrl ?? '';
            state.imageLeftId.value = vehicleItem.id ?? '';
            break;
          case "Right":
            state.imageRight.value = vehicleItem.imageUrl ?? '';
            state.imageRightId.value = vehicleItem.id ?? '';
            break;
          default:
            break;
        }
      });
    } catch (e) {
      print('Error fetching vehicle image: $e');
      Get.snackbar('Lỗi', 'Có lỗi khi lấy ảnh xe');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void toggleEditMode() {
    state.editMode.value = !state.editMode.value;
  }

  bool areAllFieldsFilled() {
    return state.addImageFront.value != null &&
        state.addImageBehind.value != null &&
        state.addImageLeft.value != null &&
        state.addImageRight.value != null &&
        colorController.text.isNotEmpty &&
        licensePlateController.text.isNotEmpty;
  }

  //Gallery
  Future pickImageFromGallery(BuildContext context, String imageType) async {
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
      case "Left":
        state.selectedAddImageLeft.value = returnImage;
        state.addImageLeft.value = File(returnImage.path).readAsBytesSync();
        state.imageLeft.value = base64Encode(imageBytes);
      case "Right":
        state.selectedAddImageRight.value = returnImage;
        state.addImageRight.value = File(returnImage.path).readAsBytesSync();
        state.imageRight.value = base64Encode(imageBytes);

        break;
      default:
    }

    Navigator.of(context).pop();
  }

//Camera
  Future pickImageFromCamera(BuildContext context, String imageType) async {
    XFile? returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    switch (imageType) {
      case "Front":
        state.selectedAddImageFront.value = returnImage;
        state.addImageFront.value = File(returnImage.path).readAsBytesSync();
      case "Behind":
        state.selectedAddImageBehind.value = returnImage;
        state.addImageBehind.value = File(returnImage.path).readAsBytesSync();
      case "Left":
        state.selectedAddImageLeft.value = returnImage;
        state.addImageLeft.value = File(returnImage.path).readAsBytesSync();
      case "Right":
        state.selectedAddImageRight.value = returnImage;
        state.addImageRight.value = File(returnImage.path).readAsBytesSync();
        break;
      default:
    }
    Navigator.of(context).pop();
  }

//xử lý luồng tạo thêm vehicle mới
// sẽ tạo vehicle trước, api trả về id
// ném id đó vào api post vehicle image
  Future<void> handleAddNewVehicle() async {
    handleLoading();

    try {
      var responseAddNewVehicleInfo = await _callApiToAddNewVehicleInfo();

      await _callApiToAddNewVehicleImage(responseAddNewVehicleInfo);
      state.errorCreateVehicle.value = false;
      resetVehicleFormDataInput();
    } catch (e) {
      state.errorCreateVehicle.value = true;
      print('Error add vehicle: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<String> _callApiToAddNewVehicleInfo() async {
    try {
      late VehicleItem vehicleItem;

      vehicleItem = VehicleItem(
        licensePlate: licensePlateController.text.trim(),
        brand: brandController.text.trim(),
        model: modelController.text.trim(),
        color: colorController.text.trim(),
      );

      var response =
          await VehicleItemAPI.addNewVehicle(vehicleItem: vehicleItem);

      return response;
    } catch (e) {
      print('Error call api add vehicle: $e');

      Get.snackbar(
        'Lỗi',
        'Có lỗi khi thêm xe',
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
      return '';
    }
  }

  Future<void> _callApiToAddNewVehicleImage(String vehicleId) async {
    try {
      dio.FormData formDataFront = dio.FormData.fromMap({
        'vehicleId': vehicleId,
        'vehicleImageType': 'Front',
        'file': await dio.MultipartFile.fromFile(
            state.selectedAddImageFront.value.path,
            filename: state.selectedAddImageFront.value.name),
      });
      dio.FormData formDataBehind = dio.FormData.fromMap({
        'vehicleId': vehicleId,
        'vehicleImageType': 'Behind',
        'file': await dio.MultipartFile.fromFile(
            state.selectedAddImageBehind.value.path,
            filename: state.selectedAddImageBehind.value.name),
      });
      dio.FormData formDataLeft = dio.FormData.fromMap({
        'vehicleId': vehicleId,
        'vehicleImageType': 'Left',
        'file': await dio.MultipartFile.fromFile(
            state.selectedAddImageLeft.value.path,
            filename: state.selectedAddImageLeft.value.name),
      });
      dio.FormData formDataRight = dio.FormData.fromMap({
        'vehicleId': vehicleId,
        'vehicleImageType': 'Right',
        'file': await dio.MultipartFile.fromFile(
            state.selectedAddImageRight.value.path,
            filename: state.selectedAddImageRight.value.name),
      });

      await VehicleItemAPI.addNewVehicleImage(vehicleItemImage: formDataFront);
      await VehicleItemAPI.addNewVehicleImage(vehicleItemImage: formDataBehind);
      await VehicleItemAPI.addNewVehicleImage(vehicleItemImage: formDataLeft);
      await VehicleItemAPI.addNewVehicleImage(vehicleItemImage: formDataRight);

      Get.snackbar(
        'Thông báo',
        'Thêm xe thành công!',
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

      await fetchVehicleListFromApi();
    } catch (e) {
      print('Error call api add vehicle image: $e');

      Get.snackbar(
        'Lỗi',
        'Có lỗi khi thêm ảnh xe',
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
    }
  }

  void resetVehicleFormDataInput() {
    state.selectedAddImageFront.value = XFile("");
    state.selectedAddImageBehind.value = XFile("");
    state.selectedAddImageLeft.value = XFile("");
    state.selectedAddImageRight.value = XFile("");

    state.addImageFront.value = null;
    state.addImageBehind.value = null;
    state.addImageLeft.value = null;
    state.addImageRight.value = null;

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

    state.editMode.value = false;

    state.selectedBrand.value = '';
    state.selectedBrandId.value = '';
    state.selectedModel.value = '';
    state.errorSelectedModel.value = '';

    update();
  }

  Future<void> callApiToDeleteVehicle() async {
    try {
      await VehicleItemAPI.deleteVehicle(vehicleId: state.id.value);

      Get.snackbar(
        'Thông báo',
        'Xóa phương tiện thành công!',
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

      await fetchVehicleListFromApi();
    } catch (e) {
      print('Error call api delete vehicle: $e');

      Get.snackbar(
        'Lỗi',
        'Có lỗi khi xóa phương tiện',
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
    }
  }

  void handleLoading() {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
  }

  // xử lý call api gọi brand và model
  //brand
  Future<void> fetchAllBrandOfCarFromApi() async {
    try {
      state.dataBrands.value = await CarAPI.getAllBrandOfCar();
    } catch (e) {
      print('Error fetching brand of car: $e');
    }
  }

  void changeBrandSelection(BrandEntity newSelectedBrand) {
    brandController.text = newSelectedBrand.brandName ?? "";
    state.selectedBrand.value = newSelectedBrand.brandName ?? "";
    state.selectedBrandId.value = newSelectedBrand.id ?? "";
    state.errorSelectedModel.value = "";

    modelController.text = "";
    state.selectedModel.value = "";
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
          brandVehicleId: state.selectedBrandId.value);
    } catch (e) {
      print('Error fetching model of brand: $e');
    }
  }

  bool checkBrandValueExisted() {
    if (state.selectedBrand.value.isEmpty) {
      state.errorSelectedModel.value = "Vui lòng chọn nhãn hiệu trước!";
      return false;
    }
    return true;
  }

  void changeModelSelection(String newModelName) {
    modelController.text = newModelName;
    state.selectedModel.value = newModelName;
  }

  //Xử lý call api update vehicle
  Future<void> handleCallApiToUpdateVehicle(
      {required VehicleItem newVehicleItem}) async {
    handleLoading();

    try {
      //update thông tin xe
      late VehicleItem vehicleItem;

      vehicleItem = VehicleItem(
        licensePlate: licensePlateController.text.trim(),
        brand: brandController.text.trim(),
        model: modelController.text.trim(),
        color: colorController.text.trim(),
      );

      var response = await VehicleItemAPI.updateVehicle(
          vehicleId: newVehicleItem.id, vehicleItem: vehicleItem);

      //update ẢNH XE
      //ảnh mặt trước
      if (state.selectedAddImageFront.value.path.isNotEmpty) {
        dio.FormData formDataFront = dio.FormData.fromMap(
          {
            'file': await dio.MultipartFile.fromFile(
                state.selectedAddImageFront.value.path,
                filename: state.selectedAddImageFront.value.name),
          },
        );

        await VehicleItemAPI.updateVehicleImage(
            vehicleImageId: state.imageFrontId.value, dataImage: formDataFront);
      }

      //ảnh mặt sau
      if (state.selectedAddImageBehind.value.path.isNotEmpty) {
        dio.FormData formDataBehind = dio.FormData.fromMap({
          'file': await dio.MultipartFile.fromFile(
              state.selectedAddImageBehind.value.path,
              filename: state.selectedAddImageBehind.value.name),
        });
        await VehicleItemAPI.updateVehicleImage(
            vehicleImageId: state.imageBehindId.value,
            dataImage: formDataBehind);
      }

      //ảnh mặt trái
      if (state.selectedAddImageLeft.value.path.isNotEmpty) {
        dio.FormData formDataLeft = dio.FormData.fromMap(
          {
            'file': await dio.MultipartFile.fromFile(
                state.selectedAddImageLeft.value.path,
                filename: state.selectedAddImageLeft.value.name),
          },
        );

        await VehicleItemAPI.updateVehicleImage(
            vehicleImageId: state.imageLeftId.value, dataImage: formDataLeft);
      }

      //ảnh mặt phải
      if (state.selectedAddImageRight.value.path.isNotEmpty) {
        dio.FormData formDataRight = dio.FormData.fromMap({
          'file': await dio.MultipartFile.fromFile(
              state.selectedAddImageRight.value.path,
              filename: state.selectedAddImageRight.value.name),
        });
        await VehicleItemAPI.updateVehicleImage(
            vehicleImageId: state.imageRightId.value, dataImage: formDataRight);
      }

      Get.snackbar(
        'Thông báo',
        "Cập nhập xe thành công!",
        backgroundColor: Colors.white,
        colorText: Colors.green.shade700,
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

      fetchVehicleListFromApi();
    } catch (e) {
      print('Error call api update vehicle info: $e');

      Get.snackbar(
        'Lỗi',
        'Có lỗi khi chỉnh sửa thông tin xe',
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
    } finally {
      //cập nhập xong thì chuyển trạng thái về false
      state.editMode.value = false;
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
