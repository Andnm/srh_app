import 'dart:io';
import 'dart:typed_data';

import 'package:cus_dbs_app/app/booking_status_type.dart';
import 'package:cus_dbs_app/app/search_request_status_type.dart';
import 'package:cus_dbs_app/common/entities/driver.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_booking_request.dart';
import 'package:cus_dbs_app/common/entities/vehicle.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/payment_method_type.dart';
import '../../../common/entities/customer.dart';
import '../../../common/entities/search_request_model.dart';
import '../../../store/user_store.dart';

class HomeState {
  Rx<bool> isRoleDriver = AppRoles.isDriver.obs;
  Rx<BOOKING_STATUS> statusOfBooking = BOOKING_STATUS.PENDING.obs;
  Rx<String> statusOfPayment = "".obs;
  Rx<SEARCH_REQUEST_STATUS> statusOfSearchRequest =
      SEARCH_REQUEST_STATUS.PROCESSING.obs;
  CustomerItem customerPersonalInfo = UserStore.to.getCustomerProfile();
  DriverItem driverPersonalInfo = UserStore.to.getDriverProfile();
  //Booking
  Rx<NotificationBookingModel?> appBookingData = NotificationBookingModel().obs;

  //Driver
  Rx<DRIVER_STATUS> stateOfDriver = DRIVER_STATUS.ONLINE.obs;
  Rx<Color> colorToShow = Colors.pink.obs;
  Rx<String> titleToShow = "OFFLINE".obs;
  Rx<bool> isAvailableDriver = false.obs;
  Rx<VehicleItem> requestVehicle = VehicleItem().obs;
  Rx<Uint8List?> bookedOnBehalfVehicleImage = Rx<Uint8List?>(null);
  CustomerBookedOnBehalf requestCustomerBookedOnBehalf =
      CustomerBookedOnBehalf();
  SearchRequestModel requestSearchRequestModel = SearchRequestModel();
  RxInt priceOfSearchRequest = 0.obs;
  RxList<File> imageFiles = RxList<File>();
  RxBool isFemaleDriver = false.obs;

  //Customer

  RxList<OnlineNearByDriver> availableNearbyOnlineDriversList =
      <OnlineNearByDriver>[OnlineNearByDriver(email: ' hehe@gmail.com')].obs;
}
