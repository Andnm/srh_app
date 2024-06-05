import 'package:cus_dbs_app/pages/main/account/account_binding.dart';
import 'package:cus_dbs_app/pages/main/booking_history/index.dart';
import 'package:cus_dbs_app/pages/main/home/widget/customer/home_customer.dart';
import 'package:cus_dbs_app/pages/main/notification/index.dart';
import 'package:cus_dbs_app/pages/main/notification/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../global.dart';
import '../account/account_view.dart';
import '../booking_history/booking_history_page.dart';
import '../home/index.dart';
import 'index.dart';

class MainController extends GetxController {
  final state = MainState();
  HomeController homeController = HomeController();
  ScrollController myScrollController = ScrollController();

  @override
  Future<void> onInit() async {
    super.onInit();

    await Global.onNewToken();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    var data = Get.parameters;
    state.tabSelected.value =
        data['tabSelected'] != null ? int.parse(data['tabSelected']!) : 0;
  }

  @override
  void onReady() async {
    super.onReady();
  }

  void updateIsShowBottom(bool isShow) {
    state.isShowBottom.value = isShow;
  }

  void selectedTab(int index) {
    state.tabSelected.value = index;
  }

  Widget changedPage() {
    Widget content = Container();
    switch (state.tabSelected.value) {
      case 0:
        content =
            homeController.isDriver ? const HomePage() : HomeCustomerPage();
        break;
      case 1:
        BookingHistoryBinding().dependencies();
        content = BookingHistoryPage();
        break;
      case 2:
        NotificationBinding().dependencies();
        content = NotificationPage();
        break;
      case 3:
        AccountBinding().dependencies();
        content = const AccountPage();
        break;
    }
    return content;
  }

  Widget changeTitleAppbar() {
    Text content = const Text('');
    switch (state.tabSelected.value) {
      case 0:
        content = const Text('Home');
        break;
    }
    return content;
  }

  @override
  void onClose() {
    super.onClose();
    myScrollController.dispose();
  }
}
