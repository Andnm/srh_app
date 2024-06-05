import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:cus_dbs_app/app/booking_status_type.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'dart:math' as math;
import 'package:cus_dbs_app/values/colors.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../common/apis/driver_api.dart';
import '../../../../../../common/entities/booking_image.dart';
import '../../../../../../common/entities/notification/notification_booking_request.dart';
import '../../../../../../values/server.dart';
import '../../../../../chat/chat_view.dart';
import '../../../../booking/widgets/cancel_reason_view.dart';
import '../../../../main/main_controller.dart';
import '../../../index.dart';

class DriverWidget extends StatelessWidget {
  DriverWidget({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Obx(() {
          if (!controller.isPending) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.find<MainController>().updateIsShowBottom(false);
            });
          }
          if (controller.isCheckInOrOut) {
            controller.initCamera();
          }

          if (controller.isCancel) {
            if (Get.isBottomSheetOpen ?? false) {
              Get.back(); // Đóng CancelReasonPage nếu đang mở
            }
            controller.resetAppStatus();
            controller.state.appBookingData.value = NotificationBookingModel();
          }
          if (controller.isComplete) {
            controller.isCheckInApi.value = true;
            controller.isCaptured.value = false;
            controller.state.imageFiles.clear();
            controller.imageIndex.value = 0;
            controller.isDoneCaptured.value = false;
            controller.isFinishCheckOut.value = false;
            controller.resetAppStatus();
            Get.back();
          }
          // if (controller.isCheckIn || controller.isCheckOut) {
          //   controller.initCamera();
          // }

          if (controller.isCheckOut && !controller.isFinishCheckOut.value) {
            controller.isDoneCaptured.value = false;
          }

          return controller.isCheckInOrOut
              ? SingleChildScrollView(
                  child: SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: Stack(
                      children: [
                        if (controller.isShowInfo) ...[
                          Positioned(
                            right: 10.w,
                            bottom: Get.height * 0.6,
                            top: 0,
                            child: Container(
                              child: Row(
                                children: [
                                  RawMaterialButton(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onPressed: () {
                                      controller.mapPageController
                                          .updateCurrentCameraPosition();
                                    },
                                    elevation: 2.0,
                                    fillColor: AppColors.whiteColor,
                                    child: Icon(
                                      Icons.my_location,
                                      size: 20.0.sp,
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 50.0.w,
                                      minHeight: 50.0.h,
                                    ),
                                    padding: EdgeInsets.all(15.0.w),
                                    shape: CircleBorder(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: SizedBox(
                                height: Get.height, child: buildCustomerInfo()),
                          ),
                        ],
                        if ((controller.isCheckInOrOut &&
                                controller.isDoneCaptured == false ||
                            (controller.isOnGoing &&
                                controller.isDoneCaptured == false))) ...[
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: buildCameraInterface(orientation),
                          ),
                        ],
                        if (controller.isComplete) ...[
                          buildComplete(),
                        ],
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 10.w,
                        bottom: Get.height * 0.6,
                        top: 0,
                        child: Container(
                          child: Row(
                            children: [
                              RawMaterialButton(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                onPressed: () {
                                  controller.mapPageController
                                      .updateCurrentCameraPosition();
                                },
                                elevation: 2.0,
                                fillColor: AppColors.whiteColor,
                                child: Icon(
                                  Icons.my_location,
                                  size: 20.0.sp,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 50.0.w,
                                  minHeight: 50.0.h,
                                ),
                                padding: EdgeInsets.all(15.0.w),
                                shape: CircleBorder(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (controller.isShowOnOffDriver) ...[
                        Positioned(
                          bottom: 35.h,
                          left: 0,
                          right: 0,
                          child: buildWidgetStatus(),
                        ),
                      ],
                      if (controller.isShowInfo) ...[
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                              height: Get.height, child: buildCustomerInfo()),
                        ),
                      ],
                      if ((controller.isCheckInOrOut &&
                              controller.isDoneCaptured == false ||
                          (controller.isOnGoing &&
                              controller.isDoneCaptured == false))) ...[
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: buildCameraInterface(orientation),
                        ),
                      ],
                      if (controller.isComplete) ...[
                        buildComplete(),
                      ],
                    ],
                  ),
                );
        });
      },
    );
  }

  Widget buildCameraInterface(Orientation orientation) {
    return Stack(
      children: [
        SizedBox(
          height: Get.height * 0.9, // Chiếm 70% chiều cao của màn hình
          child: GetBuilder<HomeController>(
            builder: (controller) {
              if (controller.cameraController == null ||
                  !controller.cameraController!.value.isInitialized) {
                return Center(child: CircularProgressIndicator());
              } else {
                return CameraPreview(controller.cameraController!);
              }
            },
          ),
        ),
        Obx(
          () => controller.isCaptured.value &&
                  controller.state.imageFiles.value.isNotEmpty
              ? SizedBox(
                  height: Get.height * 0.9, // Chiếm 70% chiều cao của màn hình
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(
                      controller.cameraController!.description.lensDirection ==
                              CameraLensDirection.front
                          ? math.pi
                          : 0,
                    ),
                    child: Image.file(
                      controller.state.imageFiles.value.last,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : SizedBox(),
        ),
        Positioned(
          top: 40.h,
          left: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Obx(() {
              return Text(
                controller.imageTypes[controller.imageIndex.value],
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: Get.height *
                    0.3), // Chiếm tối đa 30% chiều cao của màn hình
            child: Container(
              color: AppColors.primaryText,
              child: SafeArea(
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      controller.isCaptured.value
                          ? Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.isCaptured.value = false;
                                  controller.state.imageFiles.value
                                      .removeLast();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.whiteColor.withOpacity(0.5),
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(24),
                                ),
                                child: Icon(
                                  Icons.replay,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            )
                          : Expanded(child: SizedBox()),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.isResponsedBooking.value
                              ? null
                              : () async {
                                  controller.isResponsedBooking.value = true;
                                  if (!controller.isCaptured.value) {
                                    await controller.pickImageFromCamera(
                                        controller.imageTypes[
                                            controller.imageIndex.value]);
                                  } else {
                                    print("Image Index tien: " +
                                        controller.imageIndex.value.toString());
                                    if (controller.imageIndex.value <
                                        controller.imageTypes.length - 1) {
                                      // Gọi API khi nhấn vào biểu tượng mũi tên tiến

                                      await controller.checkInAndOut();

                                      controller.isCaptured.value = false;
                                      controller.imageIndex.value++;
                                    } else {
                                      // Gọi API cho ảnh cuối cùng

                                      await controller.checkInAndOut();
                                      await controller.addNotes(
                                          isCheckIn:
                                              controller.isCheckInApi.value);

                                      // Xử lý khi đã chụp và gửi đủ số lượng ảnh
                                      // controller.responseBooking();
                                      controller.isDoneCaptured.value = true;
                                      controller.imageIndex.value = 0;
                                      controller.isCheckInApi.value = false;
                                      controller.isCaptured.value = false;

                                      controller.state.imageFiles.clear();
                                      if (controller.isCheckOut) {
                                        controller.isFinishCheckOut.value =
                                            true;
                                      }
                                      print(
                                          "CLEAR INPUT ${controller.imageIndex.value}");

                                      Get.back();
                                    }
                                  }
                                  controller.isResponsedBooking.value = false;
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !controller.isCaptured.value
                                ? AppColors.whiteColor.withOpacity(0.5)
                                : controller.imageIndex.value <
                                        controller.imageTypes.length - 1
                                    ? AppColors.primaryElement
                                    : AppColors.acceptColor,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(32.w),
                          ),
                          child: Icon(
                            !controller.isCaptured.value
                                ? Icons.camera_alt
                                : controller.imageIndex.value >=
                                        controller.imageTypes.length - 1
                                    ? Icons.check
                                    : Icons.arrow_forward,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                      controller.isCaptured.value
                          ? Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      controller.showCheckInOutNoteDialog();
                                    },
                                    icon: Icon(
                                      Icons.event_note,
                                      color: AppColors.whiteColor,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.primaryElement
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(child: SizedBox())
                      // ... (các nút replay, arrow, check, note)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWidgetStatus() => Container(
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusButtonWidget(),
            SizedBox(
              height: 14.h,
            ),
            _buildStatusTextWidget(),
          ],
        ),
      );

  Widget _buildStatusTextWidget() => Row(
        children: [
          Obx(
            () => Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 10.w), // Thêm margin để tạo khoảng trống
                padding: EdgeInsets.fromLTRB(20, 20, 20,
                    20), // Tăng padding để tạo không gian cho góc bo tròn
                decoration: BoxDecoration(
                  color: AppColors
                      .whiteColor, // Đổi màu nền để làm nổi bật góc bo tròn
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .start, // Căn giữa nội dung trong Container
                  children: [
                    Icon(
                      FontAwesomeIcons.solidCircle,
                      size: 10.0.sp,
                      color: controller.state.isAvailableDriver.value
                          ? AppColors.acceptColor
                          : AppColors.errorRed,
                    ),
                    SizedBox(
                      width: 5.sp,
                    ),
                    Text(
                      controller.state.isAvailableDriver.value
                          ? 'Đang trực tuyến'
                          : 'Đang ngoại tuyến',
                      style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildStatusButtonWidget() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RawMaterialButton(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              onPressed: () async {
                bool isOnline = !controller.state.isAvailableDriver.value;
                await controller.updateStatusDriver(isOnline: isOnline);
                controller.state.isAvailableDriver.value = isOnline;
              },
              elevation: 2.0,
              fillColor: controller.state.isAvailableDriver.value
                  ? AppColors.primaryElement
                  : AppColors.whiteColor,
              child: Icon(
                color: controller.state.isAvailableDriver.value
                    ? AppColors.whiteColor
                    : AppColors.primaryText,
                Icons.power_settings_new_outlined,
                size: 25.0.sp,
              ),
              padding: EdgeInsets.all(25.0.w),
              shape: CircleBorder(),
            ),
          ],
        ),
      );

  Widget buildCustomerInfo() => DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.whiteColor,
                  blurRadius: 15.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Center(
                    child: Container(
                      width: 50.w,
                      height: 5.h,
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
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
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: _buildVehicleCustomer(),
                            ),
                            DividerInfo(),
                            !controller.isBookByMySelfStatusForDriver
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0.w),
                                    child: _buildVehicleOnBehalfCustomer(),
                                  )
                                : SizedBox.shrink(),
                            !controller.isBookByMySelfStatusForDriver
                                ? DividerInfo()
                                : SizedBox.shrink(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: _buildTripDetailInfo(),
                            ),
                          ],
                        ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Giá"),
                                  Text(controller.formatCurrency.format(
                                      controller.state.appBookingData.value
                                          ?.searchRequest?.price)),
                                ],
                              ),
                              SizedBox(height: 14.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Khuyến mãi"),
                                  Text("0VND"),
                                ],
                              ),
                              SizedBox(height: 14.h),
                              Divider(thickness: 0.5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                  ),
                ),
              ],
            ),
          );
        },
      );

  Widget buildComplete() => SizedBox();

  Widget BookingCancelButton() => Obx(() {
        return ElevatedButton(
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
                      backgroundColor: AppColors.whiteColor,
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
                              ((controller.state.driverPersonalInfo.priority ??
                                          2) <=
                                      1)
                                  ? "Bạn đã hủy quá nhiều chuyến trước đó. Nếu hủy chuyến này, bạn sẽ bị trừ 10% tổng số tiền của chuyến đi này. Hãy cân nhắc kỹ."
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
                                    foregroundColor: AppColors.whiteColor,
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
                                    foregroundColor: AppColors.whiteColor,
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
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        );
      });

  Widget BookingResponseButton() => Obx(() {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryElement,
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 100.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          onPressed: controller.isResponsedBooking.value
              ? null
              : () async {
                  controller.isResponsedBooking.value = true;
                  await controller.responseBooking();
                  controller.isResponsedBooking.value = false;
                },
          child: Text(
            controller.getStatusBookingDriver(),
            style: TextStyle(color: AppColors.textFieldColor, fontSize: 16.sp),
            textAlign: TextAlign.center, // Căn giữa văn bản
            maxLines: 1,
          ),
        );
      });

  Widget _buildVehicleCustomer() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Thông tin người đặt",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.chat, parameters: {
                        "messageTo": "${controller.customerInfo!.id}"
                      });
                    },
                    child: Icon(Icons.message,
                        color: AppColors.primaryElement, size: 20.sp),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.whiteColor,
                      elevation: 0,
                      padding: EdgeInsets.all(10.w),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.showPhoneBottomSheet(
                          "${controller.driverInfo?.phoneNumber}");
                    },
                    child: Icon(Icons.phone,
                        color: AppColors.primaryElement, size: 20.sp),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.whiteColor,
                      elevation: 0,
                      padding: EdgeInsets.all(10.w),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 14.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundImage: (controller.customerInfo?.avatar != null)
                          ? NetworkImage(
                              SERVER_API_URL + controller.customerInfo!.avatar!)
                          : AssetImage('assets/images/avatarman.png')
                              as ImageProvider,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      controller.customerInfo?.name ?? '',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              controller.isBookByMySelfStatusForDriver
                  ? Expanded(
                      child: Column(
                        children: [
                          Text(
                            controller.state.appBookingData.value?.searchRequest
                                    ?.bookingVehicle?.licensePlate ??
                                '',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                          Text(
                            (controller
                                        .state
                                        .appBookingData
                                        .value
                                        ?.searchRequest
                                        ?.bookingVehicle
                                        ?.brand ??
                                    "") +
                                " " +
                                (controller
                                        .state
                                        .appBookingData
                                        .value
                                        ?.searchRequest
                                        ?.bookingVehicle
                                        ?.model ??
                                    "") +
                                " ",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Địa chỉ",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                          Text(
                            controller.customerInfo?.address ?? "Hồ Chí Minh",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ],
      );

  Widget _buildVehicleOnBehalfCustomer() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Thông tin người đi",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.showPhoneBottomSheet(
                      "${controller.customerOnBehalfInfo?.phoneNumber}");
                },
                child: Icon(Icons.phone,
                    color: AppColors.primaryElement, size: 20.sp),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.whiteColor,
                  elevation: 0,
                  padding: EdgeInsets.all(10.w),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 14.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundImage:
                        (controller.customerOnBehalfInfo?.imageUrl != null)
                            ? NetworkImage(
                                controller.customerOnBehalfInfo!.imageUrl!)
                            : AssetImage('assets/images/avatarman.png')
                                as ImageProvider,
                  ),
                  Text(
                    controller.customerOnBehalfInfo?.name ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    controller.state.appBookingData.value?.searchRequest
                            ?.bookingVehicle?.licensePlate ??
                        '',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  Text(
                    (controller.state.appBookingData.value?.searchRequest
                                ?.bookingVehicle?.brand ??
                            "") +
                        " " +
                        (controller.state.appBookingData.value?.searchRequest
                                ?.bookingVehicle?.model ??
                            "") +
                        " ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  Widget DividerInfo() => Divider(
        height: 30.h,
        thickness: 10.h,
        color: Colors.grey[200],
      );

  Widget _buildTripDetailInfo() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Chi tiết chuyến đi",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await controller.mapPageController.openMapDirection();
                },
                icon: Icon(Icons.map),
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
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                        text: controller.state.appBookingData.value?.id ?? ''));
                  },
                ),
              ],
            )
          ]),
          Row(
            children: [
              Image.asset(
                "assets/images/initial.png",
                height: 10.h,
                width: 10.w,
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
            children: [
              Image.asset(
                "assets/images/final.png",
                height: 10.h,
                width: 10.w,
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
          SizedBox(height: 16.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: BookingResponseButton()),
              controller.isOnGoing
                  ? InkWell(
                      child: SvgPicture.asset(
                        "assets/icons/emergency.svg",
                        height: 50.h,
                        width: 50.w,
                      ),
                      onTap: () {
                        controller.showDriverEmergencyActionsBottomSheet();
                      },
                    )
                  : SizedBox()
            ],
          ),
          SizedBox(height: 16.0.h),
        ],
      );
}
