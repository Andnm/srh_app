import 'package:get/get.dart';

import 'index.dart';

class StatisticsBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<StatisticsController>(StatisticsController());
  }
}
