import 'dart:convert';
import 'package:cus_dbs_app/common/widgets/custom_dropdown_field.dart';
import 'package:cus_dbs_app/common/widgets/custom_text_field.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_identity_card/_widget/document_identity.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_identity_card/index.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerUpdateIdentityPage
    extends GetView<CustomerUpdateIdentityController> {
  const CustomerUpdateIdentityPage();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              }),
          title: Text(controller.state.editMode.value
              ? "Chỉnh sửa căn cước"
              : "Căn cước công dân"),
          actions: [
            IconButton(
              icon: controller.state.editMode.value
                  ? Icon(Icons.cancel)
                  : Icon(Icons.edit),
              onPressed: () {
                controller.toggleEditMode();
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/identity_info.png",
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 20),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ảnh mặt trước',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              DocumentUploadGuidelinesIdentity(
                                showImagePickerOption: showImagePickerOption,
                                imageType: 'Front',
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              // ignore: unnecessary_null_comparison
                              controller.state.imageFront.value != null &&
                                      controller.state.imageFront.value != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        base64Decode(
                                          controller.state.imageFront.value,
                                        ),
                                        width: 140,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.grey[600],
                                            size: 40,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Tải ảnh lên',
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
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ảnh mặt sau',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              DocumentUploadGuidelinesIdentity(
                                showImagePickerOption: showImagePickerOption,
                                imageType: 'Behind',
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              // ignore: unnecessary_null_comparison
                              controller.state.imageBehind.value != null &&
                                      controller.state.imageBehind.value != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        base64Decode(
                                          controller.state.imageBehind.value,
                                        ),
                                        width: 140,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.grey[600],
                                            size: 40,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Tải ảnh lên',
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
                      ],
                    ),
                  ],
                ),
                // identityCardNumber
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.number,
                  labelText: "Mã CCCD",
                  prefixIcon: Icons.numbers,
                  controller: controller.identityCardNumberController,
                  readOnlyStatus: !controller.state.editMode.value,
                ),

                // Full name
                SizedBox(height: 20),
                CustomTextField(
                  labelText: "Họ và tên",
                  prefixIcon: Icons.person,
                  controller: controller.fullNameController,
                  inputType: TextInputType.text,
                  readOnlyStatus: !controller.state.editMode.value,
                ),

                // Ngày sinh
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.datetime,
                  labelText: "Ngày sinh",
                  prefixIcon: Icons.date_range,
                  controller: controller.dobController,
                  onChanged: (value) {
                    controller.state.errorDob.value = '';
                  },
                  onTap: () {
                    if (controller.state.editMode.value) {
                      controller.selectDobDate(context);
                      controller.state.errorDob.value = '';
                    } else {
                      // do nothing
                    }
                  },
                ),
                Text(
                  controller.state.errorDob.value.isNotEmpty
                      ? controller.state.errorDob.value
                      : '',
                  style: TextStyle(color: Colors.red),
                ),

                // Gender
                CustomDropdownField(
                  value: controller.state.gender.value.isNotEmpty
                      ? controller.state.gender.value
                      : null,
                  onChanged: controller.state.editMode.value
                      ? (String? newValue) {
                          controller.state.gender.value = newValue!;
                        }
                      : null,
                  labelText: 'Giới tính',
                  placeholderText: 'Lựa chọn giới tính',
                  editMode: controller.state.editMode.value,
                  items: controller.state.genderList,
                ),

                // nationality
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.text,
                  labelText: "Quốc tịch",
                  prefixIcon: Icons.language,
                  controller: controller.nationalityController,
                  readOnlyStatus: !controller.state.editMode.value,
                ),

                // place Origin
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.text,
                  labelText: "Quê quán",
                  prefixIcon: Icons.home,
                  controller: controller.placeOriginController,
                  readOnlyStatus: !controller.state.editMode.value,
                ),

                // place Residence
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.text,
                  labelText: "Nơi thường trú",
                  prefixIcon: Icons.home,
                  controller: controller.placeResidenceController,
                  readOnlyStatus: !controller.state.editMode.value,
                ),

                // personal identification
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.text,
                  labelText: "Đặc điểm nhận dạng",
                  prefixIcon: Icons.person_search_rounded,
                  controller: controller.personalIdentificationController,
                  readOnlyStatus: !controller.state.editMode.value,
                ),

                // expiredDate
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.datetime,
                  labelText: "Ngày hết hạn",
                  prefixIcon: Icons.date_range,
                  controller: controller.expiredDateController,
                  onTap: () {
                    if (controller.state.editMode.value) {
                      controller.selectExpiredDate(context);
                    } else {
                      // do nothing
                    }
                  },
                ),

                //  button
                SizedBox(height: 20),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        persistentFooterButtons: controller.state.editMode.value
            ? [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.primaryElement,
                      ),
                    ),
                    child: Text(
                      'Cập nhập',
                      style: TextStyle(color: AppColors.primaryElementText),
                    ),
                    onPressed: () {
                      controller.handleCustomerUpdateIdentityCard();
                    },
                  ),
                ),
              ]
            : null,
      ),
    );
  }

  void showImagePickerOption(BuildContext context, String imageType) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 7,
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
        );
      },
    );
  }
}
