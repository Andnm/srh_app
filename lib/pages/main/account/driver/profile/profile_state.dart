import 'package:cus_dbs_app/common/entities/user_general.dart';
import 'package:get/get.dart';

class DriverProfileState {
  Rx<User> dataDriver = User().obs;

  Rx<bool> isPublicGender = true.obs;

  Rx<bool> editMode = false.obs;
  Rx<String> errorDob = ''.obs;
  Rx<String> errorPhoneNumber = ''.obs;
}
