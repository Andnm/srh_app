import 'dart:ffi';

class NotificationPayment {
  String? id;
  User? user;
  int? totalMoney;

  NotificationPayment({this.id, this.user, this.totalMoney});

  NotificationPayment.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    totalMoney = json['TotalMoney'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    data['TotalMoney'] = this.totalMoney;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? phoneNumber;
  String? userName;
  String? email;
  String? address;
  num? star;
  String? avatar;
  int? gender;
  String? dob;
  bool? isPublicGender;
  bool? isActive;

  User(
      {this.id,
      this.name,
      this.phoneNumber,
      this.userName,
      this.email,
      this.address,
      this.star,
      this.avatar,
      this.gender,
      this.dob,
      this.isPublicGender,
      this.isActive});

  User.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    phoneNumber = json['PhoneNumber'];
    userName = json['UserName'];
    email = json['Email'];
    address = json['Address'];
    star = json['Star'];
    avatar = json['Avatar'];
    gender = json['Gender'];
    dob = json['Dob'];
    isPublicGender = json['IsPublicGender'];
    isActive = json['IsActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['PhoneNumber'] = this.phoneNumber;
    data['UserName'] = this.userName;
    data['Email'] = this.email;
    data['Address'] = this.address;
    data['Star'] = this.star;
    data['Avatar'] = this.avatar;
    data['Gender'] = this.gender;
    data['Dob'] = this.dob;
    data['IsPublicGender'] = this.isPublicGender;
    data['IsActive'] = this.isActive;
    return data;
  }
}
