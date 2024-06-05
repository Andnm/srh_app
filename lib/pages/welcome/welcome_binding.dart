import 'package:get/get.dart';

import 'index.dart';
class WelcomeBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }

}