import 'package:get/get.dart';

import 'index.dart';

class DriverRegisterBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<DriverRegisterController>(() => DriverRegisterController());
  }
}
