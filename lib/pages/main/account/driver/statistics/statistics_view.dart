import 'package:cus_dbs_app/values/colors.dart';
import 'package:fl_chart/fl_chart.dart';
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
          return Padding(
            padding: EdgeInsets.all(5.0.w),
            child: Column(
              children: [
                // Thay thế Expanded bằng Row chứa hai Dropdown
                Row(
                  children: [
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _selectedYearWidget(),
                    ),
                  ],
                ),

                _buildDriverStatisticsByYear(),

                Row(
                  children: [
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _selectedMonthWidget(),
                    ),
                  ],
                ),
                _buildTotalMonthlyWidget(),
                SizedBox(height: 16.h),
                (controller.getDriverStatisticDayly ?? []).isEmpty
                    ? Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.primaryText.withOpacity(0.05)),
                          child: Center(
                            child: Text(
                              "Không có chuyến",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      AppColors.primaryText.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      )
                    : Expanded(child: _buildDriverStatisticsDailyList())
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDriverStatisticsDailyList() => GetBuilder<StatisticsController>(
        builder: (controller) {
          final month = controller.selectedMonth.value;
          final daysInMonth = controller.daysInMonth(month);
          return ListView.separated(
            itemCount: controller.getDriverStatisticDayly?.length ?? 0,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final day = controller.getDriverStatisticDayly?[index]?.day ??
                  DateTime.now().day;
              final year = controller.selectedYear.value;
              final date = DateTime(year, month, day);
              final dayOfWeek = controller.dayOfWeekNames[date.weekday - 1];
              final formattedDate =
                  '${dayOfWeek}, ${controller.formatDate(date)}';

              // Thay thế dữ liệu tĩnh bằng dữ liệu thực tế từ controller hoặc model
              final details =
                  '${controller.getDriverStatisticDayly?[index]?.totalTrip} | ${controller.getDriverStatisticDayly?[index]?.totalOperatiingTime}';
              final amount =
                  controller.getDriverStatisticDayly?[index]?.totalIncome ?? 0;

              return _buildDayItem(formattedDate, details, amount);
            },
          );
        },
      );
  Widget _buildTotalMonthlyWidget() => Column(
        children: [
          _buildTotalMoneyWidget(),
          _buildTotalTripAndCompletedTrip(),
        ],
      );

  Widget _buildTotalTripAndCompletedTrip() => Row(
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
                      "Số chuyến",
                      style: TextStyle(
                        color: AppColors.surfaceWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      "${controller.state.monthlyDriverStatistics.value.totalTrips}",
                      style: TextStyle(
                          color: AppColors.surfaceWhite,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold),
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
                  color: AppColors.acceptColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hoàn thành",
                      style: TextStyle(
                        color: AppColors.surfaceWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      "${controller.state.monthlyDriverStatistics.value.totalTripsCompleted} ",
                      style: TextStyle(
                          color: AppColors.surfaceWhite,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
  Widget _buildDriverStatisticsByYear() {
    final sections = [
      PieChartSectionData(
        value: double.tryParse(controller
                    .state.yearlyDriverStatistics.value.bookingAcceptanceRate
                    ?.replaceAll('%', '') ??
                '0') ??
            0,
        color: AppColors.acceptColor.withOpacity(0.8),
        radius: 60.r,
        title: controller
                .state.yearlyDriverStatistics.value.bookingAcceptanceRate ??
            "",
        titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.whiteColor,
        ),
        // titlePositionPercentageOffset: 0.6.w,
        showTitle: false,
        borderSide: BorderSide(
          color: AppColors.primaryText
              .withOpacity(0.1), // Lighter border color for elevation effect
          width: 2.w, // Width of the border
        ),
      ),
      PieChartSectionData(
        value: double.tryParse(controller
                    .state.yearlyDriverStatistics.value.bookingCancellationRate
                    ?.replaceAll('%', '') ??
                '0') ??
            0,
        color: AppColors.errorRed.withOpacity(0.8),
        radius: 60.r,
        title: controller
                .state.yearlyDriverStatistics.value.bookingCancellationRate ??
            "",
        titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.whiteColor,
        ),
        showTitle: false,
        // titlePositionPercentageOffset: 0.6.w,
        borderSide: BorderSide(
          color: AppColors.primaryText
              .withOpacity(0.1), // Lighter border color for elevation effect
          width: 1.w, // Width of the border
        ),
      ),
      PieChartSectionData(
        value: double.tryParse(controller
                    .state.yearlyDriverStatistics.value.bookingCompletionRate
                    ?.replaceAll('%', '') ??
                '0') ??
            0,
        color: AppColors.primaryElement.withOpacity(0.8),
        radius: 60.r,
        title: controller
                .state.yearlyDriverStatistics.value.bookingCompletionRate ??
            "",
        titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.whiteColor,
        ),
        // titlePositionPercentageOffset: 0.6.w,
        showTitle: false,
        borderSide: BorderSide(
          color: AppColors.primaryText
              .withOpacity(0.1), // Lighter border color for elevation effect
          width: 3.w, // Width of the border
        ),
      ),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              width: 100.w,
              height: 150.h,
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 2.r,
                    sectionsSpace: 0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(
                      AppColors.acceptColor.withOpacity(0.8),
                      "Chấp nhận",
                    ),
                    Text(controller.state.yearlyDriverStatistics.value
                            .bookingAcceptanceRate ??
                        "")
                  ],
                ),
                SizedBox(height: 5.h),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(
                      AppColors.errorRed.withOpacity(0.8),
                      "Hủy chuyến",
                    ),
                    Text(controller.state.yearlyDriverStatistics.value
                            .bookingCancellationRate ??
                        "")
                  ],
                ),
                SizedBox(height: 5.h),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(
                      AppColors.primaryElement.withOpacity(0.8),
                      "Hoàn thành",
                    ),
                    Text(controller.state.yearlyDriverStatistics.value
                            .bookingCompletionRate ??
                        "")
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String title) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.h,
          color: color,
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildDayItem(String date, String details, int amount) {
    return Container(
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
              Text(
                details,
                style: TextStyle(
                  color: AppColors.primaryText.withOpacity(0.8),
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

  Widget _selectedMonthWidget() => GetBuilder<StatisticsController>(
        builder: (controller) {
          return DropdownButton<int>(
            value: controller.selectedMonth.value,
            onChanged: (int? newValue) {
              controller.selectMonth(newValue!);
            },
            items: List.generate(12, (index) {
              final month = index + 1;
              return DropdownMenuItem<int>(
                value: month,
                child: Text('Tháng $month'),
              );
            }),
            underline: SizedBox.shrink(),
          );
        },
      );

  Widget _selectedYearWidget() => GetBuilder<StatisticsController>(
        builder: (controller) {
          final currentYear = DateTime.now().year;
          final years = List.generate(1, (index) => currentYear - index);
          return DropdownButton<int>(
            value: controller.selectedYear.value,
            onChanged: (int? newValue) {
              controller.selectedYear.value = newValue!;
              controller.getDriverStatisticsByYear(newValue);
            },
            items: years.map((year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(year.toString()),
              );
            }).toList(),
            underline: SizedBox.shrink(), // This line removes the border
          );
        },
      );

  Widget _buildTotalMoneyWidget() => Container(
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
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${controller.formatCurrency.format(controller.state.monthlyDriverStatistics.value.totalMoney ?? 0)}",
                        style: TextStyle(
                          color: AppColors.surfaceWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
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
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        controller.state.monthlyDriverStatistics.value
                                .totalOperatingTime ??
                            "0",
                        style: TextStyle(
                          color: AppColors.surfaceWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
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
