import 'package:cus_dbs_app/common/entities/notification/notification_payment.dart';

class LinkedAccountModel {
  String? id;
  String? linkedImgUrl;
  String? accountNumber;
  String? type;
  String? brand;
  String? dateCreated;
  User? user;

  LinkedAccountModel({
    this.id,
    this.linkedImgUrl,
    this.accountNumber,
    this.type,
    this.brand,
    this.dateCreated,
    this.user,
  });

  LinkedAccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    linkedImgUrl = json['linkedImgUrl'];
    accountNumber = json['accountNumber'];
    type = json['type'];
    brand = json['brand'];
    dateCreated = json['dateCreated'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['linkedImgUrl'] = this.linkedImgUrl;
    data['accountNumber'] = this.accountNumber;
    data['type'] = this.type;
    data['brand'] = this.brand;
    data['dateCreated'] = this.dateCreated;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'LinkedAccountModel{id: $id, user: $user}';
  }
}

class BankModelList {
  String? code;
  String? desc;
  List<BankModel>? data;

  BankModelList({this.code, this.desc, this.data});

  BankModelList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    desc = json['desc'];
    if (json['data'] != null) {
      data = <BankModel>[];
      json['data'].forEach((v) {
        data!.add(new BankModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['desc'] = this.desc;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BankModel {
  int? id;
  String? name;
  String? code;
  String? bin;
  String? shortName;
  String? logo;
  int? transferSupported;
  int? lookupSupported;

  BankModel(
      {this.id,
      this.name,
      this.code,
      this.bin,
      this.shortName,
      this.logo,
      this.transferSupported,
      this.lookupSupported});

  BankModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    bin = json['bin'];
    shortName = json['shortName'];
    logo = json['logo'];
    transferSupported = json['transferSupported'];
    lookupSupported = json['lookupSupported'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['bin'] = this.bin;
    data['shortName'] = this.shortName;
    data['logo'] = this.logo;
    data['transferSupported'] = this.transferSupported;
    data['lookupSupported'] = this.lookupSupported;
    return data;
  }
}
