import 'package:cus_dbs_app/pages/main/main/index.dart';
import 'package:get/get.dart';
import 'notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NotificationController>(NotificationController());
    Get.put<MainController>(MainController());
  }
}
