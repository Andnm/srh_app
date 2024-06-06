import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:cus_dbs_app/app/booking_status_type.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_booking_request.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_search_request.dart';
import 'package:cus_dbs_app/common/methods/common_methods.dart';
import 'package:cus_dbs_app/pages/main/home/index.dart';
import 'package:cus_dbs_app/values/booking.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/apis/customer_api.dart';
import '../../../../common/entities/address_model.dart';
import '../../../../common/entities/direction_detail.dart';

import '../../../../common/widgets/dialogs/alert_dialog.dart';

import '../../../../services/socket_service.dart';
import '../../../../values/roles.dart';
import 'index.dart';
import 'values/api_map_constants.dart';

class MapController extends GetxController {
  final state = MapState();
  GoogleMapController? controllerOfGoogleMap;
  RxBool myLocationEnabled = true.obs;
  LocationData? previousLocation;
  double? distanceInKms = 0.0;

  Completer<GoogleMapController> mapCompletePageController =
      Completer<GoogleMapController>();

  HomeController get homeController => Get.find<HomeController>();

  @override
  Future<void> onInit() async {
    super.onInit();
    // Test sự kiện 'newNotify'
    // await makeIconsCustoms();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    var data = Get.parameters;

    // setCustomMarkerIcon();
    // await getCurrentLocation(() {});

    await makeIconsCustoms();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> handleTerminatedAppData() async {
    homeController.updateBookingStatus(BOOKING_STATUS.SEARCH_DRIVER);
    await homeController.getAvailableNearbyOnlineDriversTerminatedApp(
        isFemaleDriver:
            homeController.state.requestSearchRequestModel.isFemaleDriver);
    if (await homeController.checkAvailableDriver()) {
      homeController.updateSearchRequestModel(
          driverId:
              homeController.state.availableNearbyOnlineDriversList[0].id);

      var response = await CustomerAPI.sendSearchRequestToDriver(
          searchRequestId: homeController.state.requestSearchRequestModel.id,
          driverId:
              homeController.state.availableNearbyOnlineDriversList[0].id);
      homeController.removeDriverFromList(
          homeController.state.availableNearbyOnlineDriversList[0].id);

      SignalRService.listenEvent("searchRequestDriverMiss", (arguments) async {
        print("Miss search request");

        await homeController.handleSearchRequestDriverMiss(arguments);
      });
    }
  }

  void initDataCustomer() async {
    homeController.initCustomer(state.currentLocation.value);
    if (homeController.isFromTerminated) {
      if (!homeController.isNotCompleteBookingResult) {
        await handleTerminatedAppData();
      } else {
        await CustomerAPI.sendNotiBooking();
      }
    }

    if (BookingTypes.getBookByMyselfStatus) {
    } else {
      // homeController.state.requestCustomerBookedOnBehalf =
      //     Get.arguments[0] as CustomerBookedOnBehalf;
      // homeController.state.requestVehicle.value =
      //     Get.arguments[1] as VehicleItem;
      // print("Request customer onbehalf: " +
      //     homeController.state.requestCustomerBookedOnBehalf.toString());
      // print("Request customer: " +
      //     homeController.state.requestVehicle.value.toString());
    }
  }

  Future<void> initDataDriver() async {
    // await homeController.sendLocationToBackend();

    if (homeController.isShowInfo) {
      if (homeController.state.appBookingData.value?.customer?.id != null) {
        // await homeController.sendLocationToBackend();
        await homeController.sendTrackingData(
            customerId:
                homeController.state.appBookingData.value!.customer!.id!,
            latitude: state.currentLocation.value.latitude ?? 0.0,
            longitude: state.currentLocation.value.longitude ?? 0.0);
        await homeController.updatePolylineAllTrip();
      } else {
        return;
      }
    }
  }

  Future<void> getCurrentLocation(VoidCallback callbackSuccess) async {
    Location location = Location();

    await location.getLocation().then(
      (location) async {
        state.currentLocation.value = location;
        await updateCurrentCameraPosition();

        callbackSuccess();
        print('Current location: ' + state.currentLocation.value.toString());
        print('lat ${state.currentLocation.value.latitude}');
        print('long ${state.currentLocation.value.longitude}');
        var temp = await convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
            state.currentLocation.value); // chi co cus
      },
    );

    location.onLocationChanged.listen((newLoc) async {
      if (previousLocation == null ||
          newLoc.latitude != previousLocation!.latitude ||
          newLoc.longitude != previousLocation!.longitude) {
        distanceInKms = await calculateDistanceByNewlocation(
          previousLocation?.latitude ?? 0.0,
          previousLocation?.longitude ?? 0.0,
          newLoc.latitude ?? 0.0,
          newLoc.longitude ?? 0.0,
        );
        previousLocation = newLoc;
      }
      if (distanceInKms != null && distanceInKms! >= 0.1) {
        state.currentLocation.value = newLoc;

        print(
            'new location: ${state.currentLocation.value}'); // truyen vao gan luon current co pickup location (chi co cus)

        //  updatePolyline(state.currentLocation.value);
        if (homeController.isDriver) {
          state.currentAddress.value =
              await convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
                  state.currentLocation.value);
          callbackSuccess();
        } else {
          homeController.initCustomer(state.currentLocation.value);
        }
      }
    });
  }

  Future<void> updateCurrentCameraPosition() async {
    controllerOfGoogleMap?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            (!homeController.isDriver && homeController.isFromOnGoingToComplete)
                ? state.driverLocation.value!.latitudePosition ?? 0.0
                : state.currentLocation.value.latitude ?? 0.0,
            (!homeController.isDriver && homeController.isFromOnGoingToComplete)
                ? state.driverLocation.value!.longitudePosition ?? 0.0
                : state.currentLocation.value.longitude ?? 0.0,
          ),
          zoom: 18,
        ),
      ),
    );
  }

  Future<DirectionDetails?> getDirectionDetailsFromAPI(
      LatLng source, LatLng destination) async {
    if (destination.longitude == 0.0 ||
        source.latitude == 0.0 ||
        source.longitude == 0.0 ||
        destination.latitude == 0.0) {
      return null;
    }
    String urlDirectionsAPI =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${destination.latitude},${destination.longitude}&origin=${source.latitude},${source.longitude}&mode=driving&key=$GOOGLE_MAP_API_KEY";

    var responseFromDirectionsAPI =
        await CommonMethods.sendRequestToGoogleMapdAPI(urlDirectionsAPI);

    if (responseFromDirectionsAPI == "error") {
      Get.snackbar('Lỗi', 'Không thể nhận CHI TIẾT CHỈ ĐƯỜNG');
      return null;
    }

    DirectionDetails detailsModel = DirectionDetails();

    detailsModel.distanceTextString =
        responseFromDirectionsAPI["routes"][0]["legs"][0]["distance"]["text"];
    detailsModel.distanceValueDigits =
        responseFromDirectionsAPI["routes"][0]["legs"][0]["distance"]["value"];

    detailsModel.durationTextString =
        responseFromDirectionsAPI["routes"][0]["legs"][0]["duration"]["text"];
    detailsModel.durationValueDigits =
        responseFromDirectionsAPI["routes"][0]["legs"][0]["duration"]["value"];

    detailsModel.encodedPoints =
        responseFromDirectionsAPI["routes"][0]["overview_polyline"]["points"];

    return detailsModel;
  }

  //
  // void moveToCurrentLocation(GoogleMapController? mapController) {
  //   mapController?.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: LatLng(state.currentLocation.value.latitude ?? 0.0,
  //             state.currentLocation.value.latitude ?? 0.0),
  //         zoom: 16.5,
  //       ),
  //     ),
  //   );
  // }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAP_API_KEY,
      PointLatLng(state.currentLocation.value.latitude ?? 0.0,
          state.currentLocation.value.longitude ?? 0.0),
      PointLatLng(state.destination.latitude, state.destination.longitude),
    );
    if (result.points.isNotEmpty) {
      state.polylineCoordinates.value = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }
  }

  Future<void> updatePolyline(
      {required AddressModel pickupLocation,
      required AddressModel dropOffLocation}) async {
    print("Updated pickupLocation $pickupLocation");
    print("Updated dropOffLocation $dropOffLocation");
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAP_API_KEY,
      PointLatLng(pickupLocation.latitudePosition ?? 0.0,
          pickupLocation.longitudePosition ?? 0.0),
      PointLatLng(dropOffLocation.latitudePosition ?? 0.0,
          dropOffLocation.longitudePosition ?? 0.0),
    );
    print("POLY RESULT ${result.points}");
    state.polylineCoordinates.clear();
    if (!homeController.isDriver) {
      if (homeController.isAccept ||
          homeController.isArrived ||
          homeController.isCheckIn) {
        print("Before removing marker: ${state.markerSet}");
        state.markerSet.value.removeWhere((marker) =>
            marker.markerId.value == "dropOffDestinationPointMarkerID");
        Marker dropOffDestinationPointMarker = Marker(
          markerId: const MarkerId("dropOffDestinationPointMarkerID"),
          position: LatLng(dropOffLocation.latitudePosition!,
              dropOffLocation.longitudePosition!),
          icon: state.dropoffIcon.value,
        );
        state.markerSet.value.add(dropOffDestinationPointMarker);
      } else {
        state.markerSet.value.removeWhere(
            (marker) => marker.markerId.value == "pickUpPointMarkerID");
        Marker pickupPointMarker = Marker(
          markerId: const MarkerId("pickUpPointMarkerID"),
          position: LatLng(pickupLocation.latitudePosition!,
              pickupLocation.longitudePosition!),
          icon: state.pickupIcon.value,
        );
        state.markerSet.value.add(pickupPointMarker);
      }
    }

    if (result.points.isNotEmpty) {
      state.polylineCoordinates.value = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      Polyline polyline = Polyline(
        polylineId: const PolylineId("polylineID"),
        color: Colors.blueAccent,
        points: state.polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      state.polylineSet.clear();
      state.polylineSet.add(polyline);
      print("Updated polylineSet: ${state.polylineSet.value}");
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> makeIconsCustoms() async {
    state.driverDefaultIcon.value = BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/icons/tracking.png", 100));
    final iconPassenger = BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/icons/initial.png", 100));
    final iconTracking = BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/icons/tracking.png", 100));
    final iconFinal = BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/icons/final.png", 100));
    final iconCar = BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/icons/car.png", 100));
    switch (homeController.state.statusOfBooking.value) {
      case BOOKING_STATUS.PENDING:
      case BOOKING_STATUS.SEARCH_DRIVER:
      case BOOKING_STATUS.SHOW_DRIVER:
        if (!homeController.isDriver) {
          state.pickupIcon.value = iconPassenger;
          state.dropoffIcon.value = iconFinal;
        }
        // else {
        //   state.pickupIcon.value = iconTracking;
        //   state.dropoffIcon.value = iconPassenger;
        // }
        break;
      case BOOKING_STATUS.ACCEPT:
        // state.pickupIcon.value = iconTracking;
        //state.dropoffIcon.value = iconPassenger;
        if (!homeController.isDriver) {
          state.pickupIcon.value = iconPassenger;
          state.dropoffIcon.value = iconTracking;
        } else {
          // state.pickupIcon.value = iconTracking;
          state.dropoffIcon.value = iconFinal;
        }
        break;

      case BOOKING_STATUS.ARRIVED:
      // state.pickupIcon.value = iconTracking;
      // state.dropoffIcon.value = iconFinal;
      // if (!homeController.isDriver) {
      //   state.pickupIcon.value = iconPassenger;
      //   state.dropoffIcon.value = iconTracking;
      // } else {
      //   // state.pickupIcon.value = iconTracking;
      //   state.dropoffIcon.value = iconPassenger;
      // }
      // break;
      case BOOKING_STATUS.ONGOING:
        state.pickupIcon.value = iconCar;
        state.dropoffIcon.value = iconFinal;
        break;
      default:
        break;
    }
  }

  ///Reverse GeoCoding
  Future<String> convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
      LocationData location) async {
    String humanReadableAddress = "";
    String apiGeoCodingUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$GOOGLE_MAP_API_KEY";

    try {
      var responseFromAPI =
          await CommonMethods.sendRequestToGoogleMapdAPI(apiGeoCodingUrl);

      if (responseFromAPI != "error") {
        humanReadableAddress =
            responseFromAPI["results"][0]["formatted_address"];

        AddressModel model = AddressModel();
        model.humanReadableAddress = humanReadableAddress;
        model.placeName = humanReadableAddress;
        model.longitudePosition = location.longitude;
        model.latitudePosition = location.latitude;

        if (!homeController.isDriver) {
          state.pickUpLocation.value = model;
        }
        state.currentAddress.value = humanReadableAddress;
      }
    } catch (e) {
      // Xử lý ngoại lệ ở đây

      humanReadableAddress = "Không thể lấy địa chỉ";
    }

    return humanReadableAddress;
  }

  Future<double?> calculateDistanceByNewlocation(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    if (startLatitude == 0.0 ||
        startLongitude == 0.0 ||
        endLatitude == 0.0 ||
        endLongitude == 0.0) {
      return null;
    }

    const int earthRadius = 6371; // Bán kính trái đất (km)

    double degToRad(double deg) {
      return deg * (pi / 180);
    }

    double dLat = degToRad(endLatitude - startLatitude);
    double dLon = degToRad(endLongitude - startLongitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degToRad(startLatitude)) *
            cos(degToRad(endLatitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    print("new distance: " + distance.toString());
    return distance;
  }

  Future<double?> calculateDistanceByGoogleMapAPI(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    if (startLatitude == 0.0 ||
        startLongitude == 0.0 ||
        endLatitude == 0.0 ||
        endLongitude == 0.0) {
      return null;
    }

    try {
      String urlDirectionsAPI =
          "https://maps.googleapis.com/maps/api/directions/json?destination=$endLatitude,$endLongitude&origin=$startLatitude,$startLongitude&mode=driving&key=$GOOGLE_MAP_API_KEY";

      var responseFromDirectionsAPI =
          await CommonMethods.sendRequestToGoogleMapdAPI(urlDirectionsAPI);

      if (responseFromDirectionsAPI == "error") {
        Get.snackbar('Error', 'Cannot get DIRECTION DETAILS');
        return null;
      }

      var data = responseFromDirectionsAPI;

      if (data['status'] == 'OK') {
        var distance = data['routes'][0]['legs'][0]['distance']['value'];
        double distanceInKm = distance / 1000;
        print("distanceInKm${distanceInKm}");
        return distanceInKm;
      } else {
        print('Lỗi: ${data['status']}');
        return null;
      }
    } catch (e) {
      print('Error calculating distance: $e');
      return null;
    }
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  resetMapStatus() {
    state.polylineCoordinates.clear();
    state.polylineSet.clear();
    state.markerSet.clear();
    state.circleSet.clear();
  }

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes("lib/themes/map_style.json")
        .then((value) => setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }

  Future<void> retrieveMapDirectionDetails(
      {required AddressModel? pickUpLocation,
      required AddressModel? dropOffLocation}) async {
    try {
      if (dropOffLocation == null) return;
      await makeIconsCustoms();
      LatLng currentGeoGraphicCoOrdinates = LatLng(
        state.currentLocation.value.latitude ?? 0.0,
        state.currentLocation.value.longitude ?? 0.0,
      );
      LatLng pickupGeoGraphicCoOrdinates;
      if (pickUpLocation != null) {
        pickupGeoGraphicCoOrdinates = LatLng(
          pickUpLocation.latitudePosition ?? 0.0,
          pickUpLocation.longitudePosition ?? 0.0,
        );
      } else {
        pickupGeoGraphicCoOrdinates = currentGeoGraphicCoOrdinates;
      }
      LatLng dropOffGeoGraphicCoOrdinates = LatLng(
        dropOffLocation.latitudePosition ?? 0.0,
        dropOffLocation.longitudePosition ?? 0.0,
      );

      //Directions API
      var detailsFromDirectionAPI = await getDirectionDetailsFromAPI(
          pickupGeoGraphicCoOrdinates, dropOffGeoGraphicCoOrdinates);
      if (detailsFromDirectionAPI == null) {
        return;
      }
      state.tripDirectionDetailsInfo.value =
          detailsFromDirectionAPI ?? DirectionDetails();

      if (homeController.isSearchRequest) {
        await homeController
            .calculateFareAmount(state.tripDirectionDetailsInfo.value);
      }

      //draw route from pickup to dropOffDestination
      PolylinePoints pointsPolyline = PolylinePoints();
      List<PointLatLng> latLngPointsFromPickUpToDestination =
          pointsPolyline.decodePolyline(
              state.tripDirectionDetailsInfo.value?.encodedPoints ?? '');
      state.polylineCoordinates.clear();

      if (latLngPointsFromPickUpToDestination.isNotEmpty) {
        latLngPointsFromPickUpToDestination.forEach((PointLatLng latLngPoint) {
          state.polylineCoordinates
              .add(LatLng(latLngPoint.latitude, latLngPoint.longitude));
        });
      }

      state.polylineSet.clear();

      Polyline polyline = Polyline(
        polylineId: const PolylineId("polylineID"),
        color: Colors.blueAccent,
        points: state.polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      state.polylineSet.add(polyline);

      //fit the polyline into the map
      LatLngBounds boundsLatLng;
      if (pickupGeoGraphicCoOrdinates.latitude >
              dropOffGeoGraphicCoOrdinates.latitude &&
          pickupGeoGraphicCoOrdinates.longitude >
              dropOffGeoGraphicCoOrdinates.longitude) {
        boundsLatLng = LatLngBounds(
          southwest: dropOffGeoGraphicCoOrdinates,
          northeast: pickupGeoGraphicCoOrdinates,
        );
      } else if (pickupGeoGraphicCoOrdinates.longitude >
          dropOffGeoGraphicCoOrdinates.longitude) {
        boundsLatLng = LatLngBounds(
          southwest: LatLng(pickupGeoGraphicCoOrdinates.latitude,
              dropOffGeoGraphicCoOrdinates.longitude),
          northeast: LatLng(dropOffGeoGraphicCoOrdinates.latitude,
              pickupGeoGraphicCoOrdinates.longitude),
        );
      } else if (pickupGeoGraphicCoOrdinates.latitude >
          dropOffGeoGraphicCoOrdinates.latitude) {
        boundsLatLng = LatLngBounds(
          southwest: LatLng(dropOffGeoGraphicCoOrdinates.latitude,
              pickupGeoGraphicCoOrdinates.longitude),
          northeast: LatLng(pickupGeoGraphicCoOrdinates.latitude,
              dropOffGeoGraphicCoOrdinates.longitude),
        );
      } else {
        boundsLatLng = LatLngBounds(
          southwest: pickupGeoGraphicCoOrdinates,
          northeast: dropOffGeoGraphicCoOrdinates,
        );
      }

      controllerOfGoogleMap
          ?.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 72));

      //add markers to pickup and dropOffDestination points
      state.markerSet.clear();
      Marker pickUpPointMarker = Marker(
        markerId: const MarkerId("pickUpPointMarkerID"),
        position: pickupGeoGraphicCoOrdinates,
        icon: state.pickupIcon.value,
        infoWindow: InfoWindow(
            title: state.pickUpLocation.value?.placeName,
            snippet: "Pickup Location"),
      );

      Marker dropOffDestinationPointMarker = Marker(
        markerId: const MarkerId("dropOffDestinationPointMarkerID"),
        position: dropOffGeoGraphicCoOrdinates,
        icon: state.dropoffIcon.value,
        infoWindow: InfoWindow(
            title: state.dropOffLocation.value?.placeName,
            snippet: "Destination Location"),
      );
      print('state.pickupIcon.value::' + state.pickupIcon.value.toString());
      print('state.dropoffIcon.value::' + state.dropoffIcon.value.toString());
      if (!homeController.isDriver) {
        state.markerSet.add(pickUpPointMarker);
      }

      state.markerSet.add(dropOffDestinationPointMarker);
    } catch (e) {
      print('Error in retrieveMapDirectionDetails: $e');

      Get.dialog(
        CustomAlertDialog(
          content:
              "Đã xảy ra lỗi khi lấy thông tin chỉ đường. Vui lòng thử lại.",
          buttonText: "Đóng",
          onPressed: () {
            Get.back();
          },
        ),
      );
    }
  }

  AddressModel? convertAddress(
      bool isPickUp, NotificationSearchRequestModel? notiRequestModel) {
    if (notiRequestModel == null) return null;
    var latitude;
    var longitude;
    if (isPickUp) {
      latitude = notiRequestModel.pickupLatitude;
      longitude = notiRequestModel.pickupLongitude;
    } else {
      latitude = notiRequestModel.dropOffLatitude;
      longitude = notiRequestModel.dropOffLongitude;
    }
    return AddressModel(
        latitudePosition: latitude, longitudePosition: longitude);
  }

  AddressModel? convertMyAddressDriver() {
    if (state.currentLocation.value.latitude == null) return null;
    return AddressModel(
        latitudePosition: state.currentLocation.value.latitude,
        longitudePosition: state.currentLocation.value.longitude);
  }

  void updateDriverLocation(LocationDriver? addressDriver) {
    if (addressDriver == null) return null;
    state.driverLocation.value = AddressModel(
        latitudePosition: addressDriver.latitude,
        longitudePosition: addressDriver.longitude);
  }

  void updateCustomerLocation(
      AddressModel? addressPickUp, AddressModel? addressDropOff) {
    state.pickUpLocation.value = addressPickUp;
    state.dropOffLocation.value = addressDropOff;
  }

  Future<void> openMapDirection() async {
    double? destinationLatitude;
    double? destinationLongitude;
    switch (homeController.state.statusOfBooking.value) {
      case BOOKING_STATUS.ACCEPT:
        destinationLatitude = state.pickUpLocation.value?.latitudePosition;
        destinationLongitude = state.pickUpLocation.value?.longitudePosition;
        break;
      case BOOKING_STATUS.CHECKIN:
        break;
      case BOOKING_STATUS.ARRIVED:
        break;
      case BOOKING_STATUS.ONGOING:
        destinationLatitude = state.dropOffLocation.value?.latitudePosition;
        destinationLongitude = state.dropOffLocation.value?.longitudePosition;
        break;
      case BOOKING_STATUS.CHECKOUT:
        break;
      default:
        break;
    }
    final String googleMapUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude&travelmode=driving';
    final String appleMapUrl =
        'http://maps.apple.com/?saddr=Current+Location&daddr=$destinationLatitude,$destinationLongitude&directionsmode=driving';

    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else if (await canLaunch(appleMapUrl)) {
      await launch(appleMapUrl);
    } else {
      throw 'Không thể mở bản đồ';
    }
  }

  @override
  void onClose() {
    mapCompletePageController = Completer();
    controllerOfGoogleMap?.dispose();
    super.onClose();
  }
}
