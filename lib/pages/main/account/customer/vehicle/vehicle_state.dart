import 'package:cus_dbs_app/common/entities/car_model.dart';
import 'package:cus_dbs_app/common/entities/vehicle.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class VehicleState {
  Rx<List<VehicleItem>> dataVehicles = Rx<List<VehicleItem>>([]);
  Rx<bool> editMode = false.obs;

// vehicle selected
  Rx<String> id = ''.obs;
  Rx<List<VehicleItemImage>> dataVehicleImages = Rx<List<VehicleItemImage>>([]);
  // ảnh lấy khi get
  Rx<String> imageFront = ''.obs;
  Rx<String> imageBehind = ''.obs;
  Rx<String> imageLeft = ''.obs;
  Rx<String> imageRight = ''.obs;

  Rx<String> imageFrontId = ''.obs;
  Rx<String> imageBehindId = ''.obs;
  Rx<String> imageLeftId = ''.obs;
  Rx<String> imageRightId = ''.obs;

// xử lý khi add image
  Rx<Uint8List?> addImageFront = Rx<Uint8List?>(null);
  Rx<Uint8List?> addImageBehind = Rx<Uint8List?>(null);
  Rx<Uint8List?> addImageLeft = Rx<Uint8List?>(null);
  Rx<Uint8List?> addImageRight = Rx<Uint8List?>(null);

  Rx<XFile> selectedAddImageFront = XFile("").obs;
  Rx<XFile> selectedAddImageBehind = XFile("").obs;
  Rx<XFile> selectedAddImageLeft = XFile("").obs;
  Rx<XFile> selectedAddImageRight = XFile("").obs;

  Rx<bool> errorCreateVehicle = false.obs;

  // brand and model state
  // get thông tin
  Rx<List<BrandEntity>> dataBrands = Rx<List<BrandEntity>>([]);
  Rx<List<ModelEntity>> dataModels = Rx<List<ModelEntity>>([]);

  // lưu thông tin sau khi chọn trong list
  Rx<String> selectedBrand = ''.obs;
  Rx<String> selectedBrandId = ''.obs;
  Rx<String> selectedModel = ''.obs;
  Rx<String> errorSelectedModel = ''.obs;
}
