import 'dart:async';

import 'package:get/get.dart';

class CustomerRegisterState {
  Rx<String> email = ''.obs;
  Rx<String> userName = ''.obs;
  Rx<String> name = ''.obs; //name lưu vào đây
  Rx<String> password = ''.obs;
  Rx<String> confirmPassword = ''.obs;

  Rx<bool> existEmail = false.obs;
}
