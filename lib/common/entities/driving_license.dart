class DrivingLicense {
  String? id;
  String? driverId;
  String? type;
  String? issueDate;
  String? expiredDate;
  String? drivingLicenseNumber;

  DrivingLicense(
      {this.id, this.driverId, this.type, this.issueDate, this.expiredDate});

  DrivingLicense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driverId'];
    type = json['type'];
    issueDate = json['issueDate'];
    expiredDate = json['expiredDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driverId'] = this.driverId;
    data['type'] = this.type;
    data['issueDate'] = this.issueDate;
    data['expiredDate'] = this.expiredDate;
    return data;
  }
}

class DrivingLicenseImage {
  String? id;
  String? drivingLicenseId;
  bool? isFront;
  String? imageUrl;

  DrivingLicenseImage(
      {this.id, this.drivingLicenseId, this.isFront, this.imageUrl});

  DrivingLicenseImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    drivingLicenseId = json['drivingLicenseId'];
    isFront = json['isFront'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['drivingLicenseId'] = this.drivingLicenseId;
    data['isFront'] = this.isFront;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
