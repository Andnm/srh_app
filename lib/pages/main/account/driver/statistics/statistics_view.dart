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
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        title: Text(
          'Thống kê thu nhập',
          style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold),
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
          return ListView.builder(
            itemCount: controller.getDriverStatisticDayly?.length ?? 0,
            itemBuilder: (context, index) {
              final day = controller.getDriverStatisticDayly?[index]?.day ??
                  DateTime.now().day;
              final year = controller.selectedYear.value;
              final date = DateTime(year, month, day);
              final dayOfWeek = controller.dayOfWeekNames[date.weekday - 1];
              final formattedDate =
                  '${dayOfWeek}, ${controller.formatDate(date)}';

              final totalTripCompleted = controller
                      .getDriverStatisticDayly?[index]?.totalTripCompleted ??
                  0;
              final totalTrip =
                  controller.getDriverStatisticDayly?[index]?.totalTrip ?? 0;
              final totalOperatingTime = controller
                      .getDriverStatisticDayly?[index]?.totalOperatiingTime ??
                  '';
              final amount =
                  controller.getDriverStatisticDayly?[index]?.totalIncome ?? 0;

              return _buildDayItem(formattedDate, totalTripCompleted, totalTrip,
                  totalOperatingTime, amount);
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
                  color: Color(0xFFFFC72C),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tổng số chuyến",
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
                  color: Color(0xFF007FFF),
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
    final barGroups = [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: double.tryParse(controller.state.yearlyDriverStatistics.value
                        .bookingAcceptanceRate
                        ?.replaceAll('%', '') ??
                    '0') ??
                0,
            color: Color(0xFF03C03C),
            width: 30.w,
            borderRadius: BorderRadius.circular(5.r),
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: double.tryParse(controller.state.yearlyDriverStatistics.value
                        .bookingCancellationRate
                        ?.replaceAll('%', '') ??
                    '0') ??
                0,
            color: AppColors.errorRed.withOpacity(0.8),
            width: 30.w,
            borderRadius: BorderRadius.circular(5.r),
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: double.tryParse(controller.state.yearlyDriverStatistics.value
                        .bookingCompletionRate
                        ?.replaceAll('%', '') ??
                    '0') ??
                0,
            color: Color(0xFF007FFF),
            width: 30.w,
            borderRadius: BorderRadius.circular(5.r),
          ),
        ],
      ),
    ];

    return Container(
      width: 300.w,
      height: 220.h,
      padding: EdgeInsets.all(10.w),
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
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 10.sp,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        switch (value.toInt()) {
                          case 0:
                            return Text(
                              controller.state.yearlyDriverStatistics.value
                                      .bookingAcceptanceRate ??
                                  '',
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 10.sp,
                              ),
                            );
                          case 1:
                            return Text(
                              controller.state.yearlyDriverStatistics.value
                                      .bookingCancellationRate ??
                                  '',
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 10.sp,
                              ),
                            );
                          case 2:
                            return Text(
                              controller.state.yearlyDriverStatistics.value
                                      .bookingCompletionRate ??
                                  '',
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 10.sp,
                              ),
                            );
                          default:
                            return Text('');
                        }
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.primaryText.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(
                Color(0xFF03C03C),
                'Chấp nhận',
                controller.state.yearlyDriverStatistics.value
                        .bookingAcceptanceRate ??
                    '',
              ),
              _buildLegendItem(
                AppColors.errorRed.withOpacity(0.8),
                'Hủy',
                controller.state.yearlyDriverStatistics.value
                        .bookingCancellationRate ??
                    '',
              ),
              _buildLegendItem(
                Color(0xFF007FFF),
                'Hoàn thành',
                controller.state.yearlyDriverStatistics.value
                        .bookingCompletionRate ??
                    '',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String title, String value) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildDayItem(String date, int totalTripCompleted, int totalTrip,
      String totalOperatingTime, int amount) {
    return Card(
      color: AppColors.surfaceWhite,
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
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
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Text(
                  controller.formatCurrency.format(amount),
                  style: TextStyle(
                    color: AppColors.acceptColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          children: [
            Container(
              padding: EdgeInsets.all(16.0.w),
              child: _buildDetails(
                  totalTripCompleted, totalTrip, totalOperatingTime),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(
      int totalTripCompleted, int totalTrip, String totalOperatingTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tổng số chuyến: $totalTrip',
              style: TextStyle(
                color: AppColors.primaryText.withOpacity(0.8),
                fontSize: 12.sp,
              ),
            ),
            Text(
              'Hoàn thành: $totalTripCompleted ',
              style: TextStyle(
                color: AppColors.primaryText.withOpacity(0.8),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Tổng thời gian hoạt động: ',
              style: TextStyle(
                color: AppColors.primaryText.withOpacity(0.8),
                fontSize: 12.sp,
              ),
            ),
            Text(
              totalOperatingTime,
              style: TextStyle(
                color: AppColors.primaryText.withOpacity(0.8),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
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
                color: AppColors.acceptColor
                    .withOpacity(0.1), // Background color with transparency
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Color(
                        0xFF32de84), // Solid color for the content container
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Thu nhập ròng",
                        style: TextStyle(
                          color: AppColors
                              .surfaceWhite, // Slightly darker text color
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${controller.formatCurrency.format(controller.state.monthlyDriverStatistics.value.totalMoney ?? 0)}",
                        style: TextStyle(
                          color: AppColors
                              .surfaceWhite, // Slightly darker text color
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
                color: AppColors.primaryElement
                    .withOpacity(0.2), // Background color with transparency
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Color(
                        0xFFFF0090), // Solid color for the content container
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tổng số giờ chạy",
                        style: TextStyle(
                          color: AppColors
                              .surfaceWhite, // Slightly darker text color
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        controller.state.monthlyDriverStatistics.value
                                .totalOperatingTime ??
                            "0",
                        style: TextStyle(
                          color: AppColors
                              .surfaceWhite, // Slightly darker text color
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
