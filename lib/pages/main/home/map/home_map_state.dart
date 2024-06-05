import 'package:cus_dbs_app/common/entities/notification/notification_booking_request.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../common/entities/address_model.dart';
import '../../../../common/entities/coordinate.dart';
import '../../../../common/entities/direction_detail.dart';

class MapState {
  //TODO remove
  Rx<NotificationBookingModel?> appBookingData = NotificationBookingModel().obs;

  //Booking
  Rx<LocationData> currentLocation = LocationData.fromMap({}).obs;
  Rx<String?> currentAddress = "".obs;
  Rx<AddressModel?> pickUpLocation = AddressModel().obs;
  Rx<AddressModel?> dropOffLocation = AddressModel().obs;
  Rx<AddressModel?> driverLocation = AddressModel().obs;
  Rx<DirectionDetails?> tripDirectionDetailsInfo = DirectionDetails().obs;

  LatLng sourceLocation = LatLng(10.7912625, 106.6676691);
  LatLng destination = LatLng(10.8076085, 106.655907);
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;

  Rx<BitmapDescriptor> pickupIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen).obs;
  Rx<BitmapDescriptor> dropoffIcon = BitmapDescriptor.defaultMarker.obs;
  Rx<BitmapDescriptor> driverDefaultIcon = BitmapDescriptor.defaultMarker.obs;

  BitmapDescriptor carIcon = BitmapDescriptor.defaultMarker;

  RxSet<Polyline> polylineSet = <Polyline>{}.obs;
  RxSet<Marker> markerSet = <Marker>{}.obs;
  RxSet<Circle> circleSet = <Circle>{}.obs;
}
