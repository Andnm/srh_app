// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cus_dbs_app/pages/main/home/map/values/api_map_constants.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../routes/routes.dart';
import '../entities/direction_detail.dart';

class CommonMethods {
  // turnOffLocationUpdatesForHomePage() {
  //   positionStreamHomePage!.pause();
  //
  //   Geofire.removeLocation(FirebaseAuth.instance.currentUser!.uid);
  // }
  //
  // turnOnLocationUpdatesForHomePage() {
  //   positionStreamHomePage!.resume();
  //
  //   Geofire.setLocation(
  //     FirebaseAuth.instance.currentUser!.uid,
  //     driverCurrentPosition!.latitude,
  //     driverCurrentPosition!.longitude,
  //   );
  // }

  static void checkRedirectRole({parameters}) {
    if (AppRoles.isRegister) {
      if (AppRoles.isDriver) {
        Get.offAllNamed(AppRoutes.main, parameters: parameters);
      } else {
        Get.offAllNamed(AppRoutes.mainCustomer, parameters: parameters);
      }
    } else {
      Get.offAllNamed(AppRoutes.chooseRole);
    }
  }

  static Future<dynamic> sendRequestToGoogleMapdAPI(String apiUrl) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      var responseFromAPI = await Dio().get(apiUrl);
      if (responseFromAPI.statusCode == 200) {
        dynamic dataFromApi = responseFromAPI.data;
        return dataFromApi;
      } else {
        return "error";
      }
    } catch (errorMsg) {
      print(errorMsg);
      return "error";
    }
  }
}
