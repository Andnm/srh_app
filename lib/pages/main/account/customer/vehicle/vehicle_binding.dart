import 'package:get/get.dart';

import 'index.dart';

class VehicleBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<VehicleController>(VehicleController());
  }
}
