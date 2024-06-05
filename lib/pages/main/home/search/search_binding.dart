import 'package:get/get.dart';

import 'index.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SearchBookingController>(SearchBookingController());
  }
}
