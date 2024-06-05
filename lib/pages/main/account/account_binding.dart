import 'package:cus_dbs_app/pages/main/account/driver/statistics/index.dart';
import 'package:get/get.dart';

import 'index.dart';

class AccountBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountController>(() => AccountController());
  }
}
