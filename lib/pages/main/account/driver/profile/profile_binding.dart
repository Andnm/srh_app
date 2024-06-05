import 'package:get/get.dart';

import 'index.dart';

class DriverProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverProfileController>(
        () => DriverProfileController());
  }
}
