import 'package:get/get.dart';

class MainState {
  RxInt tabSelected = 0.obs;

  RxString customerId = ''.obs;

  Rx<DateTime> selectedDay = DateTime.now().obs;

  RxBool isLoading = false.obs;

  RxBool isShowBottom = true.obs;

  RxInt chosenMonth = DateTime.now().month.obs;
  RxInt chosenYear = DateTime.now().year.obs;
  RxInt notiCount = 0.obs;
}
