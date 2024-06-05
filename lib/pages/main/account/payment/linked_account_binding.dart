import 'package:cus_dbs_app/pages/main/account/wallet/wallet_controller.dart';
import 'package:get/get.dart';

import 'index.dart';

class LinkedAccountBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<LinkedAccountController>(LinkedAccountController());
  }
}
