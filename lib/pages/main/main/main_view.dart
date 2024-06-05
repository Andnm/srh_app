import 'package:cus_dbs_app/common/widgets/fab_bottom_app_bar.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

import 'index.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: Visibility(
          visible: controller.state.isShowBottom.value,
          child: MotionTabBar(
            initialSelectedTab: "Trang chủ",
            labels: const ["Trang chủ", "Lịch sử", "Thông báo", "Cá nhân"],
            icons: const [
              Icons.home,
              Icons.history,
              Icons.notifications,
              Icons.person
            ],
            badges: [
              null,
              null,
              controller.state.notiCount.value != 0
                  ? MotionBadgeWidget(
                      text: controller.state.notiCount.value.toString(),
                      textColor: Colors.white,
                      color: Colors.red,
                      size: 18,
                    )
                  : null,
              null,
            ],
            tabSize: 50,
            tabBarHeight: 55,
            textStyle: TextStyle(
              fontSize: 12,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w500,
            ),
            tabIconColor: AppColors.primaryElement,
            tabIconSize: 28.0,
            tabIconSelectedSize: 26.0,
            tabSelectedColor: AppColors.primaryElement,
            tabIconSelectedColor: AppColors.primaryBackground,
            tabBarColor: AppColors.primaryBackground,
            onTabItemSelected: (int value) {
              controller.selectedTab(value);
            },
          ),
        ),
        body: controller.changedPage(),
      ),
    );
  }
}
