import 'package:get/get.dart';

import '../../account/customer/vehicle/vehicle_controller.dart';
import 'booked_person_controller.dart';

class BookedPersonBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<BookedPersonController>(BookedPersonController());
  }
}
