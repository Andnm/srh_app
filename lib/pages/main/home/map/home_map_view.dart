import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'index.dart';

class MapPage extends GetView<MapController> {
  const MapPage({super.key});
  HomeController get homeController => Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          if (homeController.isInitializedLocation.value)
            GoogleMap(
              padding: EdgeInsets.only(top: 26, bottom: 0),
              myLocationEnabled: controller.myLocationEnabled.value,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    controller.state.currentLocation.value.latitude ??
                        10.762622,
                    controller.state.currentLocation.value.longitude ??
                        106.660172),
                zoom: 15.5,
              ),
              polylines: controller.state.polylineSet.value,
              circles: controller.state.circleSet,
              markers: controller.state.markerSet.value,
              onMapCreated: (GoogleMapController mapController) async {
                try {
                  controller.controllerOfGoogleMap = mapController;
                  controller.updateMapTheme(controller.controllerOfGoogleMap!);
                  if (!controller.mapCompletePageController.isCompleted) {
                    controller.mapCompletePageController
                        .complete(controller.controllerOfGoogleMap);
                  }
                  await controller.getCurrentLocation(() async {
                    if (AppRoles.isDriver) {
                      await controller.initDataDriver();
                    } else {
                      controller.initDataCustomer();
                    }
                  });
                  Get.find<HomeController>().isShowWidgets.value = true;
                } catch (e) {
                  print("Error in onMapCreated: $e");
                  // Handle the exception or show an error message
                }
              },
            ),
        ],
      ),
    );
  }
}
