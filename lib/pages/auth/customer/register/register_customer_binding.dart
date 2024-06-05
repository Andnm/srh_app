import 'package:cus_dbs_app/pages/main/account/customer/update_identity_card/index.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_profile/index.dart';
import 'package:cus_dbs_app/pages/main/account/customer/vehicle/index.dart';
import 'package:get/get.dart';

import 'index.dart';

class CustomerRegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CustomerRegisterController>(CustomerRegisterController());
    Get.put<CustomerUpdateProfileController>(CustomerUpdateProfileController());
    Get.put<CustomerUpdateIdentityController>(
        CustomerUpdateIdentityController());

    Get.put<VehicleController>(VehicleController());
  }
}
