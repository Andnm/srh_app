import 'dart:convert';

import 'package:cus_dbs_app/pages/main/account/driver/driving_license/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverDlcPage extends GetView<DriverDlcController> {
  const DriverDlcPage();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              }),
          title: Text("Bằng lái xe"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/identity_info.png",
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 20),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ảnh mặt trước',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            //
                          },
                          child: Stack(
                            children: [
                              // ignore: unnecessary_null_comparison
                              controller.state.imageFront.value != null &&
                                      controller.state.imageFront.value != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        base64Decode(
                                          controller.state.imageFront.value,
                                        ),
                                        width: 140,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.grey[600],
                                            size: 40,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Tải ảnh lên',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ảnh mặt sau',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            //
                          },
                          child: Stack(
                            children: [
                              // ignore: unnecessary_null_comparison
                              controller.state.imageBehind.value != null &&
                                      controller.state.imageBehind.value != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        base64Decode(
                                          controller.state.imageBehind.value,
                                        ),
                                        width: 140,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.grey[600],
                                            size: 40,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Tải ảnh lên',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Full name
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Loại bằng lái xe",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.card_membership),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]!),
                    ),
                  ),
                  controller: controller.typeController,
                  readOnly: !controller.state.editMode.value,
                ),

                // Ngày sinh
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: "Ngày cấp",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]!),
                    ),
                  ),
                  controller: controller.issueDateController,
                  onChanged: (value) {
                    controller.state.errorDob.value = '';
                  },
                  readOnly: true,
                  onTap: () {
                    if (controller.state.editMode.value) {
                      controller.selectIssueDate(context);
                      controller.state.errorDob.value = '';
                    } else {
                      // do nothing
                    }
                  },
                ),
                Text(
                  controller.state.errorDob.value.isNotEmpty
                      ? controller.state.errorDob.value
                      : '',
                  style: TextStyle(color: Colors.red),
                ),

                // expiredDate
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: "Ngày hết hạn",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]!),
                    ),
                  ),
                  controller: controller.expiredDateController,
                  readOnly: true,
                  onTap: () {
                    if (controller.state.editMode.value) {
                      controller.selectExpiredDate(context);
                    } else {
                      // do nothing
                    }
                  },
                ),

                //  button
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
