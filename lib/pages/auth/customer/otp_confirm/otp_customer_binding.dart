import 'package:get/get.dart';

import 'index.dart';
import 'otp_customer_controller.dart';

class OtpConfirmBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<OtpConfirmController>(() => OtpConfirmController());
  }
}
