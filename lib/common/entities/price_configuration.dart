class PriceConfiguration {
  BaseFareFirst3km? baseFareFirst3km;
  BaseFareFirst3km? fareFerAdditionalKm;
  BaseFareFirst3km? driverProfit;
  BaseFareFirst3km? appProfit;
  PeakHours? peakHours;
  PeakHours? nightSurcharge;
  WaitingSurcharge? waitingSurcharge;
  BaseFareFirst3km? weatherFee;
  String? id;
  String? dateCreated;
  String? dateUpdated;
  bool? isDeleted;

  PriceConfiguration({
    this.baseFareFirst3km,
    this.fareFerAdditionalKm,
    this.driverProfit,
    this.appProfit,
    this.peakHours,
    this.nightSurcharge,
    this.waitingSurcharge,
    this.weatherFee,
    this.id,
    this.dateCreated,
    this.dateUpdated,
    this.isDeleted,
  });

  factory PriceConfiguration.fromJson(Map<String, dynamic> json) {
    return PriceConfiguration(
      baseFareFirst3km: json['baseFareFirst3km'] != null
          ? BaseFareFirst3km.fromJson(json['baseFareFirst3km'])
          : null,
      fareFerAdditionalKm: json['fareFerAdditionalKm'] != null
          ? BaseFareFirst3km.fromJson(json['fareFerAdditionalKm'])
          : null,
      driverProfit: json['driverProfit'] != null
          ? BaseFareFirst3km.fromJson(json['driverProfit'])
          : null,
      appProfit: json['appProfit'] != null
          ? BaseFareFirst3km.fromJson(json['appProfit'])
          : null,
      peakHours: json['peakHours'] != null
          ? PeakHours.fromJson(json['peakHours'])
          : null,
      nightSurcharge: json['nightSurcharge'] != null
          ? PeakHours.fromJson(json['nightSurcharge'])
          : null,
      waitingSurcharge: json['waitingSurcharge'] != null
          ? WaitingSurcharge.fromJson(json['waitingSurcharge'])
          : null,
      weatherFee: json['weatherFee'] != null
          ? BaseFareFirst3km.fromJson(json['weatherFee'])
          : null,
      id: json['id'],
      dateCreated: json['dateCreated'],
      dateUpdated: json['dateUpdated'],
      isDeleted: json['isDeleted'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (baseFareFirst3km != null) {
      data['baseFareFirst3km'] = baseFareFirst3km!.toJson();
    }
    if (fareFerAdditionalKm != null) {
      data['fareFerAdditionalKm'] = fareFerAdditionalKm!.toJson();
    }
    if (driverProfit != null) {
      data['driverProfit'] = driverProfit!.toJson();
    }
    if (appProfit != null) {
      data['appProfit'] = appProfit!.toJson();
    }
    if (peakHours != null) {
      data['peakHours'] = peakHours!.toJson();
    }
    if (nightSurcharge != null) {
      data['nightSurcharge'] = nightSurcharge!.toJson();
    }
    if (waitingSurcharge != null) {
      data['waitingSurcharge'] = waitingSurcharge!.toJson();
    }
    if (weatherFee != null) {
      data['weatherFee'] = weatherFee!.toJson();
    }
    data['id'] = id;
    data['dateCreated'] = dateCreated;
    data['dateUpdated'] = dateUpdated;
    data['isDeleted'] = isDeleted;
    return data;
  }

  @override
  String toString() {
    return 'PriceConfiguration{baseFareFirst3km: $baseFareFirst3km, fareFerAdditionalKm: $fareFerAdditionalKm, driverProfit: $driverProfit, appProfit: $appProfit, peakHours: $peakHours, nightSurcharge: $nightSurcharge, waitingSurcharge: $waitingSurcharge, weatherFee: $weatherFee, id: $id, dateCreated: $dateCreated, dateUpdated: $dateUpdated, isDeleted: $isDeleted}';
  }
}

class BaseFareFirst3km {
  int? price;
  bool? isPercent;

  BaseFareFirst3km({this.price, this.isPercent});

  factory BaseFareFirst3km.fromJson(Map<String, dynamic> json) {
    return BaseFareFirst3km(
      price: json['price'],
      isPercent: json['isPercent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'isPercent': isPercent,
    };
  }

  @override
  String toString() {
    return 'BaseFareFirst3km{price: $price, isPercent: $isPercent}';
  }
}

class PeakHours {
  String? time;
  int? price;
  bool? isPercent;

  PeakHours({this.time, this.price, this.isPercent});

  factory PeakHours.fromJson(Map<String, dynamic> json) {
    return PeakHours(
      time: json['time'],
      price: json['price'],
      isPercent: json['isPercent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'price': price,
      'isPercent': isPercent,
    };
  }

  @override
  String toString() {
    return 'PeakHours{time: $time, price: $price, isPercent: $isPercent}';
  }
}

class WaitingSurcharge {
  int? perMinutes;
  int? price;
  bool? isPercent;

  WaitingSurcharge({this.perMinutes, this.price, this.isPercent});

  factory WaitingSurcharge.fromJson(Map<String, dynamic> json) {
    return WaitingSurcharge(
      perMinutes: json['perMinutes'],
      price: json['price'],
      isPercent: json['isPercent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'perMinutes': perMinutes,
      'price': price,
      'isPercent': isPercent,
    };
  }

  @override
  String toString() {
    return 'WaitingSurcharge{perMinutes: $perMinutes, price: $price, isPercent: $isPercent}';
  }
}
