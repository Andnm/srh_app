import 'package:cus_dbs_app/pages/main/account/customer/vehicle/index.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/index.dart';
import 'package:cus_dbs_app/pages/main/booking_history/booking_history_controller.dart';
import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import 'package:cus_dbs_app/pages/main/home/map/home_map_controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<MapController>(() => MapController());
    Get.put<HomeController>(HomeController());
    Get.lazyPut<WalletController>(() => WalletController());
  }
}
