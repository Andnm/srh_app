import 'dart:io';

import 'package:cus_dbs_app/common/entities/search_request_model.dart';
import 'package:cus_dbs_app/common/entities/user_general.dart';

import 'driver.dart';
import 'notification/notification_booking_request.dart';

class BookingItem {
  BookingItem({
    String? id,
    String? searchRequestId,
    String? driverId,
    String? status,
    SearchRequestModel? searchRequest,
    DriverItem? driver,
  }) {
    _id = id;
    _searchRequestId = searchRequestId;
    _driverId = driverId;
    _status = status;
    _searchRequest = searchRequest;
    _driver = driver;
  }

  BookingItem.fromJson(dynamic json) {
    _id = json['id'];
    _searchRequestId = json['searchRequestId'];
    _driverId = json['driverId'];
    _status = json['status'];
    _searchRequest = json['searchRequest'] != null
        ? SearchRequestModel.fromJson(json['searchRequest'])
        : null;
    _driver =
        json['driver'] != null ? DriverItem.fromJson(json['driver']) : null;
  }

  String? _id;
  String? _searchRequestId;
  String? _driverId;
  String? _status;
  SearchRequestModel? _searchRequest;
  DriverItem? _driver;

  BookingItem copyWith({
    String? id,
    String? searchRequestId,
    String? driverId,
    String? status,
    SearchRequestModel? searchRequest,
    DriverItem? driver,
  }) =>
      BookingItem(
        id: id ?? _id,
        searchRequestId: searchRequestId ?? _searchRequestId,
        driverId: driverId ?? _driverId,
        status: status ?? _status,
        searchRequest: searchRequest ?? _searchRequest,
        driver: driver ?? _driver,
      );

  String? get id => _id;

  String? get searchRequestId => _searchRequestId;

  String? get driverId => _driverId;

  String? get status => _status;

  SearchRequestModel? get searchRequest => _searchRequest;

  DriverItem? get driver => _driver;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['searchRequestId'] = _searchRequestId;
    map['driverId'] = _driverId;
    map['status'] = _status;
    if (_searchRequest != null) {
      map['searchRequest'] = _searchRequest?.toJson();
    }
    if (_driver != null) {
      map['driver'] = _driver?.toJson();
    }
    return map;
  }

  @override
  String toString() {
    return 'BookingItem{_id: $_id, _searchRequestId: $_searchRequestId, _driverId: $_driverId, _status: $_status, _searchRequest: $_searchRequest, _driver: $_driver}';
  }
}

class BookingRequestModel {
  String? id;

  String? searchRequestId;
  String? driverId;
  String? bookingStatus;

  BookingRequestModel(
      {this.id, this.searchRequestId, this.driverId, this.bookingStatus});

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) =>
      BookingRequestModel(
        id: json['bookingId'],
        searchRequestId: json["searchRequestId"],
        driverId: json["driverId"],
        bookingStatus: json["bookingStatus"],
      );

  Map<String, dynamic> toJson() => {
        'bookingId': id,
        "searchRequestId": searchRequestId,
        "driverId": driverId,
        'bookingStatus': bookingStatus,
      };

  Map<String, dynamic> toBookingJson() =>
      {'driverId': driverId, 'searchRequestId': searchRequestId};

  Map<String, dynamic> toChangeStatusBookingJson() => {'bookingId': id};

  @override
  String toString() {
    return 'BookingRequestModel{id: $id, searchRequestId: $searchRequestId, driverId: $driverId, bookingStatus: $bookingStatus}';
  }
}

class CustomerBooking {
  CustomerBooking({
    num? pageIndex,
    num? pageSize,
    num? totalPage,
    num? totalSize,
    num? pageSkip,
    List<BookingData>? data,
  }) {
    _pageIndex = pageIndex;
    _pageSize = pageSize;
    _totalPage = totalPage;
    _totalSize = totalSize;
    _pageSkip = pageSkip;
    _data = data;
  }

  CustomerBooking.fromJson(dynamic json) {
    _pageIndex = json['pageIndex'];
    _pageSize = json['pageSize'];
    _totalPage = json['totalPage'];
    _totalSize = json['totalSize'];
    _pageSkip = json['pageSkip'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(BookingData.fromJson(v));
      });
    }
  }

  num? _pageIndex;
  num? _pageSize;
  num? _totalPage;
  num? _totalSize;
  num? _pageSkip;
  List<BookingData>? _data;

  num? get pageIndex => _pageIndex;

  num? get pageSize => _pageSize;

  num? get totalPage => _totalPage;

  num? get totalSize => _totalSize;

  num? get pageSkip => _pageSkip;

  List<BookingData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pageIndex'] = _pageIndex;
    map['pageSize'] = _pageSize;
    map['totalPage'] = _totalPage;
    map['totalSize'] = _totalSize;
    map['pageSkip'] = _pageSkip;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "b1e88fac-644c-47de-9e1d-2cc7326084ef"
/// searchRequestId : "ff53da9e-340f-4d11-a8dc-9763296339e7"
/// driverId : "eec30162-ddbd-4b1b-ab96-b419ad7fd61d"
/// status : "Pending"
/// searchRequest : {"customerId":"22f289c8-4882-46d1-ab60-e623149fcdfd","id":"ff53da9e-340f-4d11-a8dc-9763296339e7","pickupLongitude":0,"pickupLatitude":10.801708832090494,"dropOffLongitude":0,"dropOffLatitude":10.7782,"price":0,"status":"Processing"}
/// driver : {"id":"eec30162-ddbd-4b1b-ab96-b419ad7fd61d","name":"string","phoneNumber":"string","userName":"Driver1","email":"driver1@gmail.com","address":"string","gender":"Male","dob":"2006-03-21"}
/// customer : {"id":"22f289c8-4882-46d1-ab60-e623149fcdfd","name":null,"phoneNumber":"+84969735764","userName":"+84969735764","email":"+84969735764@gmail.com","address":null,"gender":null,"dob":null}

class BookingData {
  BookingData({
    String? id,
    String? searchRequestId,
    String? driverId,
    String? status,
    SearchRequestModel? searchRequest,
    DriverItem? driver,
  }) {
    _id = id;
    _searchRequestId = searchRequestId;
    _driverId = driverId;
    _status = status;
    _searchRequest = searchRequest;
    _driver = driver;
  }

  BookingData.fromJson(dynamic json) {
    _id = json['id'];
    _searchRequestId = json['searchRequestId'];
    _driverId = json['driverId'];
    _status = json['status'];
    _searchRequest = json['searchRequest'] != null
        ? SearchRequestModel.fromJson(json['searchRequest'])
        : null;
    _driver =
        json['driver'] != null ? DriverItem.fromJson(json['driver']) : null;
  }

  String? _id;
  String? _searchRequestId;
  String? _driverId;
  String? _status;
  SearchRequestModel? _searchRequest;
  DriverItem? _driver;

  BookingData copyWith({
    String? id,
    String? searchRequestId,
    String? driverId,
    String? status,
    SearchRequestModel? searchRequest,
    DriverItem? driver,
  }) =>
      BookingData(
        id: id ?? _id,
        searchRequestId: searchRequestId ?? _searchRequestId,
        driverId: driverId ?? _driverId,
        status: status ?? _status,
        searchRequest: searchRequest ?? _searchRequest,
        driver: driver ?? _driver,
      );

  String? get id => _id;

  String? get searchRequestId => _searchRequestId;

  String? get driverId => _driverId;

  String? get status => _status;

  SearchRequestModel? get searchRequest => _searchRequest;

  DriverItem? get driver => _driver;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['searchRequestId'] = _searchRequestId;
    map['driverId'] = _driverId;
    map['status'] = _status;
    if (_searchRequest != null) {
      map['searchRequest'] = _searchRequest?.toJson();
    }
    if (_driver != null) {
      map['driver'] = _driver?.toJson();
    }
    return map;
  }

  @override
  String toString() {
    return 'BookingData{_id: $_id, _searchRequestId: $_searchRequestId, _driverId: $_driverId, _status: $_status, _searchRequest: $_searchRequest, _driver: $_driver}';
  }
}

class BookingRating {
  String? id;
  String? bookingId;
  NotificationBookingModel? booking;
  num star;
  String comment;
  File? imageData;

  BookingRating(
      {this.id,
      required this.bookingId,
      this.booking,
      required this.star,
      required this.comment,
      this.imageData});

  factory BookingRating.fromJson(Map<String, dynamic> json) => BookingRating(
        id: json['id'],
        bookingId: json['bookingId'],
        star: json['star'] ?? 0,
        comment: json['comment'] ?? '',
        imageData: json['file'] ?? File(''),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BookingId'] = this.bookingId;
    data['Star'] = this.star;
    data['Comment'] = this.comment;
    // data['File'] = this.imageData;
    return data;
  }

  @override
  String toString() {
    return 'BookingRating{id: $id, bookingId: $bookingId, booking: $booking, star: $star, comment: $comment, imageData: $imageData}';
  }
}

class BookingCancelModel {
  String? id;
  BookingItem? booking;
  User? cancelPerson;
  List<String>? imageUrls;
  String? cancelReason;
  String? dateCreated;

  BookingCancelModel(
      {this.id,
      this.booking,
      this.cancelPerson,
      this.imageUrls,
      this.cancelReason,
      this.dateCreated});

  BookingCancelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    booking = json['booking'] != null
        ? new BookingItem.fromJson(json['booking'])
        : null;
    cancelPerson = json['cancelPerson'] != null
        ? new User.fromJson(json['cancelPerson'])
        : null;
    if (json['imageUrls'] != null) {
      imageUrls = <String>[];
      json['imageUrls'].forEach((v) {
        imageUrls!.add(v);
      });
    }
    cancelReason = json['cancelReason'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.booking != null) {
      data['booking'] = this.booking!.toJson();
    }
    if (this.cancelPerson != null) {
      data['cancelPerson'] = this.cancelPerson!.toJson();
    }
    if (this.imageUrls != null) {
      data['imageUrls'] = this.imageUrls;
    }
    data['cancelReason'] = this.cancelReason;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}
