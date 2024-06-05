import 'package:cus_dbs_app/common/widgets/custom_dropdown_field.dart';
import 'package:cus_dbs_app/common/widgets/custom_text_field.dart';
import 'package:cus_dbs_app/pages/main/account/driver/profile/index.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cus_dbs_app/store/user_store.dart';

// ignore: must_be_immutable
class DriverProfilePage extends GetView<DriverProfileController> {
  DriverProfilePage();

  String? driverEmail = UserStore.to.driverProfile.email;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              }),
          title: Text("Thông tin cá nhân"),
          backgroundColor: Colors.white,
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
                          child: Image.asset(
                            "assets/images/avatarman.png",
                            fit: BoxFit.cover,
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
                  '$driverEmail',
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

                // dob
                CustomTextField(
                  inputType: TextInputType.datetime,
                  labelText: "Ngày sinh",
                  prefixIcon: Icons.date_range,
                  controller: controller.dobController,
                  onChanged: (value) {
                    controller.state.errorDob.value = '';
                  },
                ),
                Text(
                  controller.state.errorDob.value.isNotEmpty
                      ? controller.state.errorDob.value
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
                SizedBox(height: 10),

                // public gender
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Công khai giới tính",
                        style: TextStyle(),
                      ),
                    ),
                    Switch(
                      value: controller.state.isPublicGender.value,
                      onChanged: (value) async {
                        controller.state.isPublicGender.value = value;
                        controller.handleToggleChangePublicGender();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
