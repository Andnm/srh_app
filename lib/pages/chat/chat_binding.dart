import 'package:cus_dbs_app/pages/chat/chat_controller.dart';
import 'package:get/get.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ChatController>(ChatController());
  }
}
