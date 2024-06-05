import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../values/server.dart';
import 'controller.dart';

class VoicePage extends GetView<VoiceController> {
  const VoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: Obx(() => Container(
            child: Stack(
              children: [
                Positioned(
                    top: 60.h,
                    left: 30.w,
                    right: 30.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            // child: Text(
                            //   controller.state.callTime.value,
                            //   style: TextStyle(
                            //       color: AppColors.primaryElementText,
                            //       fontSize: 14.sp,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            ),
                        Container(
                            margin: EdgeInsets.only(top: 10.h),
                            child: Text(
                              controller.state.to_name.value,
                              style: TextStyle(
                                  color: AppColors.primaryElementText,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.sp),
                            )),
                        Container(
                          width: 200.h,
                          height: 200.h,
                          margin: EdgeInsets.only(top: 120.h),
                          child: CircleAvatar(
                            radius: 30.0.r,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                                '${SERVER_API_URL}${controller.state.to_avatar.value}'),
                          ),
                        ),
                      ],
                    )),
                Positioned(
                    bottom: 100.h,
                    left: 30.w,
                    right: 30.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                  padding: EdgeInsets.all(15.w),
                                  width: 60.w,
                                  height: 60.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.w)),
                                      color:
                                          controller.state.openMicrophone.value
                                              ? AppColors.primaryElementText
                                              : AppColors.primaryText),
                                  child: Image.asset(
                                      "assets/icons/b_microphone.png",
                                      color:
                                          controller.state.openMicrophone.value
                                              ? Colors.black
                                              : Colors.white)),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.h),
                              child: Text(
                                "Microphone",
                                style: TextStyle(
                                    color: AppColors.primaryElementText,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.state.isJoined.value
                                    ? controller.leaveChannel()
                                    : controller.joinChannel();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(15.w),
                                  width: 60.w,
                                  height: 60.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.w)),
                                      color: controller.state.isJoined.value
                                          ? AppColors.primaryElementBg
                                          : AppColors.primaryElementStatus),
                                  child: Image.asset("assets/icons/b_phone.png",
                                      color: Colors.white)),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.h),
                              child: Text(
                                controller.state.isJoined.value
                                    ? "Disconnect"
                                    : "Connect",
                                style: TextStyle(
                                    color: AppColors.primaryElementText,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.toggleSpeaker();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(15.w),
                                  width: 60.w,
                                  height: 60.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.w)),
                                      color: AppColors.primaryElementText),
                                  child: controller.state.enableSpeaker.value
                                      ? Icon(
                                          Icons.volume_up,
                                          size: 30.w,
                                        )
                                      : Icon(Icons.volume_off, size: 30.w)),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.h),
                              child: Text(
                                "Speaker",
                                style: TextStyle(
                                    color: AppColors.primaryElementText,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          ],
                        )
                      ],
                    ))
              ],
            ),
          )),
    );
  }
}
