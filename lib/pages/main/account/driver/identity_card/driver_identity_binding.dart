import 'package:get/get.dart';

import 'index.dart';

class DriverIdentityBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverIdentityController>(
        () => DriverIdentityController());
  }
}
