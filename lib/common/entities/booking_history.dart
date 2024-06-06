import 'package:cus_dbs_app/common/entities/driver.dart';
import 'package:cus_dbs_app/common/entities/search_request_model.dart';

class BookingHistory {
  String? id;
  String? searchRequestId;
  String? driverId;
  String? checkInNote;
  String? pickUpTime;
  String? dropOffTime;
  String? status;
  SearchRequestModel? searchRequest;
  DriverItem? driver;
  String? dateCreated;

  BookingHistory({
    this.id,
    this.searchRequestId,
    this.driverId,
    this.checkInNote,
    this.pickUpTime,
    this.dropOffTime,
    this.status,
    this.searchRequest,
    this.driver,
    this.dateCreated,
  });

  BookingHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    searchRequestId = json['searchRequestId'];
    driverId = json['driverId'];
    checkInNote = json['checkInNote'];
    pickUpTime = json['pickUpTime'];
    dropOffTime = json['dropOffTime'];
    status = json['status'];
    searchRequest = json['searchRequest'] != null
        ? new SearchRequestModel.fromJson(json['searchRequest'])
        : null;
    driver =
        json['driver'] != null ? new DriverItem.fromJson(json['driver']) : null;
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['searchRequestId'] = this.searchRequestId;
    data['driverId'] = this.driverId;
    data['checkInNote'] = this.checkInNote;
    data['pickUpTime'] = this.pickUpTime;
    data['dropOffTime'] = this.dropOffTime;
    data['status'] = this.status;
    if (this.searchRequest != null) {
      data['searchRequest'] = this.searchRequest!.toJson();
    }
    if (this.driver != null) {
      data['driver'] = this.driver!.toJson();
    }
    data['dateCreated'] = this.dateCreated;

    return data;
  }
}

class BookingHistoryList {
  int? pageIndex;
  int? pageSize;
  int? totalPage;
  int? totalSize;
  int? pageSkip;
  List<BookingHistory>? data;

  BookingHistoryList(
      {this.pageIndex,
      this.pageSize,
      this.totalPage,
      this.totalSize,
      this.pageSkip,
      this.data});

  BookingHistoryList.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    totalSize = json['totalSize'];
    pageSkip = json['pageSkip'];
    if (json['data'] != null) {
      data = <BookingHistory>[];
      json['data'].forEach((v) {
        data!.add(new BookingHistory.fromJson(v));
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
