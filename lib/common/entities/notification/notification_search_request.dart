import 'dart:convert';

import '../customer.dart';
import '../search_request_model.dart';
import 'notification_booking_request.dart';

class NotificationSearchRequestModel {
  NotificationSearchRequestModel({
    String? id,
    String? customerId,
    String? driverId,
    bool? isFemaleDriver,
    NotificationCustomer? customer,
    num? pickupLongitude,
    num? pickupLatitude,
    num? dropOffLongitude,
    num? dropOffLatitude,
    String? dropOffAddress,
    String? pickupAddress,
    BookingNotiVehicle? bookingVehicle,
    num? price,
    int? status,
    int? bookingPaymentMethod,
    BookingNotiCustomerBookedOnBehalf? customerBookedOnBehalf,
    String? note,
    String? bookingType,
  }) {
    _id = id;

    _customerId = customerId;
    _driverId = driverId;
    _customer = customer;
    _pickupLongitude = pickupLongitude;
    _pickupLatitude = pickupLatitude;
    _dropOffLongitude = dropOffLongitude;
    _dropOffLatitude = dropOffLatitude;
    _dropOffAddress = dropOffAddress;
    _pickupAddress = pickupAddress;
    _bookingVehicle = bookingVehicle;
    _customerBookedOnBehalf = customerBookedOnBehalf;
    _bookingPaymentMethod = bookingPaymentMethod;
    _price = price;
    _isFemaleDriver = isFemaleDriver;
    _status = status;
  }

  NotificationSearchRequestModel.fromJson(dynamic json) {
    _id = json['Id'];
    _customerId = json['CustomerId'];
    _driverId = json['DriverId'];
    _customer = json['Customer'] != null
        ? NotificationCustomer.fromJson(json['Customer'])
        : null;
    _pickupLongitude = json['PickupLongitude'];
    _pickupLatitude = json['PickupLatitude'];
    _dropOffLongitude = json['DropOffLongitude'];
    _dropOffLatitude = json['DropOffLatitude'];
    _dropOffAddress = json['DropOffAddress'];
    _pickupAddress = json['PickupAddress'];
    _bookingVehicle = json['BookingVehicle'] != null
        ? BookingNotiVehicle.fromJson(json['BookingVehicle'])
        : null;
    _customerBookedOnBehalf = json['CustomerBookedOnBehalf'] != null
        ? BookingNotiCustomerBookedOnBehalf.fromJson(
            json['CustomerBookedOnBehalf'])
        : null;
    _bookingPaymentMethod = json['BookingPaymentMethod'];

    _price = json['Price'];
    _status = json['Status'];
  }
  NotificationSearchRequestModel.fromResponseJson(dynamic json) {
    _id = json['id'];

    _customerId = json['customerId'];
    _driverId = json['driverId'];
    _customer = json['customer'] != null
        ? NotificationCustomer.fromJson(json['customer'])
        : null;
    _pickupLongitude = json['pickupLongitude'];
    _pickupLatitude = json['pickupLatitude'];
    _dropOffLongitude = json['dropOffLongitude'];
    _dropOffLatitude = json['dropOffLatitude'];
    _dropOffAddress = json['dropOffAddress'];
    _pickupAddress = json['pickupAddress'];
    _bookingVehicle = json['bookingVehicle'] != null
        ? BookingNotiVehicle.fromJson(json['bookingVehicle'])
        : null;
    _customerBookedOnBehalf = json['customerBookedOnBehalf'] != null
        ? BookingNotiCustomerBookedOnBehalf.fromJson(
            json['customerBookedOnBehalf'])
        : null;
    _bookingPaymentMethod = json['bookingPaymentMethod'];
    _isFemaleDriver = json['isFemaleDriver'];

    _price = json['price'];
    _status = json['status'];
  }

  String? _id;
  String? _customerId;
  String? _driverId;
  NotificationCustomer? _customer;
  num? _pickupLongitude;
  num? _pickupLatitude;
  num? _dropOffLongitude;
  num? _dropOffLatitude;
  String? _dropOffAddress;
  String? _pickupAddress;
  BookingNotiVehicle? _bookingVehicle;
  BookingNotiCustomerBookedOnBehalf? _customerBookedOnBehalf;
  bool? _isFemaleDriver;
  int? _bookingPaymentMethod;
  num? _price;
  int? _status;

  NotificationSearchRequestModel copyWith({
    String? id,
    String? customerId,
    String? driverId,
    NotificationCustomer? customer,
    num? pickupLongitude,
    num? pickupLatitude,
    num? dropOffLongitude,
    num? dropOffLatitude,
    String? dropOffAddress,
    String? pickupAddress,
    BookingNotiCustomerBookedOnBehalf? customerBookedOnBehalf,
    BookingNotiVehicle? bookingVehicle,
    bool? isFemaleDriver,
    int? bookingPaymentMethod,
    num? price,
    int? status,
  }) =>
      NotificationSearchRequestModel(
        id: id ?? _id,
        customerId: customerId ?? _customerId,
        driverId: driverId ?? _driverId,
        customer: customer ?? _customer,
        pickupLongitude: pickupLongitude ?? _pickupLongitude,
        pickupLatitude: pickupLatitude ?? _pickupLatitude,
        dropOffLongitude: dropOffLongitude ?? _dropOffLongitude,
        dropOffLatitude: dropOffLatitude ?? _dropOffLatitude,
        dropOffAddress: dropOffAddress ?? _dropOffAddress,
        pickupAddress: pickupAddress ?? _pickupAddress,
        bookingVehicle: bookingVehicle ?? _bookingVehicle,
        isFemaleDriver: isFemaleDriver ?? _isFemaleDriver,
        customerBookedOnBehalf:
            customerBookedOnBehalf ?? _customerBookedOnBehalf,
        price: price ?? _price,
        bookingPaymentMethod: bookingPaymentMethod ?? _bookingPaymentMethod,
        status: status ?? _status,
      );

  String? get id => _id;

  String? get customerId => _customerId;

  String? get driverId => _driverId;

  NotificationCustomer? get customer => _customer;

  num? get pickupLongitude => _pickupLongitude;

  num? get pickupLatitude => _pickupLatitude;

  num? get dropOffLongitude => _dropOffLongitude;

  num? get dropOffLatitude => _dropOffLatitude;

  String? get dropOffAddress => _dropOffAddress;
  bool? get isFemaleDriver => _isFemaleDriver;

  String? get pickupAddress => _pickupAddress;

  BookingNotiVehicle? get bookingVehicle => _bookingVehicle;
  BookingNotiCustomerBookedOnBehalf? get customerBookedOnBehalf =>
      _customerBookedOnBehalf;
  int? get bookingPaymentMethod => _bookingPaymentMethod;
  num? get price => _price;

  int? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['CustomerId'] = _customerId;
    map['DriverId'] = _driverId;
    if (_customer != null) {
      map['Customer'] = _customer?.toJson();
    }
    map['PickupLongitude'] = _pickupLongitude;
    map['PickupLatitude'] = _pickupLatitude;
    map['DropOffLongitude'] = _dropOffLongitude;
    map['DropOffLatitude'] = _dropOffLatitude;
    map['DropOffAddress'] = _dropOffAddress;
    map['PickupAddress'] = _pickupAddress;
    if (_bookingVehicle != null) {
      map['BookingVehicle'] = _bookingVehicle?.toJson();
    }
    if (_customerBookedOnBehalf != null) {
      map['CustomerBookedOnBehalf'] = _customerBookedOnBehalf?.toJson();
    }
    map['Price'] = _price;
    map['Status'] = _status;
    return map;
  }

  NotificationSearchRequestModel requestFromJson(String str) =>
      NotificationSearchRequestModel.fromJson(json.decode(str));

  String requestToJson(NotificationSearchRequestModel data) =>
      json.encode(data.toJson());

  @override
  String toString() {
    return 'NotificationSearchRequestModel{_id: $_id, _customerId: $_customerId, _driverId: $_driverId, _customer: $_customer, _pickupLongitude: $_pickupLongitude, _pickupLatitude: $_pickupLatitude, _dropOffLongitude: $_dropOffLongitude, _dropOffLatitude: $_dropOffLatitude, _dropOffAddress: $_dropOffAddress, _pickupAddress: $_pickupAddress, _bookingVehicle: $_bookingVehicle, _customerBookedOnBehalf: $_customerBookedOnBehalf, _isFemaleDriver: $_isFemaleDriver, _bookingPaymentMethod: $_bookingPaymentMethod, _price: $_price, _status: $_status}';
  }
}

/// LicensePlate : "30A-12345"
/// Brand : "Toyota"
/// Model : "Camry"
/// Color : "Đen"

BookingNotiVehicle bookingVehicleFromJson(String str) =>
    BookingNotiVehicle.fromJson(json.decode(str));

String bookingVehicleToJson(BookingNotiVehicle data) =>
    json.encode(data.toJson());

class BookingNotiVehicle {
  BookingNotiVehicle({
    String? id,
    String? customerId,
    CustomerItem? customer,
    String? licensePlate,
    String? brand,
    String? model,
    String? color,
    String? imageUrl,
  }) {
    _licensePlate = licensePlate;
    _brand = brand;
    _model = model;
    _color = color;
    _customer = customer;
    _customerId = customerId;
    _id = id;
    _imageUrl = imageUrl;
  }

  String? _id;
  String? _customerId;
  CustomerItem? _customer;
  String? _licensePlate;
  String? _brand;
  String? _model;
  String? _color;
  String? _imageUrl;

  factory BookingNotiVehicle.fromJson(dynamic json) => BookingNotiVehicle(
        licensePlate: json['LicensePlate'],
        brand: json['Brand'],
        id: json['Id'],
        customer: json['Customer'],
        customerId: json['CustomerId'],
        imageUrl: json['ImageUrl'],
        model: json['Model'],
        color: json['Color'],
      );

  String? get licensePlate => _licensePlate;

  String? get brand => _brand;

  String? get model => _model;

  String? get color => _color;
  String? get id => _id;
  String? get customerId => _customerId;
  CustomerItem? get customeritem => _customer;
  String? get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['LicensePlate'] = _licensePlate;
    map['Brand'] = _brand;
    map['Model'] = _model;
    map['Color'] = _color;
    return map;
  }

  @override
  String toString() {
    return 'BookingNotiVehicle{_id: $_id, _customerId: $_customerId, _customer: $_customer, _licensePlate: $_licensePlate, _brand: $_brand, _model: $_model, _color: $_color, _imageUrl: $_imageUrl}';
  }
}

class BookingNotiCustomerBookedOnBehalf {
  String? name;
  String? phoneNumber;
  String? note;

  BookingNotiCustomerBookedOnBehalf({this.name, this.phoneNumber, this.note});

  BookingNotiCustomerBookedOnBehalf.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    phoneNumber = json['PhoneNumber'];
    note = json['Note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['PhoneNumber'] = this.phoneNumber;
    data['Note'] = this.note;
    return data;
  }

  @override
  String toString() {
    return 'BookingNotiCustomerBookedOnBehalf{name: $name, phoneNumber: $phoneNumber, note: $note}';
  }
}
