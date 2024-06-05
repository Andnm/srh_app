import 'package:cached_network_image/cached_network_image.dart';
import 'package:cus_dbs_app/common/entities/msg_content.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:cus_dbs_app/values/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

Widget ChatLeftList(Msgcontent item, String token) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 20.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250.w, minHeight: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: BorderRadius.all(Radius.circular(5.w)),
                ),
                padding: _getContainerPadding(item.type),
                child: _buildContent(item, token),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

EdgeInsetsGeometry _getContainerPadding(String? type) {
  if (type == "Message") {
    return EdgeInsets.only(top: 10.w, bottom: 10.w, left: 10.w, right: 10.w);
  } else if (type == "CallSuccess" || type == "CallMissed") {
    return EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w);
  } else {
    return EdgeInsets.all(0);
  }
}

Widget _buildContent(Msgcontent item, String token) {
  switch (item.type) {
    case "Image":
      return CachedNetworkImage(
        httpHeaders: {
          'Authorization': 'Bearer ${token}',
        },
        imageUrl: '${SERVER_API_NOTI_URL}${item.content!}',
        height: 160.w,
        width: 160.w,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider),
          ),
        ),
      );
    case "CallSuccess":
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryText.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(5.w),
            child: Icon(
              Icons.call,
              size: 16.w,
              color: AppColors.whiteColor,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            item.content!,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.primaryText,
            ),
          ),
        ],
      );
    case "CallMissed":
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.errorRed,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(5.w),
            child: Icon(
              Icons.phone_missed,
              size: 16.w,
              color: AppColors.whiteColor,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            item.content!,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.primaryText,
            ),
          ),
        ],
      );
    case "Message":
      return Text(
        item.content!,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.primaryText,
        ),
      );
    default:
      return Text(
        item.content!,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.primaryText,
        ),
      );
  }
}
