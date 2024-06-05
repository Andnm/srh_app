import 'package:cus_dbs_app/common/entities/vehicle.dart';

import 'customer.dart';

class SearchRequestModel {
  double? pickupLatitude;
  double? pickupLongitude;
  double? dropOffLatitude;
  double? dropOffLongitude;
  String? pickupAddress;
  String? dropOffAddress;
  String? id;
  String? driverId;
  double? distance;
  VehicleItem? bookingVehicle;
  CustomerItem? customer;
  num? price;
  CustomerBookedOnBehalf? customerBookedOnBehalf;
  String? note;
  String? bookingType;
  bool? isFemaleDriver;
  String? bookingPaymentMethod;
  String? status;

  SearchRequestModel(
      {this.id,
      this.driverId,
      this.pickupLatitude,
      this.pickupLongitude,
      this.dropOffLatitude,
      this.dropOffLongitude,
      this.pickupAddress,
      this.dropOffAddress,
      this.bookingVehicle,
      this.customer,
      this.price,
      this.distance,
      this.bookingType,
      this.customerBookedOnBehalf,
      this.note,
      this.status,
      this.isFemaleDriver,
      this.bookingPaymentMethod});

  factory SearchRequestModel.fromJson(Map<String, dynamic> json) {
    return SearchRequestModel(
      id: json['id'],
      driverId: json['driverId'],
      status: json["status"],
      pickupLatitude: json['pickupLatitude']?.toDouble(),
      pickupLongitude: json['pickupLongitude']?.toDouble(),
      dropOffLatitude: json['dropOffLatitude']?.toDouble(),
      dropOffLongitude: json['dropOffLongitude']?.toDouble(),
      pickupAddress: json['pickupAddress'],
      dropOffAddress: json['dropOffAddress'],
      distance: json['distance'],
      bookingVehicle: json['bookingVehicle'] != null
          ? VehicleItem.fromJson(json['bookingVehicle'])
          : null,
      isFemaleDriver: json['isFemaleDriver'],
      customer: json['customer'] != null
          ? CustomerItem.fromJson(json['customer'])
          : null,
      price: json['price']?.toDouble(),
      customerBookedOnBehalf: json['customerBookedOnBehalf'] != null
          ? new CustomerBookedOnBehalf.fromJson(json['customerBookedOnBehalf'])
          : CustomerBookedOnBehalf(),
      note: json['note'],
      bookingType: json['bookingType'],
      bookingPaymentMethod: json['bookingPaymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'driverId': driverId,
      ''
          'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'dropOffLatitude': dropOffLatitude,
      'dropOffLongitude': dropOffLongitude,
      'pickupAddress': pickupAddress,
      'dropOffAddress': dropOffAddress,
      'bookingVehicle': bookingVehicle?.toJson(),
      'price': price,
      'customerBookedOnBehalf': customerBookedOnBehalf?.toJson(),
      'note': note,
      'distance': distance,
      'isFemaleDriver': isFemaleDriver,
      'bookingType': bookingType,
      'status': status,
      'bookingPaymentMethod': bookingPaymentMethod,
    };
    return data;
  }

  Map<String, dynamic> toCancelSearchRequestJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SearchRequestId'] = this.id;
    data['DriverId'] = this.driverId;

    return data;
  }

  @override
  String toString() {
    return 'SearchRequestModel{pickupLatitude: $pickupLatitude, pickupLongitude: $pickupLongitude, dropOffLatitude: $dropOffLatitude, dropOffLongitude: $dropOffLongitude, pickupAddress: $pickupAddress, dropOffAddress: $dropOffAddress, id: $id, driverId: $driverId, distance: $distance, bookingVehicle: $bookingVehicle, customer: $customer, price: $price, customerBookedOnBehalf: $customerBookedOnBehalf, note: $note, bookingType: $bookingType, isFemaleDriver: $isFemaleDriver, bookingPaymentMethod: $bookingPaymentMethod, status: $status}';
  }
}

class CustomerBookedOnBehalf {
  String? name;
  String? phoneNumber;
  String? note;
  String? imageUrl;

  CustomerBookedOnBehalf(
      {this.name, this.phoneNumber, this.note, this.imageUrl});

  CustomerBookedOnBehalf.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    note = json['note'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['note'] = this.note;
    data['imageUrl'] = this.imageUrl;
    return data;
  }

  @override
  String toString() {
    return 'CustomerBookedOnBehalf{name: $name, phoneNumber: $phoneNumber, note: $note, imageUrl: $imageUrl}';
  }
}
