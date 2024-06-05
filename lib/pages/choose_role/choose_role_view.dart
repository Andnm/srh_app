import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/themes/theme.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../values/roles.dart';

class ChooseRole extends StatelessWidget {
  const ChooseRole({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorSchemes.background,
      body: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/city.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7), BlendMode.darken),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 100.h,
                  left: 0,
                  right: 0,
                  // bottom: 0,
                  child: Column(
                    children: [
                      Container(
                        height: 120.h,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icons/icon.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text(
                        'SecureRideHome',
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              color: AppColors.surfaceWhite.withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp),
                        ),
                      ),
                    ],
                  )),
              Positioned(
                  bottom: 25.h,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              "Đăng ký hoặc đăng nhập với",
                              style: TextStyle(
                                  color: AppColors.surfaceWhite,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(child: Divider())
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: 300.w, // Đặt chiều rộng cho nút
                        child: ElevatedButton(
                          onPressed: () {
                            AppRoles.roles?.clear();
                            AppRoles.roles?.add(AppRoles.customerRole);

                            Get.toNamed(AppRoutes.customerSignIn);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity,
                                50), // Kích thước tối thiểu của nút
                            padding: EdgeInsets.symmetric(
                                vertical: 16), // Padding cho nút
                          ),
                          child: Text(
                            'Khách hàng',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: 300.w, // Đặt chiều rộng cho nút
                        child: ElevatedButton(
                          onPressed: () {
                            AppRoles.roles?.clear();
                            AppRoles.roles?.add(AppRoles.driverRole);

                            Get.toNamed(AppRoutes.driverSignIn);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity,
                                50), // Kích thước tối thiểu của nút
                            padding: EdgeInsets.symmetric(
                                vertical: 16), // Padding cho nút
                          ),
                          child: Text(
                            'Tài xế',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          )),
    );
  }
}
