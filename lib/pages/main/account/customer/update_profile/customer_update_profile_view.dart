import 'dart:convert';

import 'package:cus_dbs_app/common/widgets/custom_dropdown_field.dart';
import 'package:cus_dbs_app/common/widgets/custom_text_field.dart';
import 'package:cus_dbs_app/pages/main/account/account_controller.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_profile/customer_update_profile_controller.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:cus_dbs_app/values/server.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cus_dbs_app/store/user_store.dart';

// ignore: must_be_immutable
class CustomerUpdateProfilePage
    extends GetView<CustomerUpdateProfileController> {
  CustomerUpdateProfilePage();
  String? customerEmail = UserStore.to.customerProfile.email;

  AccountController get _accountController => Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                Get.back();
                controller.clearData();
                await _accountController.fetchCustomerProfileFromApi();
              }),
          title: Text(controller.state.editMode.value
              ? "Chỉnh sửa thông tin"
              : "Thông tin cá nhân"),
          backgroundColor: Colors.white,
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          // ignore: unnecessary_null_comparison
                          child:
                              controller.state.selectedAvatarBase64.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(controller
                                          .state.selectedAvatarBase64.value),
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : controller.state.avatar.value != null &&
                                          controller.state.avatar.value != ''
                                      ? Image.network(
                                          '${SERVER_API_URL}${controller.state.avatar.value}',
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 150,
                                          height: 150,
                                          color: Colors.grey,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                        ),
                        ),
                      ),
                    ),
                    if (controller.state.editMode.value)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            showImagePickerOption(context);
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.blue.shade400,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  controller.state.name.value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$customerEmail',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                /// -- BUTTON
                const Divider(),
                const SizedBox(height: 10),

                /// -- MENU
                // name
                CustomTextField(
                  labelText: "Họ và tên",
                  prefixIcon: Icons.person,
                  controller: controller.nameController,
                  inputType: TextInputType.text,
                  readOnlyStatus: !controller.state.editMode.value,
                ),
                SizedBox(height: 20),

                // address
                CustomTextField(
                  inputType: TextInputType.text,
                  labelText: "Địa chỉ",
                  prefixIcon: Icons.email,
                  controller: controller.addressController,
                  readOnlyStatus: !controller.state.editMode.value,
                ),
                SizedBox(height: 20),

                // phone number
                CustomTextField(
                  inputType: TextInputType.phone,
                  labelText: "Số điện thoại",
                  prefixIcon: Icons.phone,
                  controller: controller.phoneNumberController,
                  onChanged: (value) {
                    controller.state.errorPhoneNumber.value = '';
                  },
                ),
                Text(
                  controller.state.errorPhoneNumber.value.isNotEmpty
                      ? controller.state.errorPhoneNumber.value
                      : '',
                  style: TextStyle(color: Colors.red),
                ),

                // gender
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
                  items: ['', 'Male', 'Female', 'Other'],
                ),
                SizedBox(height: 20),

                // dob
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
                      controller.selectDate(context);
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
                SizedBox(height: 20),

                // button handle
              ],
            ),
          ),
        ),
        persistentFooterButtons:
            controller.state.editMode.value || controller.state.editMode.value
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
                          controller.handleCustomerUpdateProfile();
                        },
                      ),
                    )
                  ]
                : null,
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
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
                      controller.pickImageFromGallery(context);
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
                      controller.pickImageFromCamera(context);
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
