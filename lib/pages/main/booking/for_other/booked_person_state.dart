import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cus_dbs_app/common/entities/car_model.dart';
import 'package:get/get.dart';

import '../../../../common/entities/vehicle.dart';

class BookedPersonState {
  Rx<String> name = ''.obs;
  Rx<String> phoneNumber = ''.obs;
  Rx<String> note = ''.obs;
// vehicle selected
  Rx<String> id = ''.obs;

  // ảnh lấy khi get
  Rx<String> imageFront = ''.obs;
  Rx<String> imageBehind = ''.obs;
  Rx<String> imageLeft = ''.obs;
  Rx<String> imageRight = ''.obs;

  Rx<String> imageFrontId = ''.obs;
  Rx<String> imageBehindId = ''.obs;
  Rx<String> imageLeftId = ''.obs;
  Rx<String> imageRightId = ''.obs;

  Rx<List<BrandEntity>> dataBrands = Rx<List<BrandEntity>>([]);
  Rx<List<ModelEntity>> dataModels = Rx<List<ModelEntity>>([]);
}
