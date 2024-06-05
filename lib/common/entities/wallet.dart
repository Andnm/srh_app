import 'package:cus_dbs_app/common/entities/notification/notification_payment.dart';

class WalletModel {
  String? id;
  User? user;
  num? totalMoney;

  WalletModel({this.id, this.user, this.totalMoney});

  WalletModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    totalMoney = json['totalMoney'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['totalMoney'] = this.totalMoney;
    return data;
  }

  @override
  String toString() {
    return 'WalletModel{id: $id, user: $user, totalMoney: $totalMoney}';
  }
}

class WalletTransaction {
  String? id;
  num? totalMoney;
  String? typeWalletTransaction;
  String? paymentType;
  String? dateCreated;
  String? status;

  WalletTransaction({
    this.id,
    this.totalMoney,
    this.typeWalletTransaction,
    this.paymentType,
    this.dateCreated,
    this.status,
  });

  WalletTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalMoney = json['totalMoney'];
    typeWalletTransaction = json['typeWalletTransaction'];
    paymentType = json['paymentType'];
    dateCreated = json['dateCreated'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['totalMoney'] = this.totalMoney;
    data['typeWalletTransaction'] = this.typeWalletTransaction;
    data['paymentType'] = this.paymentType;
    data['dateCreated'] = this.dateCreated;
    data['status'] = this.status;
    return data;
  }
}

class WalletTransactionList {
  int? pageIndex;
  int? pageSize;
  int? totalPage;
  int? totalSize;
  int? pageSkip;
  List<WalletTransaction>? data;

  WalletTransactionList(
      {this.pageIndex,
      this.pageSize,
      this.totalPage,
      this.totalSize,
      this.pageSkip,
      this.data});

  WalletTransactionList.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalSize = json['totalSize'];
    pageSkip = json['pageSkip'];
    if (json['data'] != null) {
      data = <WalletTransaction>[];
      json['data'].forEach((v) {
        data!.add(new WalletTransaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;
    data['totalPage'] = this.totalPage;
    data['totalSize'] = this.totalSize;
    data['pageSkip'] = this.pageSkip;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

//class này chỉ để phục vụ mục đích tạo type cho cái filter history wallet transaction
class GroupedTransactions {
  String date;
  List<WalletTransaction> transactions;

  GroupedTransactions({
    required this.date,
    required this.transactions,
  });
}
