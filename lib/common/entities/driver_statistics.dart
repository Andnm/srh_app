class YearlyDriverStatistics {
  String? bookingAcceptanceRate;
  String? bookingCancellationRate;
  String? bookingCompletionRate;
  List<int>? operationalMonths;

  YearlyDriverStatistics(
      {this.bookingAcceptanceRate,
      this.bookingCancellationRate,
      this.bookingCompletionRate,
      this.operationalMonths});

  YearlyDriverStatistics.fromJson(Map<String, dynamic> json) {
    bookingAcceptanceRate = json['bookingAcceptanceRate'];
    bookingCancellationRate = json['bookingCancellationRate'];
    bookingCompletionRate = json['bookingCompletionRate'];
    operationalMonths = json['operationalMonths'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingAcceptanceRate'] = this.bookingAcceptanceRate;
    data['bookingCancellationRate'] = this.bookingCancellationRate;
    data['bookingCompletionRate'] = this.bookingCompletionRate;
    data['operationalMonths'] = this.operationalMonths;
    return data;
  }

  @override
  String toString() {
    return 'YearlyDriverStatistics{bookingAcceptanceRate: $bookingAcceptanceRate, bookingCancellationRate: $bookingCancellationRate, bookingCompletionRate: $bookingCompletionRate, operationalMonths: $operationalMonths}';
  }
}

class MonthlyDriverStatistics {
  int? month;
  int? totalMoney;
  String? totalOperatingTime;
  int? totalTripsCompleted;
  int? totalTrips;
  List<DriverStatisticDayly?>? driverStatisticDayly;

  MonthlyDriverStatistics(
      {this.month,
      this.totalMoney,
      this.totalOperatingTime,
      this.totalTripsCompleted,
      this.totalTrips,
      this.driverStatisticDayly});

  MonthlyDriverStatistics.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    totalMoney = json['totalMoney'];
    totalOperatingTime = json['totalOperatingTime'];
    totalTripsCompleted = json['totalTripsCompleted'];
    totalTrips = json['totalTrips'];
    if (json['driverStatisticDayly'] != null) {
      driverStatisticDayly = <DriverStatisticDayly>[];
      json['driverStatisticDayly'].forEach((v) {
        driverStatisticDayly!.add(new DriverStatisticDayly.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['totalMoney'] = this.totalMoney;
    data['totalOperatingTime'] = this.totalOperatingTime;
    data['totalTripsCompleted'] = this.totalTripsCompleted;
    data['totalTrips'] = this.totalTrips;
    if (this.driverStatisticDayly != null) {
      data['driverStatisticDayly'] =
          this.driverStatisticDayly!.map((v) => v?.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'MonthlyDriverStatistics{month: $month, totalMoney: $totalMoney, totalOperatingTime: $totalOperatingTime, totalTripsCompleted: $totalTripsCompleted, totalTrips: $totalTrips, driverStatisticDayly: $driverStatisticDayly}';
  }
}

class DriverStatisticDayly {
  int? day;
  int? totalTrip;
  int? totalIncome;
  int? totalTripCompleted;
  String? totalOperatiingTime;

  DriverStatisticDayly(
      {this.day,
      this.totalTrip,
      this.totalIncome,
      this.totalOperatiingTime,
      this.totalTripCompleted});

  DriverStatisticDayly.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    totalTrip = json['totalTrip'];
    totalIncome = json['totalIncome'];
    totalTripCompleted = json['totalTripCompleted'];
    totalOperatiingTime = json['totalOperatiingTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['totalTrip'] = this.totalTrip;
    data['totalIncome'] = this.totalIncome;
    data['totalTripCompleted'] = this.totalTripCompleted;
    data['totalOperatiingTime'] = this.totalOperatiingTime;
    return data;
  }

  @override
  String toString() {
    return 'DriverStatisticDayly{day: $day, totalTrip: $totalTrip, totalIncome: $totalIncome, totalTripCompleted: $totalTripCompleted, totalOperatiingTime: $totalOperatiingTime}';
  }
}
