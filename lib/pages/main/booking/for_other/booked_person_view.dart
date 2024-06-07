import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/entities/car_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../home/home_controller.dart';

import 'package:cus_dbs_app/common/widgets/custom_text_field.dart';

import 'booked_person_controller.dart';

class BookedPersonInformationPage extends GetView<BookedPersonController> {
  BookedPersonInformationPage({super.key});

  HomeController get homeController => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: !homeController.isBottomSheet.value,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.surfaceWhite, //change your color here
        ),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            if (homeController.isBottomSheet.value) {
              homeController.isBottomSheet.value = false;
              Get.back();
            } else {
              Get.back();
            }
          },
        ),
        title: !homeController.isBottomSheet.value
            ? Text(
                'Đặt hộ',
                style: TextStyle(color: AppColors.surfaceWhite),
              )
            : SizedBox(),
        actions: [
          Obx(
            () => homeController.isBottomSheet.value
                ? IconButton(
                    icon: controller.editMode.value
                        ? Icon(Icons.cancel)
                        : Icon(Icons.edit),
                    onPressed: () {
                      controller.editMode.value = !controller.editMode.value;
                    },
                  )
                : SizedBox(),
          ),
        ],
        backgroundColor: AppColors.primaryElement,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            return Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 26.0.h, horizontal: 16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Thông tin khách hàng',
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 30.h),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        showImagePickerOption(context, 'CustomerOnBehalfImage');
                      },
                      child: Stack(
                        children: [
                          controller.addCustomerOnBehalfImage.value != null
                              ? Container(
                                  width: 250.w,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: MemoryImage(controller
                                          .addCustomerOnBehalfImage.value!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 250.w,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.grey[600],
                                        size: 40,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Ảnh khách hàng',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      labelText: "Tên khách hàng *",
                      labelStyle: TextStyle(fontSize: 14.sp),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.0.h,
                        horizontal: 12.0.w,
                      ),
                    ),
                    style: TextStyle(fontSize: 16.sp),
                    onChanged: (value) {
                      controller.updateAllFieldsValid();
                    },
                  ),
                  SizedBox(height: 16.0.h),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Số điện thoại *",
                      labelStyle: TextStyle(fontSize: 14.sp),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.0.h,
                        horizontal: 12.0.w,
                      ),
                    ),
                    style: TextStyle(fontSize: 16.sp),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: controller.phoneNumberController,
                    onChanged: (value) {
                      controller.updateAllFieldsValid();
                    },
                  ),
                  if (controller.phoneNumberController.text.isNotEmpty &&
                      !controller.isValidPhoneNumber(
                          controller.phoneNumberController.text))
                    Text(
                      "Số điện thoại không hợp lệ",
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 16.0.h),
                  TextField(
                    controller: controller.noteController,
                    decoration: InputDecoration(
                      labelText: "Ghi chú",
                      labelStyle: TextStyle(fontSize: 14.sp),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.0.h,
                        horizontal: 12.0.w,
                      ),
                    ),
                    style: TextStyle(fontSize: 16.sp),
                    onChanged: (value) {
                      controller.updateAllFieldsValid();
                    },
                  ),

                  SizedBox(height: 30.h),
                  Center(
                      child: Center(
                    child: Text(
                      'Thông tin phương tiện',
                      style: TextStyle(
                        fontSize: 19.6.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        showImagePickerOption(context, 'Front');
                      },
                      child: Stack(
                        children: [
                          controller.addImageFront.value != null
                              ? Container(
                                  width: 250.w,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: MemoryImage(
                                          controller.addImageFront.value!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 250.w,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.grey[600],
                                        size: 40,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Ảnh phương tiện',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),

                  // Biển số xe
                  SizedBox(height: 20),
                  CustomTextField(
                    labelText: "Biển số xe",
                    prefixIcon: Icons.person,
                    controller: controller.licensePlateController,
                    inputType: TextInputType.text,
                    readOnlyStatus: !controller.editMode.value,
                    onChanged: (value) {
                      controller.licensePlateController.text = value;

                      controller.updateAllFieldsValid();
                    },
                  ),

                  // brand
                  SizedBox(height: 20),
                  CustomTextField(
                    labelText: "Nhãn hiệu",
                    prefixIcon: Icons.language,
                    controller: controller.brandController,
                    inputType: TextInputType.text,
                    readOnlyStatus: true,
                    onTap: () async {
                      if (controller.editMode.value) {
                        await controller.fetchAllBrandOfCarFromApi();
                        showBrandOfCarList(context);
                      }
                    },
                  ),

                  // model
                  SizedBox(height: 20),
                  CustomTextField(
                    labelText: "Loại xe",
                    prefixIcon: Icons.home,
                    controller: controller.modelController,
                    inputType: TextInputType.text,
                    readOnlyStatus: true,
                    onTap: () async {
                      if (controller.editMode.value) {
                        if (controller.checkBrandValueExisted()) {
                          await controller.fetchAllModelOfBrandFromApi();
                          showModelOfBrandList(context);
                        }
                      }
                    },
                  ),
                  if (controller.errorSelectedModel.value.isNotEmpty)
                    Text(
                      controller.errorSelectedModel.value,
                      style: TextStyle(color: Colors.red),
                    ),

                  // màu xe color
                  SizedBox(height: 20),
                  CustomTextField(
                    labelText: "Màu xe",
                    prefixIcon: Icons.color_lens,
                    controller: controller.colorController,
                    inputType: TextInputType.text,
                    readOnlyStatus: !controller.editMode.value,
                    onChanged: (value) {
                      controller.colorController.text = value;
                      controller.updateAllFieldsValid();
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
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
                          color: controller.allFieldsValid.value
                              ? AppColors.whiteColor
                              : AppColors.textFieldColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      onPressed: controller.allFieldsValid.value
                          ? controller.submit
                          : null,
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context, String imageType) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColors.dialogColor,
      context: context,
      builder: (builder) {
        return Wrap(children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.pickImageFromGallery(context, imageType);
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text("Gallery")
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.pickImageFromCamera(context, imageType);
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text("Camera")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]);
      },
    );
  }

  void showBrandOfCarList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Chọn nhãn hiệu xe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: controller.state.dataBrands.value
                            .map((brand) => Column(
                                  children: [
                                    _buildSelectedBrandOption(
                                      context,
                                      brand,
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSelectedBrandOption(
    BuildContext context,
    BrandEntity brand,
  ) {
    return InkWell(
      onTap: () {
        controller.changeBrandSelection(brand);
        controller.updateAllFieldsValid();
        Get.back();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Image.asset(
              controller.getBrandLogoPath(brand.brandName ?? ""),
              height: 30,
              width: 30,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                brand.brandName ?? 'Không xác định',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Spacer(),
            if (controller.selectedBrand.value == brand.brandName)
              Icon(
                Icons.check,
                color: Colors.blue.shade400,
              ),
          ],
        ),
      ),
    );
  }

  void showModelOfBrandList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Chọn loại xe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: controller.state.dataModels.value
                            .map(
                              (model) => Column(
                                children: [
                                  _buildSelectedModelOption(
                                    context,
                                    model.modelName ?? "",
                                  )
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSelectedModelOption(
    BuildContext context,
    String modelName,
  ) {
    return InkWell(
      onTap: () {
        controller.changeModelSelection(modelName);
        controller.updateAllFieldsValid();
        Get.back();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            // Image.asset(
            //   'assets/icons/vnpay.png',
            //   height: 25,
            //   width: 25,
            //   fit: BoxFit.cover,
            // ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                modelName,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Spacer(),
            if (controller.selectedModel.value == modelName)
              Icon(
                Icons.check,
                color: Colors.blue.shade400,
              ),
          ],
        ),
      ),
    );
  }
}
