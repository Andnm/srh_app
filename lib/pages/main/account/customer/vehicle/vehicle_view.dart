import 'dart:convert';

import 'package:cus_dbs_app/pages/main/account/customer/vehicle/_widget/add_new_vehicle.dart';
import 'package:cus_dbs_app/pages/main/account/customer/vehicle/_widget/update_vehicle.dart';
import 'package:cus_dbs_app/pages/main/account/customer/vehicle/vehicle_controller.dart';
import 'package:cus_dbs_app/values/server.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehiclePage extends GetView<VehicleController> {
  const VehiclePage();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              }),
          title: Text("Xe của tôi"),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  ...controller.state.dataVehicles.value.map((vehicle) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UpdateVehiclePage(vehicle: vehicle),
                          ),
                        );

                        controller.resetVehicleFormDataInput();
                        controller.handleSelectedVehicle(vehicle);
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        child: Stack(
                          children: [
                            if (vehicle.imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  '${SERVER_API_URL}${vehicle.imageUrl ?? ''}',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Container(
                                width: 150,
                                height: 150,
                                padding: EdgeInsets.only(left: 8, bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                child: Text(
                                  '${vehicle.brand ?? ''} ${vehicle.model ?? ''}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow:
                                      TextOverflow.ellipsis, // Cắt ngắn văn bản
                                  maxLines: 2, // Giới hạn số dòng
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  GestureDetector(
                    onTap: () {
                      Get.to(AddNewVehiclePage());
                      controller.resetVehicleFormDataInput();
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade500),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.blue[500],
                            size: 40,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Thêm phương tiện mới',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
