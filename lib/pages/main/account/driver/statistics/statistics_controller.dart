import 'package:cus_dbs_app/pages/main/account/driver/statistics/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../common/apis/driver_api.dart';
import '../../../../../common/entities/driver_statistics.dart';

class StatisticsController extends GetxController {
  StatisticsController();
  final state = StatisticsState();
  List<DriverStatisticDayly?>? get getDriverStatisticDayly =>
      state.monthlyDriverStatistics.value.driverStatisticDayly;

  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
  ScrollController scrollController = ScrollController();
  RxInt selectedMonth = 0.obs;
  RxInt selectedYear = DateTime.now().year.obs;
  DateTime now = DateTime.now();

  bool get isWork => state.monthlyDriverStatistics.value.totalMoney != 0;

  List<String> dayOfWeekNames = [
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ Nhật'
  ];

  @override
  void onInit() async {
    super.onInit();
    selectedMonth.value = DateTime.now().month;

    await getDriverStatisticsByYear(selectedYear.value);
    await selectMonth(selectedMonth.value);
  }

  Future<void> getDriverStatisticsByYear(int year) async {
    try {
      YearlyDriverStatistics response =
          await DriverAPI.getStatisticsByYear(year: year);
      print("Driver statistics by year ${response.toString()}");
      state.yearlyDriverStatistics.value = response;
    } catch (e) {
      print("Error to get statistics by year: " + e.toString());
    }
  }

  Future<void> getDriverMonthlyStatistics(int month, int year) async {
    try {
      MonthlyDriverStatistics response =
          await DriverAPI.getDriverMonthlyStatistics(month: month, year: year);
      print("Driver monthly statistics ${response.toString()}");
      state.monthlyDriverStatistics.value = response;
      state.monthlyDriverStatistics.value.driverStatisticDayly =
          response.driverStatisticDayly;
      update();
    } catch (e) {
      print("Error to get monthly statistics : " + e.toString());
    }
  }

  Future<void> selectMonth(int month) async {
    selectedMonth.value = month;
    await getDriverMonthlyStatistics(selectedMonth.value, selectedYear.value);
    update();
  }

  int daysInMonth(int month) {
    final currentYear = DateTime.now().year;
    return DateTime(currentYear, month + 1, 0).day;
  }

  void scrollToSelectedMonth() {
    final selectedMonthIndex = selectedMonth.value - 1;
    final itemWidth = 100.0; // Chiều rộng của mỗi item tháng
    final screenWidth = Get.width;
    final scrollOffset =
        selectedMonthIndex * itemWidth - (screenWidth - itemWidth) / 2;

    scrollController.animateTo(
      scrollOffset,
      duration: Duration(milliseconds: 500), // Thời gian animation
      curve: Curves.easeInOut, // Đường cong animation
    );
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void onClose() {
    super.onClose();
  }
}
