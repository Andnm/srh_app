import 'dart:io';

import 'package:cus_dbs_app/common/entities/customer.dart';

class VehicleItem {
  String? id;
  String? customerId;
  CustomerItem? customer;
  String? licensePlate;
  String? brand;
  String? model;
  String? color;
  String? imageUrl;

  VehicleItem(
      {this.id,
      this.customerId,
      this.customer,
      this.licensePlate,
      this.brand,
      this.model,
      this.color,
      this.imageUrl});

  VehicleItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    customer = json['customer'] != null
        ? new CustomerItem.fromJson(json['customer'])
        : null;
    licensePlate = json['licensePlate'];
    brand = json['brand'];
    model = json['model'];
    color = json['color'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['licensePlate'] = this.licensePlate;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['color'] = this.color;
    data['imageUrl'] = this.imageUrl;
    return data;
  }

  @override
  String toString() {
    return 'VehicleItem{id: $id, customerId: $customerId, customer: $customer, licensePlate: $licensePlate, brand: $brand, model: $model, color: $color, imageUrl: $imageUrl}';
  }
}

class VehicleItemImage {
  String? id;
  String? vehicleId;
  VehicleItem? vehicle;
  String? imageUrl;
  String? vehicleImageType;
  File? file;

  VehicleItemImage({
    this.id,
    this.vehicleId,
    this.vehicle,
    this.imageUrl,
    this.vehicleImageType,
    this.file,
  });

  VehicleItemImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicleId'];
    vehicle = json['vehicle'] != null
        ? new VehicleItem.fromJson(json['vehicle'])
        : null;
    imageUrl = json['imageUrl'];
    vehicleImageType = json['vehicleImageType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicleId'] = this.vehicleId;
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    data['imageUrl'] = this.imageUrl;
    data['vehicleImageType'] = this.vehicleImageType;
    data['file'] = this.file;
    return data;
  }

  @override
  String toString() {
    return 'VehicleItemImage{id: $id, vehicleId: $vehicleId, vehicle: $vehicle, imageUrl: $imageUrl, vehicleImageType: $vehicleImageType, file: $file}';
  }
}
