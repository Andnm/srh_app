import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class DriverRegisterPage extends GetView<DriverRegisterController> {
  const DriverRegisterPage();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondElement,
        title: Text('Đăng ký tài khoản'),
      ),
      body: Container(
        height: size.height,
        decoration: BoxDecoration(color: AppColors.secondElement),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: 20.h),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: controller.emailController,
                    style: TextStyle(color: AppColors.primaryElementText),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle:
                          TextStyle(color: AppColors.primaryElementText),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryElement),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryElement),
                      ),
                    ),
                  ),
                  TextField(
                    controller: controller.userNameController,
                    style: TextStyle(color: AppColors.primaryElementText),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle:
                          TextStyle(color: AppColors.primaryElementText),
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
                    controller: controller.passwordController,
                    style: TextStyle(color: AppColors.primaryElementText),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle:
                          TextStyle(color: AppColors.primaryElementText),
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
                    controller: controller.confirmPasswordController,
                    style: TextStyle(color: AppColors.primaryElementText),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle:
                          TextStyle(color: AppColors.primaryElementText),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryElement),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryElement),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.primaryElement),
                      ),
                      child: Text(
                        'Đăng ký',
                        style: TextStyle(color: AppColors.primaryElementText),
                      ),
                      onPressed: () {
                        controller.handleDriverRegister();
                        // Handle registration logic here
                        // You can access the entered values using:
                        // _emailController.text
                        // _passwordController.text
                        // _confirmPasswordController.text
                      },
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
