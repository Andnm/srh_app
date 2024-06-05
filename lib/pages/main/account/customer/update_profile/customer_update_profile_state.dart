import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CustomerUpdateProfileState {
  Rx<String> name = ''.obs;
  Rx<String> address = ''.obs;
  Rx<String> phoneNumber = ''.obs;
  Rx<String> avatar = ''.obs;
  Rx<String> gender = ''.obs;
  Rx<String> dob = ''.obs;

  Rx<bool> editMode = false.obs;
  Rx<String> errorDob = ''.obs;
  Rx<String> errorPhoneNumber = ''.obs;
  Rx<bool> hasError = false.obs;

// xử lý khi update image
  Rx<XFile> selectedAvatar = XFile("").obs;
  Rx<String> selectedAvatarBase64 = "".obs;
}
