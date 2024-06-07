import 'package:cus_dbs_app/pages/main/account/customer/vehicle/index.dart';
import 'package:cus_dbs_app/pages/main/booking_history/booking_history_controller.dart';
import 'package:cus_dbs_app/pages/main/home/map/home_map_controller.dart';
import 'package:cus_dbs_app/utils/connectivity.dart';
import 'package:get/get.dart';

import '../home/index.dart';
import 'index.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MapController>(MapController());
    Get.put<HomeController>(HomeController());

    Get.lazyPut<MainController>(() => MainController());
  }
}
