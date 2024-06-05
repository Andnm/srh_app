import 'package:get/get.dart';

class DriverSignInState {
  RxBool isObscured = true.obs;
  var verificationId = ''.obs;
  var phoneNumber = ''.obs;
  var canResend = false.obs;
  var secondsRemaining = 30.obs;
  Rx<String> email = ''.obs;
  Rx<String> password = ''.obs;
}
