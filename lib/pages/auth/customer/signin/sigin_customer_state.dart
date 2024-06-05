import 'package:get/get.dart';

class CustomerSignInState {
  RxBool isObscured = true.obs;
  var verificationId = ''.obs;
  var phoneNumber = ''.obs;

  var canResend = false.obs;
  var secondsRemaining = 30.obs;
  Rx<String> email = ''.obs;
  Rx<String> password = ''.obs;

  Rx<String> name = ''.obs;
  Rx<String> dob = ''.obs;
  Rx<String> gender = ''.obs;

  Rx<String> errorDob = ''.obs;
  Rx<bool> hasError = false.obs;
  Rx<String> errorPhoneNumber = ''.obs;
  Rx<bool> existPhoneNumber = false.obs;  

  Rx<bool> isDisableButton = false.obs;

}
