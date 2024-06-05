import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import 'package:get/get.dart';

import '../account/customer/vehicle/vehicle_controller.dart';
import 'index.dart';

class ChooseVehicleBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<VehicleController>(VehicleController());
  }
}
