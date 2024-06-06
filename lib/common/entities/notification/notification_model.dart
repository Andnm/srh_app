import 'dart:convert';

import 'package:cus_dbs_app/app/booking_status_type.dart';

import 'notification_booking_request.dart';
import 'notification_payment.dart';
import 'notification_search_request.dart';

class NotificationModel {
  bool? isDeleted;
  String? userId;
  String? dateUpdated;
  String? typeModel; //SearchRequest // Booking
  String? dateCreated;
  String? title;
  dynamic data;
  String? id;
  bool? seen;
  String? body;

  NotificationModel(
      {this.isDeleted,
      this.userId,
      this.dateUpdated,
      this.typeModel,
      this.dateCreated,
      this.title,
      this.data,
      this.id,
      this.seen,
      this.body});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    isDeleted = json['IsDeleted'] == true;
    userId = json['UserId'];
    dateUpdated = json['DateUpdated'];
    typeModel = json['TypeModel'];
    dateCreated = json['DateCreated'];
    title = json['Title'];
    // Parse the 'Data' field as a string and decode it into a JSON object
    data = json['Data'] != null
        ? (typeModel == NOTIFICATION_STATUS.SEARCHREQUEST.name
            ? NotificationSearchRequestModel.fromJson(jsonDecode(json['Data']))
            : (typeModel == NOTIFICATION_STATUS.BOOKING.name
                ? NotificationBookingModel.fromJson(jsonDecode(json['Data']))
                : (typeModel == NOTIFICATION_STATUS.WALLET_ADD_FUNDS.name
                    ? NotificationPayment.fromJson(jsonDecode(json['Data']))
                    : null)))
        : null;

    id = json['Id'];
    seen = json['Seen'] == true;
    body = json['Body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsDeleted'] = this.isDeleted;
    data['UserId'] = this.userId;
    data['DateUpdated'] = this.dateUpdated;
    data['TypeModel'] = this.typeModel;
    data['DateCreated'] = this.dateCreated;
    data['Title'] = this.title;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    data['Id'] = this.id;
    data['Seen'] = this.seen;
    data['Body'] = this.body;
    return data;
  }

  @override
  String toString() {
    return 'NotificationModel{isDeleted: $isDeleted, userId: $userId, dateUpdated: $dateUpdated, typeModel: $typeModel, dateCreated: $dateCreated, title: $title, data: $data, id: $id, seen: $seen, body: $body}';
  }
}

class NotificationEntity {
  String? id;
  bool? seen;
  dynamic? action;
  String? title;
  String? body;
  String? data;
  String? typeModel;
  String? dateCreated;
  String? dateUpdated;

  NotificationEntity(
      {this.id,
      this.seen,
      this.action,
      this.title,
      this.body,
      this.data,
      this.typeModel,
      this.dateCreated,
      this.dateUpdated});

  NotificationEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    seen = json['seen'];
    action = json['action'];
    title = json['title'];
    body = json['body'];
    data = json['data'];
    typeModel = json['typeModel'];
    dateCreated = json['dateCreated'];
    dateUpdated = json['dateUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['seen'] = this.seen;
    data['action'] = this.action;
    data['title'] = this.title;
    data['body'] = this.body;
    data['data'] = this.data;
    data['typeModel'] = this.typeModel;
    data['dateCreated'] = this.dateCreated;
    data['dateUpdated'] = this.dateUpdated;
    return data;
  }
}

class NotificationList {
  int? pageIndex;
  int? pageSize;
  int? totalPage;
  int? totalSize;
  int? pageSkip;
  List<NotificationEntity>? data;

  NotificationList(
      {this.pageIndex,
      this.pageSize,
      this.totalPage,
      this.totalSize,
      this.pageSkip,
      this.data});

  NotificationList.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalSize = json['totalSize'];
    pageSkip = json['pageSkip'];
    if (json['data'] != null) {
      data = <NotificationEntity>[];
      json['data'].forEach((v) {
        data!.add(new NotificationEntity.fromJson(v));
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
