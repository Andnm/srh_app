import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class StatisticsPage extends GetView<StatisticsController> {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Thống kê thu nhập',
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.primaryText,
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              _buildTotalMoneyWidget(),
              SizedBox(height: 20.h),
              SizedBox(
                height: 80.h,
                child: GetBuilder<StatisticsController>(
                  builder: (controller) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.scrollToSelectedMonth();
                    });
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 12,
                      itemExtent: 100.w,
                      controller: controller.scrollController,
                      itemBuilder: (context, index) {
                        final month = index + 1;
                        final isSelected =
                            controller.selectedMonth.value == month;
                        return InkWell(
                          onTap: () {
                            controller.selectMonth(month);
                          },
                          child: Container(
                            margin: EdgeInsets.all(5.w),
                            width: 100.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryElement
                                  : AppColors.textFieldColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'Tháng $month',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppColors.whiteColor
                                    : AppColors.primaryText,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
              controller.isWork
                  ? _buildDriverStatisticsByYear()
                  : SizedBox.shrink(),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        child: Text(
                          "${controller.state.monthlyDriverStatistics.value.totalTrips} Chuyến"
                              .toUpperCase(),
                          style: TextStyle(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp),
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(children: [
                    Container(
                      child: Text(
                        "${controller.state.monthlyDriverStatistics.value.totalTripsCompleted} Hoàn thành"
                            .toUpperCase(),
                        style: TextStyle(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                    ),
                  ]))
                ],
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: GetBuilder<StatisticsController>(
                  builder: (controller) {
                    final month = controller.selectedMonth.value;
                    final daysInMonth = controller.daysInMonth(month);
                    return (controller.getDriverStatisticDayly ?? []).isNotEmpty
                        ? ListView.separated(
                            itemCount:
                                controller.getDriverStatisticDayly?.length ?? 0,
                            separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (context, index) {
                              final day = controller
                                      .getDriverStatisticDayly?[index]?.day ??
                                  DateTime.now().day;
                              final year = controller.selectedYear.value;
                              final date = DateTime(year, month, day);
                              final dayOfWeek =
                                  controller.dayOfWeekNames[date.weekday - 1];
                              final formattedDate =
                                  '${dayOfWeek}, ${controller.formatDate(date)}';

                              // Thay thế dữ liệu tĩnh bằng dữ liệu thực tế từ controller hoặc model
                              final details =
                                  '${controller.getDriverStatisticDayly?[index]?.totalTrip} | ${controller.getDriverStatisticDayly?[index]?.totalOperatiingTime}';
                              final amount = controller
                                      .getDriverStatisticDayly?[index]
                                      ?.totalIncome ??
                                  0;

                              return _buildDayItem(
                                  formattedDate, details, amount);
                            },
                          )
                        : Center(
                            child: Container(
                              child: Text(
                                "Thất nghiệp",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        AppColors.primaryText.withOpacity(0.5)),
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDriverStatisticsByYear() => Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: AppColors.acceptColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${controller.state.yearlyDriverStatistics.value.bookingAcceptanceRate ?? 0}",
                        style: TextStyle(
                          color: AppColors.acceptColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Nhận đơn",
                        style: TextStyle(
                          color: AppColors.acceptColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${controller.state.yearlyDriverStatistics.value.bookingCancellationRate ?? 0}",
                        style: TextStyle(
                          color: AppColors.errorRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Hủy đơn",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${controller.state.yearlyDriverStatistics.value.bookingCompletionRate ?? 0}",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Hoàn thành",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildDayItem(String date, String details, int amount) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                details,
                style: TextStyle(
                  color: AppColors.primaryText.withOpacity(0.6),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          Text(
            controller.formatCurrency.format(amount),
            style: TextStyle(
              color: AppColors.acceptColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalMoneyWidget() => Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.h),
        child: Row(
          children: [
            Expanded(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: AppColors.acceptColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Thu nhập ròng",
                        style: TextStyle(
                            color: AppColors.surfaceWhite,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "${controller.formatCurrency.format(controller.state.monthlyDriverStatistics.value.totalMoney ?? 0)}",
                        style: TextStyle(
                          color: AppColors.surfaceWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryElement,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tổng số giờ chạy",
                        style: TextStyle(
                            color: AppColors.surfaceWhite,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        controller.state.monthlyDriverStatistics.value
                                .totalOperatingTime ??
                            "0",
                        style: TextStyle(
                          color: AppColors.surfaceWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
