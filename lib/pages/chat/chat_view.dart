import 'package:cached_network_image/cached_network_image.dart';
import 'package:cus_dbs_app/pages/chat/widgets/chat_list.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:cus_dbs_app/values/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'chat_controller.dart';

class ChatScreen extends GetView<ChatController> {
  ChatScreen();

  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(() {
        return Container(
          child: Text(
            "${controller.state.to_name}",
            overflow: TextOverflow.clip,
            maxLines: 1,
            style: TextStyle(
                fontFamily: "Avenir",
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
                fontSize: 16.sp),
          ),
        );
      }),
      actions: [
        GestureDetector(
          child: Container(
            width: 50.w,
            height: 50.w,
            padding: EdgeInsets.all(10.w),
            child: Icon(
              Icons.call,
              size: 30.w,
            ),
          ),
          onTap: () {
            controller.audioCall();
          },
        ),
        Container(
          margin: EdgeInsets.only(right: 20.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 44.h,
                height: 44.h,
                child: Obx(() {
                  return CachedNetworkImage(
                    imageUrl:
                        '${SERVER_API_URL}${controller.state.to_avatar.value}',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.h),
                          image: DecorationImage(image: imageProvider)),
                    ),
                    errorWidget: (context, url, error) => const Image(
                        image: AssetImage("assets/images/account_header.png")),
                  );
                }),
              ),
              Positioned(
                  bottom: 5.w,
                  right: 0.w,
                  height: 14.w,
                  child: Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                        color: controller.state.to_online.value == "1"
                            ? AppColors.primaryElementStatus
                            : AppColors.primarySecondaryElementText,
                        borderRadius: BorderRadius.circular(12.w),
                        border: Border.all(
                            width: 2, color: AppColors.primaryElementText)),
                  ))
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Stack(
            children: [
              ChatList(),
              Positioned(
                bottom: 0.h,
                child: Container(
                  width: 360.w,
                  padding:
                      EdgeInsets.only(left: 20.w, bottom: 10.h, right: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.w),
                              color: AppColors.primaryBackground,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(1, 1))
                              ]),
                          child: Image.asset("assets/icons/photo.png"),
                        ),
                        onTap: () {
                          controller.imgFromGallery();
                        },
                      ),
                      Container(
                        width: 270.w,
                        padding:
                            EdgeInsets.only(top: 10.h, bottom: 10.h, left: 5.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.primaryBackground,
                            border: Border.all(
                                color: AppColors.primarySecondaryElementText)),
                        child: Row(
                          children: [
                            Container(
                              width: 220.w,
                              child: TextField(
                                controller: controller.myInputController,
                                keyboardType: TextInputType.multiline,
                                autofocus: false,
                                decoration: InputDecoration(
                                    hintText: "Message....",
                                    contentPadding: EdgeInsets.only(
                                        left: 15.w, top: 0, bottom: 0),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    hintStyle: const TextStyle(
                                        color: AppColors
                                            .primarySecondaryElementText)),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                child: Image.asset("assets/icons/send.png"),
                              ),
                              onTap: () {
                                controller.sendMessage();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
