import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  PlaceLocation({this.latitude = 0.0, this.longitude = 0.0, this.address = ''});

  double latitude;
  double longitude;
  String address;

  factory PlaceLocation.fromJson(Map<String, dynamic> json) {
    return PlaceLocation(
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'PlaceLocation{latitude: $latitude, longitude: $longitude, address: $address}';
  }
}
//chuyen ve json 1s ban 1 lan, thieu fromjson,toJson
//bam:toJson, copy gui qua
//cach ban
// {
//   "latitude": 0.0,
//   "longtitude": 0.0

// }

class Place {
  Place(
      {required this.title,
      required this.image,
      required this.location,
      String? id})
      : id = id ?? uuid.v4();
  final String id;
  final String title;
  final File image;
  PlaceLocation location;
}
