import 'package:cus_dbs_app/common/widgets/vehicle_services/service_item.dart';
import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../methods/common_methods.dart';

class ServiceItemList extends StatefulWidget {
  const ServiceItemList({Key? key}) : super(key: key);

  @override
  _ServiceItemListState createState() => _ServiceItemListState();
}

class _ServiceItemListState extends State<ServiceItemList> {
  int selectedIndex = 0;
  HomeController get homeController => Get.find<HomeController>();

  List<ServiceItem> getServices() {
    return [
      ServiceItem(
        icon: 'assets/icons/male-driver-icon.svg',
        name: "Tài xế ô tô",
        price: 0,
        isSelected: false,
        onPressed: () {},
      ),
      ServiceItem(
        icon: 'assets/icons/female-driver.svg',
        name: "Tài xế ô tô nữ",
        price: 0,
        isSelected: false,
        onPressed: () {},
      ),
    ];
  }

  void onItemPressed(int index) {
    setState(() {
      selectedIndex = index;
      if (selectedIndex == 0) {
        homeController.state.isFemaleDriver.value = false;
        print("${homeController.state.isFemaleDriver.value} MALE");
      } else if (selectedIndex == 1) {
        homeController.state.isFemaleDriver.value = true;
        print("${homeController.state.isFemaleDriver.value} FEMALE");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final services = getServices();

    return ListView.separated(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: services.length,
      itemBuilder: (BuildContext context, int index) {
        return ServiceItem(
          icon: services[index].icon,
          name: services[index].name,
          price: services[index].price,
          isSelected: selectedIndex == index,
          onPressed: () => onItemPressed(index),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: AppColors.primaryElement,
          height: 0,
          thickness: 0.2.h,
        );
      },
    );
  }
}
