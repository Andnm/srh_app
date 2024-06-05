import 'package:cus_dbs_app/pages/main/account/customer/vehicle/index.dart';
import 'package:cus_dbs_app/pages/main/booking/for_other/booked_person_view.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/dialogs/alert_dialog.dart';
import '../../../../../values/booking.dart';
import '../../../../../values/colors.dart';
import '../../../../../values/roles.dart';
import '../../../main/main_controller.dart';

class HomeCustomerPage extends StatelessWidget {
  const HomeCustomerPage();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<MainController>().updateIsShowBottom(true);
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/header-image-home.png')),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServiceSection(),
                  SizedBox(height: 30.h),
                  _buildLinkedServicesSection(),
                  SizedBox(height: 30.h),
                  _buildSecureRideHomeServiceSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection() {
    return Container(
      padding: EdgeInsets.all(6.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dịch vụ cho thuê tài xế',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: AppColors.primaryElement,
            thickness: 0.8.h,
          ),
          SizedBox(height: 8.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildServiceItem('Đặt cá nhân', Icons.car_rental_rounded,
                  onPress: () {
                BookingTypes.isBookByMyself.value = true;
                Get.toNamed(AppRoutes.chooseVehicle);
              }),
              _buildServiceItem('Đặt hộ', Icons.drive_eta_rounded, onPress: () {
                print("HEHE");
                BookingTypes.isBookByMyself.value = false;
                Get.toNamed(AppRoutes.bookedPersonInfor);
              }),
              _buildServiceItem('Đặt đi tỉnh', Icons.location_on, onPress: () {
                Get.dialog(
                  CustomAlertDialog(
                    content: "Tính năng đang được cập nhập...",
                    buttonText: "Đóng",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedServicesSection() {
    return Container(
      padding: EdgeInsets.all(16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Các dịch vụ liên kết',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: AppColors.primaryElement,
            thickness: 0.8.h,
          ),
          SizedBox(height: 8.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildServiceItem('Đăng kiểm hộ', Icons.fact_check, onPress: () {
                Get.dialog(
                  CustomAlertDialog(
                    content: "Tính năng đang được cập nhập...",
                    buttonText: "Đóng",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                );
              }),
              _buildServiceItem('Bãi giữ xe', Icons.local_parking, onPress: () {
                Get.dialog(
                  CustomAlertDialog(
                    content: "Tính năng đang được cập nhập...",
                    buttonText: "Đóng",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildSecureRideHomeServiceSection() {
    return Container(
      padding: EdgeInsets.all(16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dịch vụ của "Secure Ride Home"',
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText),
          ),
          SizedBox(height: 16.0.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String text, IconData iconData, {onPress}) {
    return SizedBox(
      width: 100.w,
      child: Column(
        children: [
          InkWell(
            splashColor: AppColors.textFieldColor,
            onTap: onPress,
            child: Container(
              padding: EdgeInsets.all(16.0.w),
              decoration: BoxDecoration(
                color: AppColors.primaryElement,
                borderRadius: BorderRadius.circular(8.0.r),
              ),
              child: Icon(
                iconData,
                color: AppColors.textFieldColor,
                size: 20.0.sp,
              ),
            ),
          ),
          SizedBox(height: 8.0.h),
          Text(
            maxLines: 2,
            text,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
