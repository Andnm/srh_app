import 'package:get/get.dart';

class DriverRegisterState {
  Rx<String> email = ''.obs;
  Rx<String> userName = ''.obs;
  Rx<String> password = ''.obs;
  Rx<String> confirmPassword = ''.obs;
}
