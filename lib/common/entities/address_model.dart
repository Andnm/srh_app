import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressModel {
  String? humanReadableAddress;
  double? latitudePosition;
  double? longitudePosition;
  String? placeID;
  String? placeName;
  bool? isPick;

  AddressModel({
    this.humanReadableAddress,
    this.latitudePosition,
    this.longitudePosition,
    this.placeID,
    this.placeName,
    this.isPick,
  });

  factory AddressModel.fromMap(Map<String, dynamic> dataMap) {
    return AddressModel(
      humanReadableAddress: dataMap['humanReadableAddress'] as String?,
      latitudePosition: dataMap['latitudePosition'] as double?,
      longitudePosition: dataMap['longitudePosition'] as double?,
      placeID: dataMap['placeID'] as String?,
      placeName: dataMap['placeName'] as String?,
    );
  }
  void setLatLng({required double latitude, required double longitude}) {
    this.latitudePosition = latitude;
    this.longitudePosition = longitude;
  }

  @override
  String toString() {
    return 'AddressModel{humanReadableAddress: $humanReadableAddress, latitudePosition: $latitudePosition, longitudePosition: $longitudePosition, placeID: $placeID, placeName: $placeName isPick:$isPick}';
  }
}
