import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cus_dbs_app/common/entities/wallet.dart';

import 'package:cus_dbs_app/common/methods/common_methods.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/index.dart';

import 'package:cus_dbs_app/values/colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/apis/search_request.dart';
import '../../../../../../common/entities/notification/notification_booking_request.dart';
import '../../../../../../common/widgets/new_rating_dialog.dart';
import '../../../../../../common/widgets/vehicle_services/service_item_list.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../values/booking.dart';
import '../../../../../../values/server.dart';
import '../../../../../chat/chat_view.dart';
import '../../../../account/payment/_widgets/selected_method_payment.dart';
import '../../../../booking/choose_vehicle_view.dart';
import '../../../../booking/for_other/booked_person_view.dart';
import '../../../../booking/widgets/cancel_reason_view.dart';

import '../../../../main/main_controller.dart';
import '../../../index.dart';
import '../home_customer.dart';

class CustomerWidget extends StatelessWidget {
  CustomerWidget({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isPending) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.find<MainController>().updateIsShowBottom(false);
        });
      }
      if (controller.isCancel) {
        if (Get.isBottomSheetOpen ?? false) {
          Get.back(); // Đóng CancelReasonPage nếu đang mở
        }
        controller.resetAppStatus();

        controller.state.appBookingData.value = NotificationBookingModel();
        Get.back();
      }
      if (controller.isComplete) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.resetAppStatus();
          Get.back();
          Get.dialog(
            Dialog(
              surfaceTintColor: AppColors.whiteColor,
              backgroundColor: AppColors.whiteColor,
              child: NewRatingDialog(
                bookingId: controller.state.appBookingData.value?.id ?? "",
              ),
            ),
          );
        });
      }

      // if (controller.isOnGoing) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     homeMapController.myLocationEnabled.value = false;
      //   });
      // } else {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     homeMapController.myLocationEnabled.value = true;
      //   });
      // }
      return SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            Positioned(
                right: 5.w,
                bottom: Get.height * 0.4,
                top: 0,
                child: buildLocationButton()),
            if (controller.isSearchRequest) ...[
              Positioned(
                left: 20.w,
                top: 0,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                    controller.resetAppStatus();
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                ),
              ),
            ],
            if (controller.isSearchRequest) ...[
              Positioned(
                top: 60.h,
                left: 20.w,
                right: 20.w,
                child: buildSearch(),
              ),
            ],
            if (controller.isShowDriver) ...[
              Positioned(
                bottom: 0.h,
                left: 0.w,
                right: 0.w,
                child: showDriver(),
              ),
            ],
            if (controller.isBooking) ...[
              SearchAnimatedWidget(),
            ],
            if (controller.isShowInfo) ...[
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(height: Get.height, child: buildDriverInfo()),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget buildSearch() => Container(
        decoration: BoxDecoration(
          color: AppColors.textFieldColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.green,
                      size: 10.0.sp, // Giảm kích thước icon
                    ),
                    // Giảm khoảng cách giữa icon và TextField
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          controller.updateSearchCustomer(true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.textFieldColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: TextField(
                              maxLines: 1,
                              controller: controller.textSearchPickCl,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 10.sp, // Giảm kích thước chữ
                                overflow: TextOverflow.ellipsis,
                              ),
                              decoration: InputDecoration(
                                hintText: "Chọn điểm đi",
                                border: InputBorder.none,
                                enabled: false,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical:
                                        4.h), // Giảm khoảng cách trên dưới
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 0.5.h, // Giảm chiều cao của Divider
                  thickness: 0.1.h,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 10.0.sp, // Giảm kích thước icon
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          controller.updateSearchCustomer(
                            false,
                            callSuccess: () {},
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.textFieldColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: TextField(
                              maxLines: 1,
                              controller: controller.textSearchDropOffCl,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 10.sp, // Giảm kích thước chữ
                                overflow: TextOverflow.ellipsis,
                              ),
                              decoration: InputDecoration(
                                hintText: "Chọn điểm đến",
                                border: InputBorder.none,
                                enabled: false,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical:
                                        4.h), // Giảm khoảng cách trên dưới
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget showDriver() {
    return SizedBox(
      height: Get.height,
      child: Stack(
        children: [
          ServiceDraggableWidget(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: DraggableBottomWidget(),
          ),
        ],
      ),
    );
  }

  Widget buildDriverInfo() {
    return DriverInfoDraggableWidget();
  }

  Widget buildLocationButton() => RawMaterialButton(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        onPressed: () {
          controller.mapPageController.updateCurrentCameraPosition();
        },
        elevation: 2.0,
        fillColor: AppColors.whiteColor,
        child: Icon(
          Icons.my_location,
          size: 20.0.sp,
        ),
        padding: EdgeInsets.all(8.0),
        constraints: BoxConstraints(
          minWidth: 50.0.w,
          minHeight: 50.0.h,
        ),
        shape: CircleBorder(),
      );

  Widget DriverInfoDraggableWidget() => DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 0.5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Center(
                      child: Container(
                        width: 50.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(""),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.getStatusBookingCustomer(),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Text(
                                  //   controller
                                  //           .mapPageController
                                  //           .state
                                  //           .tripDirectionDetailsInfo
                                  //           .value
                                  //           ?.durationTextString ??
                                  //       '',
                                  //   style: TextStyle(
                                  //     fontSize: 16.sp,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: AppColors.primaryElement,
                                  //   ),
                                  // ),
                                  controller.isAvailableEmergency
                                      ? InkWell(
                                          child: SvgPicture.asset(
                                            "assets/icons/emergency.svg",
                                            height: 50.h,
                                            width: 50.w,
                                          ),
                                          onTap: () {
                                            controller
                                                .showCustomerEmergencyActionsBottomSheet();
                                          },
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                            _buildVehicleCustomer(),
                          ],
                        ),
                      ),
                      DividerInfo(),
                      TripDetailWidget(),
                      DividerInfo(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Thông tin thanh toán",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 14.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Giá",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                Text(
                                    controller.formatCurrency.format(controller
                                        .state
                                        .appBookingData
                                        .value
                                        ?.searchRequest
                                        ?.price),
                                    style: TextStyle(fontSize: 14.sp)),
                              ],
                            ),
                            SizedBox(height: 14.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Khuyến mãi",
                                    style: TextStyle(fontSize: 14.sp)),
                                Text("0VND", style: TextStyle(fontSize: 14.sp)),
                              ],
                            ),
                            SizedBox(height: 14.h),
                            Divider(thickness: 0.5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                        controller.getIconPath(controller
                                            .state.statusOfPayment.value),
                                        height: 30.h,
                                        width: 30.w,
                                        fit: BoxFit.cover),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      controller.state.statusOfPayment.value,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  controller.formatCurrency.format(controller
                                      .state
                                      .appBookingData
                                      .value
                                      ?.searchRequest
                                      ?.price),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DividerInfo(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BookingCancelButton(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
  Widget _buildVehicleCustomer() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundImage: (controller.driverInfo?.avatar != null)
                ? NetworkImage(SERVER_API_URL + controller.driverInfo!.avatar!)
                : NetworkImage(
                    'https://t3.ftcdn.net/jpg/05/00/54/28/240_F_500542898_LpYSy4RGAi95aDim3TLtSgCNUxNlOlcM.jpg'),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.driverInfo?.name ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 14.sp),
                    SizedBox(width: 2.w),
                    Text(
                      "${controller.state.appBookingData.value?.driver?.star ?? 5.0}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primaryElement,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.chat, parameters: {
                    "messageTo": "${controller.driverInfo!.id!}"
                  });
                },
                child: Icon(Icons.message,
                    color: AppColors.primaryElement, size: 20.sp),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: CircleBorder(
                    side: BorderSide(color: AppColors.primaryElement),
                  ),
                  padding: EdgeInsets.all(10.w),
                ),
              ),
              SizedBox(width: 10.w),
              ElevatedButton(
                onPressed: () {
                  controller.showPhoneBottomSheet(
                      "${controller.driverInfo?.phoneNumber}");
                },
                child: Icon(Icons.phone,
                    color: AppColors.primaryElement, size: 20.sp),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: CircleBorder(
                    side: BorderSide(color: AppColors.primaryElement),
                  ),
                  padding: EdgeInsets.all(10.w),
                ),
              ),
            ],
          ),
        ],
      );
  Widget DraggableBottomWidget() => Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r),
            topRight: Radius.circular(15.r),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textFieldColor,
              blurRadius: 20,
              spreadRadius: 8,
            )
          ],
        ),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (controller.isBookByMySelfStatusForCustomer) {
                            controller.isBottomSheet.value = true;
                            Get.bottomSheet(
                              ChooseVehicleScreen(),
                              isScrollControlled: true,
                              enableDrag: false,
                              ignoreSafeArea: true,
                            );
                          } else {
                            controller.isBottomSheet.value = true;
                            Get.bottomSheet(
                              BookedPersonInformationPage(),
                              isScrollControlled: true,
                              enableDrag: false,
                              ignoreSafeArea: false,
                            );
                          }
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: controller.isBookByMySelfStatusForCustomer
                                  ? Image.network(
                                      SERVER_API_URL +
                                          controller.state.requestVehicle.value
                                              .imageUrl!,
                                      width: 50.w,
                                      height: 50.h,
                                      fit: BoxFit.cover,
                                      gaplessPlayback: true,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 50.w,
                                          height: 50.h,
                                          color: Colors.grey,
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: MemoryImage(controller
                                              .state
                                              .bookedOnBehalfVehicleImage
                                              .value!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.state.requestVehicle.value
                                            .licensePlate ??
                                        '',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    (controller.state.requestVehicle?.value
                                                .brand ??
                                            "") +
                                        " " +
                                        (controller.state.requestVehicle?.value
                                                .model ??
                                            ""),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.card_giftcard,
                              color: AppColors.primaryText),
                          label: Text(
                            'Ưu đãi',
                            style: TextStyle(color: AppColors.primaryText),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            // WalletBinding().dependencies();
                            Get.to(() => SelectedMethodPayment());
                          },
                          icon: Image.asset(
                              controller.walletController.state
                                  .selectedImagePathPaymentMethod.value,
                              height: 30.h,
                              width: 30.w,
                              fit: BoxFit.cover),
                          label: Text(
                            controller.walletController.state
                                .selectedPaymentMethod.value,
                            style: TextStyle(color: AppColors.primaryText),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.searchRequest();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 20.h),
                          backgroundColor: AppColors.primaryElement,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Tìm tài xế",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppColors.textFieldColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              controller.formatCurrency.format(
                                  controller.state.priceOfSearchRequest.value),
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.textFieldColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      );
  Widget ServiceDraggableWidget() => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 15.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Container(
                      width: 50.w,
                      height: 5.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [ServiceItemList()],
                  ),
                ],
              ),
            ),
          );
        },
      );
  Widget buildComplete() => Container(
        child: Text('Complete'),
      );
  Widget TripDetailWidget() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Chi tiết chuyến đi",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 14.h,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "Mã chuyến đi",
                style: TextStyle(fontSize: 14.sp),
              ),
              Row(
                children: [
                  Text(
                      "${controller.state.appBookingData.value?.id?.substring(0, 20)}",
                      style: TextStyle(fontSize: 14.sp)),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text:
                              controller.state.appBookingData.value?.id ?? ''));
                    },
                  ),
                ],
              )
            ]),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.green,
                      size: 24.0.sp,
                    ),
                    SizedBox(width: 18.w),
                    Expanded(
                      child: Text(
                        controller.state.appBookingData.value?.searchRequest
                                ?.pickupAddress ??
                            '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 24.0.sp,
                    ),
                    SizedBox(width: 18.w),
                    Expanded(
                      child: Text(
                        controller.state.appBookingData.value?.searchRequest
                                ?.dropOffAddress ??
                            '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

  Widget SearchAnimatedWidget() => Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Center(
          child: Container(
            color: Colors.grey[200],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(seconds: 2),
                      width: 150.w,
                      height: 150.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primaryElement.withOpacity(0.2),
                            AppColors.primaryElement.withOpacity(0)
                          ],
                          stops: [0.6, 1.0],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: 2),
                      width: 120.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primaryElement.withOpacity(0.3),
                            AppColors.primaryElement.withOpacity(0)
                          ],
                          stops: [0.6, 1.0],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: 2),
                      width: 90.w,
                      height: 90.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primaryElement.withOpacity(0.4),
                            AppColors.primaryElement.withOpacity(0)
                          ],
                          stops: [0.6, 1.0],
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 40.r,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        'assets/icons/icon.png',
                        width: 60.w,
                        height: 60.h,
                      ),
                    ),
                  ],
                ),
                SearchRequestCancelButton(),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryElement,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24.r),
                      bottomRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Center(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textFieldColor,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText('Đang tìm tài xế...'),
                        ],
                        isRepeatingAnimation: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  Widget BookingCancelButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.errorRed,
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 120.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        onPressed: controller.isAvailableCancel
            ? () {
                Get.dialog(
                  Dialog(
                    backgroundColor: AppColors.surfaceWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Xác nhận',
                            style: TextStyle(
                              fontSize: 20.0.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.0.h),
                          Text(
                            ((controller.state.customerPersonalInfo.priority ??
                                        2) <=
                                    1)
                                ? "Bạn đã hủy quá nhiều chuyến trước đó. Nếu hủy chuyến, bạn sẽ bị trừ 10% tổng số tiền của chuyến đi này. Hãy cân nhắc kỹ."
                                : 'Bạn có chắc chắn muốn hủy chuyến đi?',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.0.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Xử lý khi người dùng chọn "Không"
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(100.w, 40.h),
                                ),
                                child: const Text('Không'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Get.back();
                                  Get.bottomSheet(
                                    CancelReasonPage(),
                                    isScrollControlled: true,
                                    enableDrag: false,
                                    ignoreSafeArea: true,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(100.w, 40.h),
                                ),
                                child: const Text('Có'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  barrierDismissible: false,
                );
              }
            : null,
        child: Text(
          "Hủy chuyến",
          style: TextStyle(
              color: AppColors.textFieldColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold),
        ),
      );
  Widget SearchRequestCancelButton() => IconButton(
        iconSize: 30.sp,
        icon: const Icon(
          Icons.cancel,
          color: Colors.grey,
        ),
        onPressed: () {
          Get.dialog(
            Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Xác nhận',
                      style: TextStyle(
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0.h),
                    const Text(
                      'Bạn có chắc chắn muốn ngừng tìm kiếm tài xế?',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.0.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            minimumSize: Size(100.w, 40.h),
                          ),
                          child: const Text('Không'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            EasyLoading.show(
                                indicator: const CircularProgressIndicator(),
                                maskType: EasyLoadingMaskType.clear,
                                dismissOnTap: true);
                            await SearchRequestAPI
                                .cancelSearchRequestWithDriverId(
                              driverId: controller
                                  .state.requestSearchRequestModel.driverId,
                              searchRequestId:
                                  controller.state.requestSearchRequestModel.id,
                            );
                            EasyLoading.dismiss();
                            controller.resetAppStatus();
                            // Get.offAll(() => HomeCustomerPage());
                            Get.back();

                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: Size(100.w, 40.h),
                          ),
                          child: const Text('Có'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            barrierDismissible: false,
          );
        },
      );
  Widget DividerInfo() => Divider(
        height: 30.h,
        thickness: 10.h,
        color: Colors.grey[200],
      );
}
