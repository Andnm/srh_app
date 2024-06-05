import 'package:cus_dbs_app/common/entities/address_model.dart';
import 'package:cus_dbs_app/common/entities/prediction_model.dart';
import 'package:cus_dbs_app/pages/main/home/map/values/api_map_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../common/methods/common_methods.dart';
import '../home_controller.dart';
import 'search_state.dart';

class SearchBookingController extends GetxController {
  final state = SearchState();
  final textAddress = Get.arguments as String;
  HomeController get homeController => Get.find<HomeController>();
  @override
  Future<void> onInit() async {
    super.onInit();
    if (textAddress.isNotEmpty) {
      state.textSearchCl.text = textAddress;
    }
  }

  searchLocation(String locationName, {bool isPick = true}) async {
    if (locationName.length > 1) {
      String apiPlacesUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$locationName&key=$GOOGLE_MAP_API_KEY&components=country:vn&location=10.7769,106.7009&radius=20000";

      var responseFromPlacesAPI =
          await CommonMethods.sendRequestToGoogleMapdAPI(apiPlacesUrl);

      if (responseFromPlacesAPI == "error") {
        print('Error to request Places API');
        return;
      }
      print('responseFromPlacesAPI:' + responseFromPlacesAPI.toString());
      if (responseFromPlacesAPI["status"] == "OK") {
        var predictionResultInJson = responseFromPlacesAPI["predictions"];
        var predictionsList = (predictionResultInJson as List)
            .map((eachPlacePrediction) =>
                PredictionModel.fromJson(eachPlacePrediction))
            .toList();
        state.dropOffPredictionsPlacesList.value = predictionsList;
      }
    }
  }

  updateAddress(String placeId) async {
    // if (state.isPick) {
    //   state.textSearchPickCl.text = address;
    // } else {
    //   state.textSearchDropOffCl.text = address;
    // }
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);

    String urlPlaceDetailsAPI =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GOOGLE_MAP_API_KEY";

    var responseFromPlaceDetailsAPI =
        await CommonMethods.sendRequestToGoogleMapdAPI(urlPlaceDetailsAPI);
    print('API RESPONSE $responseFromPlaceDetailsAPI ');
    //Navigator.pop(context);

    if (responseFromPlaceDetailsAPI == "error") {
      return;
    }

    if (responseFromPlaceDetailsAPI["status"] == "OK") {
      AddressModel dropOffLocation = AddressModel();

      dropOffLocation.placeName = responseFromPlaceDetailsAPI["result"]["name"];
      dropOffLocation.latitudePosition =
          responseFromPlaceDetailsAPI["result"]["geometry"]["location"]["lat"];
      dropOffLocation.longitudePosition =
          responseFromPlaceDetailsAPI["result"]["geometry"]["location"]["lng"];
      dropOffLocation.placeID = placeId;
      dropOffLocation.isPick = state.isPick;

      print('TEST');
      // await homeCustomerController.retrieveCustomerDirectionDetails(
      //     pickUpLocation: mapPageController.state.pickUpLocation.value ?? AddressModel(), dropOffLocation: mapPageController.state.dropOffLocation.value ?? AddressModel());

      //await customerHomeController.getAvailableNearbyOnlineDriversOnMap();
      EasyLoading.dismiss();
      // await homeController.retrieveDirectionDetails();

      Get.back(result: dropOffLocation);
    }
  }

  @override
  void dispose() async {
    super.dispose();
  }
}
