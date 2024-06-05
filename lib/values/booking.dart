import 'package:get/get.dart';

class BookingTypes {
  static RxBool isBookByMyself = false.obs;
  static bool get getBookByMyselfStatus => isBookByMyself.value;
  static String get getBookForSomeOneStatus => "Someone";
}
