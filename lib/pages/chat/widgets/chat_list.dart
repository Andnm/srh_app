import 'package:cus_dbs_app/pages/chat/chat_controller.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'chat_left_list.dart';
import 'chat_right_list.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: AppColors.primaryBackground,
          padding: EdgeInsets.only(bottom: 90.h),
          child: GestureDetector(
              child: CustomScrollView(
                controller: controller.myScrollController,
                reverse: true,
                slivers: [
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        var item = controller.state.msgcontentList[index];
                        if (controller.userId == item.messageFrom) {
                          return ChatRightList(item, controller.token!);
                        }
                        return ChatLeftList(item, controller.token!);
                      }, childCount: controller.state.msgcontentList.length),
                    ),
                  ),
                  SliverPadding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                      sliver: SliverToBoxAdapter(
                          child: controller.state.isLoading.value
                              ? const Align(
                                  alignment: Alignment.center,
                                  child: Text("loading..."),
                                )
                              : Container()))
                ],
              ),
              onTap: () {
                controller.closeAllPop();
              }),
        ));
  }
}
