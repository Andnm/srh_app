import 'package:get/get.dart';

import '../../../../../common/entities/driver_statistics.dart';

class StatisticsState {
  Rx<YearlyDriverStatistics> yearlyDriverStatistics =
      YearlyDriverStatistics().obs;
  Rx<MonthlyDriverStatistics> monthlyDriverStatistics =
      MonthlyDriverStatistics().obs;
}
