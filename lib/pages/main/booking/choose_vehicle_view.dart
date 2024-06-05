import 'dart:convert';
import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cus_dbs_app/common/entities/vehicle.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../values/server.dart';
import '../account/customer/vehicle/_widget/add_new_vehicle.dart';
import '../account/customer/vehicle/vehicle_controller.dart';
import 'index.dart';

class ChooseVehicleScreen extends GetView<ChooseVehicleController> {
  RxInt selectedIndex = (-1).obs; // Mặc định chọn chiếc xe đầu tiên
  Rx<VehicleItem> vehicle = VehicleItem().obs;
  RxBool hasSelectedVehicle = false.obs;

  VehicleController get vehicleController => Get.find<VehicleController>();

  HomeController get homeController => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.surfaceWhite, //change your color here
        ),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            if (homeController.isBottomSheet.value) {
              homeController.isBottomSheet.value = false;
              Get.back();
            } else {
              Get.back();
            }
          },
        ),
        title: !homeController.isBottomSheet.value
            ? Text(
                'Đặt cá nhân',
                style: TextStyle(color: AppColors.surfaceWhite),
              )
            : SizedBox(),
        backgroundColor: AppColors.primaryElement,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SizedBox(
          height: Get.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
              Text('Thông tin phương tiện',
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.h),
              SizedBox(
                height: 150.h,
                child: Obx(() {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        vehicleController.state.dataVehicles.value.length + 1,
                    itemBuilder: (context, index) {
                      if (index <
                          vehicleController.state.dataVehicles.value.length) {
                        final item =
                            vehicleController.state.dataVehicles.value[index];
                        return Obx(() => GestureDetector(
                              onTap: () {
                                selectedIndex.value = index;
                                vehicle.value = item;
                                hasSelectedVehicle.value = true;
                              },
                              child: Container(
                                width: 150.w,
                                height: 150.h,
                                margin: EdgeInsets.only(right: 10.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                    ),
                                  ],
                                  border: Border.all(
                                    color: selectedIndex.value == index
                                        ? AppColors.primaryElement
                                        : Colors.transparent,
                                    width: 5.w,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    if (item.imageUrl != null)
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: Image.network(
                                          SERVER_API_URL + item.imageUrl!,
                                          width: 150.w,
                                          height: 150.h,
                                          fit: BoxFit.cover,
                                          gaplessPlayback: true,
                                          frameBuilder: (context, child, frame,
                                              wasSynchronouslyLoaded) {
                                            if (wasSynchronouslyLoaded) {
                                              return child;
                                            }
                                            return AnimatedOpacity(
                                              opacity: frame == null ? 0 : 1,
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.easeOut,
                                              child: child,
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: 150.w,
                                              height: 150.h,
                                              child: Center(
                                                child: Icon(Icons.error),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ));
                      } else {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => AddNewVehiclePage());
                          },
                          child: Container(
                            width: 150.w,
                            height: 150.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border:
                                  Border.all(color: AppColors.primaryElement),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: AppColors.primaryElement,
                                  size: 40.sp,
                                ),
                                SizedBox(height: 5.h),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                }),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: Obx(() {
                  return hasSelectedVehicle.value
                      ? ListView(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildCard(context, 'Nhãn hiệu',
                                      vehicle.value.brand ?? 'N/A', '(Brand)'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildCard(context, 'Số loại',
                                      vehicle.value.model ?? 'N/A', '(Model)'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildCard(context, 'Màu sắc',
                                      vehicle.value.color ?? 'N/A', '(Color)'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildCard(
                                    context,
                                    'Biển số đăng ký',
                                    vehicle.value.licensePlate ?? 'N/A',
                                    '(No. plate)', // Sử dụng cú pháp markdown cho superscript
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : SizedBox();
                }),
              ),
              SizedBox(height: 16.h),
              Obx(() {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
                    backgroundColor: AppColors.primaryElement,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textFieldColor,
                    ),
                  ),
                  onPressed: hasSelectedVehicle.value
                      ? () async {
                          homeController.state.requestVehicle.value =
                              vehicle.value;
                          if (homeController.isBottomSheet.value) {
                            homeController.isBottomSheet.value = false;
                            Get.back();
                          } else {
                            Get.toNamed(AppRoutes.mapCustomer);
                          }
                        }
                      : null,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, String value, String subtitle) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Text(
            value.toUpperCase(),
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
        ],
      ),
    );
  }
}
