import 'package:get/get.dart';

import 'index.dart';

class DriverSignInBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<DriverSignInController>(() => DriverSignInController());
  }
}
