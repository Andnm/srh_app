import 'package:cus_dbs_app/pages/auth/customer/register/index.dart';
import 'package:cus_dbs_app/pages/main/account/account_controller.dart';
import 'package:get/get.dart';

import 'index.dart';

class CustomerUpdateProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CustomerUpdateProfileController>(CustomerUpdateProfileController());
    Get.put<CustomerRegisterController>(CustomerRegisterController());
    Get.put<AccountController>(AccountController());
  }
}
