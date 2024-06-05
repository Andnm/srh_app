import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import 'package:cus_dbs_app/pages/main/home/map/home_map_controller.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'search_controller.dart';
import 'widget/prediction_place_ui.dart';

class SearchDestinationPage extends GetView<SearchBookingController> {
  HomeController get _homeController => Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: AppColors.textFieldColor,
              child: Container(
                height: 150.w,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textFieldColor,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 5.w, top: 48.h, right: 10.w, bottom: 10.h),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 6.h,
                      ),

                      //icon button - title
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors
                                  .primaryText, // Sử dụng màu primaryElementText
                            ),
                          ),
                          Center(
                            child: Text(
                              "Địa chỉ",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                  overflow: TextOverflow
                                      .ellipsis // Sử dụng màu primaryElementText
                                  ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 18.h,
                      ),
                      //destination text field
                      Row(
                        children: [
                          SizedBox(
                            width: 18.w,
                          ),
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  maxLines: 1,
                                  autofocus: true,
                                  controller: controller.state.textSearchCl,
                                  onChanged: (inputText) {
                                    controller.searchLocation(inputText,
                                        isPick: false);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Nhập địa chỉ",
                                    fillColor: Colors.grey[300],
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0.r),
                                      borderSide: BorderSide.none,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                        left: 11.w, top: 9.h, bottom: 9.h),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //display prediction results for destination place
            Obx(
              () => (controller.state.dropOffPredictionsPlacesList.length > 0)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          return PredictionPlaceUI(
                            predictedPlaceData: controller
                                .state.dropOffPredictionsPlacesList[index],
                            clickItem: (item) async {
                              controller.updateAddress(item?.place_id ?? '');
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(
                          height: 2,
                        ),
                        itemCount: controller
                            .state.dropOffPredictionsPlacesList.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                      ))
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
