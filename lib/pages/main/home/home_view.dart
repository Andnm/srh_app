import 'package:cus_dbs_app/pages/main/home/widget/customer/items/customer_widget.dart';
import 'package:cus_dbs_app/pages/main/home/widget/driver/items/driver_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'home_controller.dart';
import 'map/index.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          MapPage(),
          Obx(
            () => Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: (controller.isShowWidgets == true)
                    ? (controller.isDriver
                        ? DriverWidget(controller: controller)
                        : SafeArea(
                            bottom: false,
                            child: CustomerWidget(controller: controller)))
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
