import 'package:cus_dbs_app/pages/auth/customer/register/index.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_identity_card/index.dart';
import 'package:cus_dbs_app/pages/main/account/customer/vehicle/index.dart';
import 'package:get/get.dart';

import 'index.dart';

class CustomerSignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CustomerUpdateIdentityController>(
        CustomerUpdateIdentityController());

    Get.put<CustomerSignInController>(CustomerSignInController());

    Get.put<CustomerRegisterController>(CustomerRegisterController());

    Get.put<CustomerUpdateIdentityController>(
        CustomerUpdateIdentityController());
    Get.put<VehicleController>(VehicleController());
  }
}
