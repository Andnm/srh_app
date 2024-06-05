import 'dart:io';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/apis/customer_api.dart';
import '../../../../common/apis/driver_api.dart';
import '../../../../routes/routes.dart';
import '../../../../values/booking.dart';
import '../../../../values/colors.dart';
import '../../home/home_controller.dart';
import '../../home/widget/customer/home_customer.dart';

class CancelReasonPage extends StatefulWidget {
  CancelReasonPage();

  @override
  _CancelReasonPageState createState() => _CancelReasonPageState();
}

class _CancelReasonPageState extends State<CancelReasonPage> {
  HomeController get homeController => Get.find<HomeController>();

  List<String> predefinedReasonsForCustomer = [
    'Tài xế quá xa',
    'Thay đổi lịch trình',
    'Tìm thấy phương tiện khác',
    'Khác',
  ];

  List<String> predefinedReasonsForDriver = [
    'Không liên lạc được khách hàng',
    'Khách hàng yêu cầu hủy',
    'Sự cố phương tiện',
    'Tắc đường',
    'Khác',
  ];

  List<String> get predefinedReasons {
    return AppRoles.isDriver
        ? predefinedReasonsForDriver
        : predefinedReasonsForCustomer;
  }

  Future<void> captureImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        homeController.capturedImages.add(File(pickedImage.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: Get.height,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    'Vui lòng chọn lý do hủy chuyến:',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: predefinedReasons.length,
                    itemBuilder: (context, index) {
                      String reason = predefinedReasons[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            homeController..selectedReason = reason;
                          });
                        },
                        child: Card(
                          color: homeController.selectedReason == reason
                              ? Colors.blue[100]
                              : null,
                          elevation:
                              homeController.selectedReason == reason ? 8 : 2,
                          child: ListTile(
                            title: Text(reason),
                          ),
                        ),
                      );
                    },
                  ),
                  if (homeController.selectedReason == 'Khác')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: homeController.otherReasonController,
                          maxLength: 50,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Nhập lý do khác...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                      ),
                    ),
                  if (AppRoles.isDriver) ...[
                    SizedBox(height: 16),
                    Text(
                      'Chụp ảnh:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: homeController.capturedImages.length < 4
                          ? homeController.capturedImages.length + 1
                          : 4,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: index == homeController.capturedImages.length
                              ? captureImage
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: index < homeController.capturedImages.length
                                ? Image.file(
                                    homeController.capturedImages[index],
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.camera_alt),
                          ),
                        );
                      },
                    ),
                  ],
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: homeController.isResponsedBooking.value
                              ? null
                              : () async {
                                  homeController.cancelBooking();
                                },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 30.w),
                            backgroundColor: AppColors.primaryElement,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          child: Text(
                            'Xác nhận',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textFieldColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
