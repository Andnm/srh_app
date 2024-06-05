import 'dart:async';
import 'dart:math';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_search_request.dart';
import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import '../../app/booking_status_type.dart';
import '../../pages/main/home/map/home_map_controller.dart';
import '../apis/driver_api.dart';
import '../entities/booking.dart';
import '../entities/search_request_model.dart';
import 'dialogs/alert_dialog.dart';

class CircleCountdownPainter extends CustomPainter {
  final double progress;

  CircleCountdownPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryText
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    canvas.drawCircle(center, radius, paint);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final progressAngle = 2 * pi * progress;

    // Tạo gradient với các sắc thái của màu xanh lam
    final blueShades = [
      Color(0xFF51AEF7), // Màu ban đầu
      Color(0xFF69BAF9), // Màu sáng hơn
      Color(0xFF81C6FB), // Màu sáng hơn nữa
      Color(0xFF99D2FD), // Màu sáng hơn
      Color(0xFFB1DEFF), // Màu sáng nhất // Màu sáng nhất
    ];
    final gradient = LinearGradient(
      colors: blueShades,
      stops: List.generate(
          blueShades.length, (index) => index / (blueShades.length - 1)),
    );

    // Tạo Path cho đường viền
    final path = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        progressAngle,
      );

    // Vẽ đường viền với gradient
    final shaderPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    canvas.drawPath(path, shaderPaint);
  }

  @override
  bool shouldRepaint(CircleCountdownPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class NotificationDialog extends StatefulWidget {
  final NotificationSearchRequestModel requestModel;

  const NotificationDialog({super.key, required this.requestModel});

  @override
  _NotificationDialogState createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  HomeController get homeController => Get.find<HomeController>();

  MapController get mapPageController => Get.find<MapController>();
  final _driverTripRequestTimeoutController = 20.obs;
  Timer? _countDownTimer;

  void _startCountDown() {
    const oneTickPerSecond = Duration(seconds: 1);
    _countDownTimer = Timer.periodic(oneTickPerSecond, (timer) async {
      _driverTripRequestTimeoutController.value =
          _driverTripRequestTimeoutController.value - 1;

      if (homeController.state.statusOfBooking.value == BOOKING_STATUS.ACCEPT) {
        timer.cancel();
        _driverTripRequestTimeoutController.value = 20;
      }

      if (_driverTripRequestTimeoutController.value == 0) {
        timer.cancel();

        await DriverAPI.isMissSearchRequest(
            customerId: (homeController
                .state.appBookingData.value?.searchRequest?.customerId));

        await homeController.updateStatusDriver(isOnline: false);
        Get.back();
        Get.dialog(
          CustomAlertDialog(
            content: "Bạn đã bỏ lỡ chuyến xe.",
            buttonText: "Đóng",
            onPressed: () {
              Get.back();
            },
          ),
        );

        _driverTripRequestTimeoutController.value = 20;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _driverTripRequestTimeoutController.value),
    );
    _animationController.reverse(from: 1.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _countDownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _startCountDown();
    return Obx(() {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
        backgroundColor: AppColors.whiteColor,
        child: Container(
          padding: EdgeInsets.all(10.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 5.h),
              SizedBox(
                width: 200.w,
                height: 200.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: CircleCountdownPainter(
                            progress: _animationController.value,
                          ),
                          size: Size(150.w, 150.h),
                        );
                      },
                    ),
                    Positioned(
                      width: 80.w,
                      height: 80.h,
                      child: Image.asset(
                        'assets/icons/icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.all(10.0.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/initial.png",
                          height: 10.h,
                          width: 10.w,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            widget.requestModel.pickupAddress ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 30.h,
                      thickness: 2.h,
                      color: AppColors.primaryText.withOpacity(0.05),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/final.png",
                          height: 10.h,
                          width: 10.w,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            widget.requestModel.dropOffAddress ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: AppColors.primaryText.withOpacity(0.05)),
              ),
              SizedBox(
                height: 30.h,
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.primaryText.withOpacity(0.05)),
                padding: EdgeInsets.all(10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                            homeController.getIconPath(
                                homeController.state.statusOfPayment.value),
                            height: 30.h,
                            width: 30.w,
                            fit: BoxFit.cover),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          homeController.state.statusOfPayment.value,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      homeController.formatCurrency.format(homeController
                          .state.appBookingData.value?.searchRequest?.price),
                      style: TextStyle(
                        color: AppColors.acceptColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: homeController.isResponsedBooking.value
                    ? null
                    : () async {
                        homeController.isResponsedBooking.value = true;
                        final bookingRequest = BookingRequestModel(
                          searchRequestId: widget.requestModel.id,
                          driverId: widget.requestModel.driverId,
                        );
                        await homeController.responseBooking(
                          bookingRequestModel: bookingRequest,
                        );
                        homeController.isResponsedBooking.value = false;
                        Get.back();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryElement,
                  minimumSize: Size(200.w, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: Text(
                  'Chấp nhận',
                  style:
                      TextStyle(fontSize: 18.sp, color: AppColors.dialogColor),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      );
    });
  }
}
