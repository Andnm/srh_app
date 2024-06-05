import 'package:get/get.dart';

class DriverProfileState {
  Rx<String> name = ''.obs;
  Rx<String> address = ''.obs;
  Rx<String> phoneNumber = ''.obs;
  Rx<String> gender = ''.obs;
  Rx<String> dob = ''.obs;
  Rx<String> email = ''.obs;
  Rx<bool> isPublicGender = false.obs;

  Rx<bool> editMode = false.obs;
  Rx<String> errorDob = ''.obs;
  Rx<String> errorPhoneNumber = ''.obs;
}
