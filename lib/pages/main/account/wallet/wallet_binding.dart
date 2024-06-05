import 'package:cus_dbs_app/pages/main/account/payment/index.dart';
import 'package:get/get.dart';

import 'index.dart';

class WalletBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletController>(() => WalletController());
    Get.put<LinkedAccountController>(LinkedAccountController());
  }
}
