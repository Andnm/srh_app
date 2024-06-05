import 'package:cus_dbs_app/common/entities/notification/notification_search_request.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotificationBookingModel {
  String? id;
  String? searchRequestId;
  String? driverId;
  int? status;
  NotificationSearchRequestModel? searchRequest;
  NotificationDriver? driver;
  NotificationCustomer? customer;
  String? checkInNote;
  String? checkOutNote;
  LocationDriver? driverLocation;

  NotificationBookingModel(
      {this.id,
      this.searchRequestId,
      this.driverId,
      this.status,
      this.searchRequest,
      this.driver,
      this.customer,
      this.checkInNote,
      this.checkOutNote,
      this.driverLocation});

  NotificationBookingModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    searchRequestId = json['SearchRequestId'];
    driverId = json['DriverId'];
    status = json['Status'];
    searchRequest = json['SearchRequest'] is Map
        ? new NotificationSearchRequestModel.fromJson(json['SearchRequest'])
        : null;
    driver = json['Driver'] is Map
        ? new NotificationDriver.fromJson(json['Driver'])
        : null;
    checkInNote = json['CheckInNote'] ?? "";
    checkOutNote = json['CheckOutNote'] ?? "";
    customer = json['Customer'] is Map
        ? new NotificationCustomer.fromJson(json['Customer'])
        : null;
    driverLocation = json['DriverLocation'] is Map
        ? new LocationDriver.fromJson(json['DriverLocation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id ?? '';
    data['SearchRequestId'] = this.searchRequestId ?? '';
    data['DriverId'] = this.driverId ?? '';
    data['Status'] = this.status ?? '';
    if (this.searchRequest != null) {
      data['SearchRequest'] = this.searchRequest!.toJson();
    }
    if (this.driver != null) {
      data['Driver'] = this.driver!.toJson();
    }
    if (this.customer != null) {
      data['Customer'] = this.customer!.toJson();
    }
    data.removeWhere((key, value) => value == null);
    return data;
  }

  NotificationBookingModel copyWith({
    String? bookingId,
  }) =>
      NotificationBookingModel(
        id: bookingId ?? this.id,
        searchRequestId: this.searchRequestId,
        driverId: this.driverId,
        status: this.status,
        searchRequest: this.searchRequest,
        driver: this.driver,
        customer: this.customer,
        checkInNote: this.checkInNote,
        checkOutNote: this.checkOutNote,
        driverLocation: this.driverLocation,
      );

  @override
  String toString() {
    return 'NotificationBookingModel{id: $id, searchRequestId: $searchRequestId, driverId: $driverId, status: $status, searchRequest: $searchRequest, driver: $driver, customer: $customer, checkInNote: $checkInNote, checkOutNote: $checkOutNote, driverLocation: $driverLocation}';
  }
}

class NotificationSearchRequest {
  String? customerId;
  String? driverId;
  String? id;
  double? pickupLongitude;
  double? pickupLatitude;
  double? dropOffLongitude;
  double? dropOffLatitude;
  String? pickupAddress;
  String? dropOffAddress;
  int? price;
  int? status;

  NotificationSearchRequest(
      {this.customerId,
      this.id,
      this.pickupLongitude,
      this.pickupLatitude,
      this.dropOffLongitude,
      this.dropOffLatitude,
      this.pickupAddress,
      this.dropOffAddress,
      this.price,
      this.status});

  NotificationSearchRequest.fromJson(Map<String, dynamic> json) {
    customerId = json['CustomerId'];
    id = json['Id'];
    driverId = json['DriverId'];
    pickupLongitude =
        double.tryParse(json['PickupLongitude']?.toString() ?? '');
    pickupLatitude = double.tryParse(json['PickupLatitude']?.toString() ?? '');
    dropOffLongitude =
        double.tryParse(json['DropOffLongitude']?.toString() ?? '');
    dropOffLatitude =
        double.tryParse(json['DropOffLatitude']?.toString() ?? '');
    pickupAddress = json['PickupAddress'] ?? '';
    dropOffAddress = json['DropOffAddress'] ?? '';
    price = json['Price'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerId'] = this.customerId;
    data['DriverId'] = this.driverId;
    data['Id'] = this.id;
    data['PickupLongitude'] = this.pickupLongitude;
    data['PickupLatitude'] = this.pickupLatitude;
    data['DropOffLongitude'] = this.dropOffLongitude;
    data['DropOffLatitude'] = this.dropOffLatitude;
    data['Price'] = this.price;
    data['Status'] = this.status;
    return data;
  }

  @override
  String toString() {
    return 'NotificationSearchRequestModel{customerId: $customerId, id: $id, pickupLongitude: $pickupLongitude, pickupLatitude: $pickupLatitude, dropOffLongitude: $dropOffLongitude, dropOffLatitude: $dropOffLatitude, pickupAddress: $pickupAddress, dropOffAddress: $dropOffAddress, price: $price, status: $status}';
  }
}

class NotificationDriver {
  String? id;
  String? name;
  String? phoneNumber;
  String? userName;
  String? email;
  String? address;
  int? gender;
  double? star;
  String? dob;
  String? avatar;

  NotificationDriver(
      {this.id,
      this.name,
      this.phoneNumber,
      this.userName,
      this.email,
      this.avatar,
      this.address,
      this.gender,
      this.star,
      this.dob});

  NotificationDriver.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    avatar = json['Avatar'];
    phoneNumber = json['PhoneNumber'];
    userName = json['UserName'];
    email = json['Email'];
    address = json['Address'];
    gender = json['Gender'];
    star = json['Star'];
    dob = json['Dob'] is Map ? json['Dob'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['PhoneNumber'] = this.phoneNumber;
    data['UserName'] = this.userName;
    data['Email'] = this.email;
    data['Address'] = this.address;
    data['Gender'] = this.gender;
    data['Dob'] = this.dob;
    return data;
  }

  @override
  String toString() {
    return 'NotificationDriver{id: $id, name: $name, phoneNumber: $phoneNumber, userName: $userName, email: $email, address: $address, gender: $gender, star: $star, dob: $dob, avatar: ${avatar?.substring(20)}}';
  }
}

class NotificationCustomer {
  String? id;
  String? name;
  String? phoneNumber;
  String? userName;
  String? email;
  String? avatar;
  String? address;
  int? gender;
  String? dob;

  NotificationCustomer(
      {this.id,
      this.name,
      this.avatar,
      this.phoneNumber,
      this.userName,
      this.email,
      this.address,
      this.gender,
      this.dob});

  NotificationCustomer.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    avatar = json['Avatar'];
    phoneNumber = json['PhoneNumber'] is Map ? json['PhoneNumber'] : null;
    userName = json['UserName'];
    email = json['Email'];
    address = json['Address'];
    gender = json['Gender'];
    dob = json['Dob'] is Map ? json['Dob'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['PhoneNumber'] = this.phoneNumber;
    data['UserName'] = this.userName;
    data['Email'] = this.email;
    data['Address'] = this.address;
    data['Gender'] = this.gender;
    data['Dob'] = this.dob;
    return data;
  }

  @override
  String toString() {
    return 'NotificationCustomer{id: $id, name: $name, phoneNumber: $phoneNumber, userName: $userName, email: $email, avatar: ${avatar?.substring(20)}, address: $address, gender: $gender, dob: $dob}';
  }
}

class LocationDriver {
  double? latitude;
  double? longitude;

  LocationDriver({this.latitude, this.longitude});

  LocationDriver.fromJson(Map<String, dynamic> json) {
    latitude = json['Latitude'];
    longitude = json['Longitude'];
  }

  void setLatLng({required double? latitude, required double? longitude}) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  @override
  String toString() {
    return 'LocationDriver{latitude: $latitude, longitude: $longitude}';
  }
}
