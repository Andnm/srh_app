import 'package:cus_dbs_app/pages/auth/customer/signin/_widgets/create_info.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class CustomerSignInPage extends GetView<CustomerSignInController> {
  const CustomerSignInPage({super.key});

  // Widget _buildThirdPartyLogin(String loginType, String logo) {
  //   // Implement _buildThirdPartyLogin method
  // }

  Widget _buildHeader() {
    return Container(
      height: 120.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/icons/icon.png"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Obx(() {
      if (controller.selectedLoginMethod.value == 'email') {
        return _buildEmailForm();
      } else {
        return _buildPhoneForm();
      }
    });
  }

  Widget _buildEmailForm() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30.w),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        TextField(
          controller: controller.myInputEmailController,
          style: TextStyle(color: AppColors.primaryText),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(color: AppColors.primaryText),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryElement),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryElement),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        TextField(
          controller: controller.myInputPasswordController,
          style: TextStyle(color: AppColors.primaryText),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: AppColors.primaryText),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryElement),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryElement),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(
                'Quên mật khẩu?',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.primaryText,
                ),
              ),
              onPressed: () {
                // Navigate to password reset page
              },
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Container(
          height: 46.h,
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColors.primaryElement),
            ),
            child: const Text(
              "Đăng nhập",
              style: TextStyle(color: AppColors.primaryElementText),
            ),
            onPressed: () {
              controller.handleCustomerSignIn("userNameAndPassword");
            },
          ),
        ),
        TextButton(
          child: Text(
            'Đăng nhập bằng số điện thoại',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.primaryText,
            ),
          ),
          onPressed: () {
            controller.selectedLoginMethod.value = 'phone';
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bạn chưa có tài khoản?'),
            TextButton(
              child: Text(
                'Đăng ký',
                style: TextStyle(
                  color: AppColors.primaryText,
                ),
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.customerRegister);
              },
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildPhoneForm() {
    return Container(
      padding: EdgeInsets.all(15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.textFieldColor,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: Get.width * 0.1,
                        child: Image.asset(
                          'assets/images/vietnam_flag.jpeg',
                          width: 25.w,
                          height: 15.h,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: Get.width * 0.1,
                        child: const Text(
                          '+84',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  height: 50.h,
                  width: 250.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: AppColors.textFieldColor,
                  ),
                  child: TextField(
                    style: TextStyle(color: AppColors.primaryText),
                    keyboardType: TextInputType.phone,
                    controller: controller.myInputPhoneController,
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintText: "0 123 456789 ",
                      hintStyle: TextStyle(
                        color: AppColors.primaryText.withOpacity(0.3),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.h),
          Container(
            height: 46.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.primaryElement),
              ),
              child: const Text(
                "Đăng nhập bằng số điện thoại",
                style: TextStyle(color: AppColors.primaryElementText),
              ),
              onPressed: () async {
                if (controller.isValidPhoneNumberWhenLogin() == true) {
                  controller.handleCustomerSignIn("phoneNumber");
                }
              },
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                "Hoặc tiếp tục với",
                style: TextStyle(
                  color: AppColors.primaryText,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            height: 46.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.primaryBackground),
                side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              child: const Text(
                "Đăng nhập bằng tài khoản",
                style: TextStyle(color: AppColors.primaryText),
              ),
              onPressed: () {
                controller.selectedLoginMethod.value = 'email';
              },
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            height: 46.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.primaryBackground),
                side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/google.png",
                    width: 24.w,
                    height: 24.h,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Đăng nhập bằng Google",
                    style: TextStyle(color: AppColors.primaryText),
                  ),
                ],
              ),
              onPressed: () {
                controller.handleCustomerSignIn("google");
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(),
              _buildLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
