import 'package:cus_dbs_app/pages/main/booking/widgets/service_info.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ServiceItem extends StatelessWidget {
  ServiceItem({
    Key? key,
    required this.icon,
    required this.name,
    required this.price,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  final String icon;
  final String name;
  final int price;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? AppColors.selectedColor : AppColors.whiteColor,
      child: Center(
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  icon,
                  width: 30.w,
                  height: 30.h,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Text(
                    //   price,
                    //   style: TextStyle(
                    //     fontSize: 18.sp,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {
                        Get.to(ServiceInfo());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
