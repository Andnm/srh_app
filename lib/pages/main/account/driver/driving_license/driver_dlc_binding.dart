import 'package:get/get.dart';

import 'index.dart';

class DriverDlcBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverDlcController>(
        () => DriverDlcController());
  }
}
