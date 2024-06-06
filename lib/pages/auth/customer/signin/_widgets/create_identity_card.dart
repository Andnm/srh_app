import 'package:cus_dbs_app/common/widgets/custom_dropdown_field.dart';
import 'package:cus_dbs_app/common/widgets/custom_text_field.dart';
import 'package:cus_dbs_app/pages/auth/customer/signin/_widgets/create_vehicle.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_identity_card/_widget/document_identity.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_identity_card/index.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class CreateNewIdentityCard extends StatelessWidget {
  const CreateNewIdentityCard(BuildContext context, {super.key});

  CustomerUpdateIdentityController get _customerUpdateIdentityController =>
      Get.find<CustomerUpdateIdentityController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewVehicle(context),
                  ),
                );
              },
              child: Text(
                "Bỏ qua",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/identity_info.png",
                      height: 150,
                      width: 150,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Căn giữa theo chiều dọc
                        children: [
                          Text(
                            'Thêm CCCD',
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Thêm thông tin để trở thành một khách hàng uy tín',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                              _customerUpdateIdentityController
                                              .state.imageFront.value !=
                                          null &&
                                      _customerUpdateIdentityController
                                              .state.imageFront.value !=
                                          ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        base64Decode(
                                          _customerUpdateIdentityController
                                              .state.imageFront.value,
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
                              _customerUpdateIdentityController
                                              .state.imageBehind.value !=
                                          null &&
                                      _customerUpdateIdentityController
                                              .state.imageBehind.value !=
                                          ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        base64Decode(
                                          _customerUpdateIdentityController
                                              .state.imageBehind.value,
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
                  controller: _customerUpdateIdentityController
                      .identityCardNumberController,
                  readOnlyStatus: false,
                  onChanged: (value) {
                    _customerUpdateIdentityController.state.errorIdCard.value =
                        '';
                  },
                ),
                if (_customerUpdateIdentityController
                    .state.errorIdCard.value.isNotEmpty)
                  Text(
                    _customerUpdateIdentityController.state.errorIdCard.value,
                    style: TextStyle(color: Colors.red),
                  ),

                // Full name
                SizedBox(height: 20),
                CustomTextField(
                  labelText: "Họ và tên",
                  prefixIcon: Icons.person,
                  controller:
                      _customerUpdateIdentityController.fullNameController,
                  inputType: TextInputType.text,
                  readOnlyStatus: false,
                ),

                // Ngày sinh
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.datetime,
                  labelText: "Ngày sinh",
                  prefixIcon: Icons.date_range,
                  controller: _customerUpdateIdentityController.dobController,
                  readOnlyStatus: false,
                  onChanged: (value) {
                    _customerUpdateIdentityController.state.errorDob.value = '';
                  },
                  onTap: () {
                    if (_customerUpdateIdentityController
                        .state.editMode.value) {
                      _customerUpdateIdentityController.selectDobDate(context);
                      _customerUpdateIdentityController.state.errorDob.value =
                          '';
                    } else {
                      // do nothing
                    }
                  },
                ),
                Text(
                  _customerUpdateIdentityController
                          .state.errorDob.value.isNotEmpty
                      ? _customerUpdateIdentityController.state.errorDob.value
                      : '',
                  style: TextStyle(color: Colors.red),
                ),

                // Gender
                CustomDropdownField(
                  value: _customerUpdateIdentityController
                          .state.gender.value.isNotEmpty
                      ? _customerUpdateIdentityController.state.gender.value
                      : null,
                  onChanged: _customerUpdateIdentityController
                          .state.editMode.value
                      ? (String? newValue) {
                          _customerUpdateIdentityController.state.gender.value =
                              newValue!;
                        }
                      : null,
                  labelText: 'Giới tính',
                  placeholderText: 'Lựa chọn giới tính',
                  editMode: true,
                  items: ['', 'Male', 'Female', 'Other'],
                ),

                // nationality
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.text,
                  labelText: "Quốc tịch",
                  prefixIcon: Icons.language,
                  controller:
                      _customerUpdateIdentityController.nationalityController,
                  readOnlyStatus: false,
                ),

                // place Origin
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.text,
                  labelText: "Quê quán",
                  prefixIcon: Icons.home,
                  controller:
                      _customerUpdateIdentityController.placeOriginController,
                  readOnlyStatus: false,
                ),

                // place Residence
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.text,
                  labelText: "Nơi thường trú",
                  prefixIcon: Icons.home,
                  controller: _customerUpdateIdentityController
                      .placeResidenceController,
                  readOnlyStatus: false,
                ),

                // personal identification
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.text,
                  labelText: "Đặc điểm nhận dạng",
                  prefixIcon: Icons.person_search_rounded,
                  controller: _customerUpdateIdentityController
                      .personalIdentificationController,
                  readOnlyStatus: false,
                ),

                // expiredDate
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.datetime,
                  labelText: "Ngày hết hạn",
                  prefixIcon: Icons.date_range,
                  readOnlyStatus: false,
                  controller:
                      _customerUpdateIdentityController.expiredDateController,
                  onTap: () {
                    if (_customerUpdateIdentityController
                        .state.editMode.value) {
                      _customerUpdateIdentityController
                          .selectExpiredDate(context);
                    } else {
                      // do nothing
                    }
                  },
                ),

                //  button
                SizedBox(height: 20),
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
                    onPressed: () async {
                      await _customerUpdateIdentityController
                          .asyncCreateIdentityCard();

                      if (_customerUpdateIdentityController
                              .state.errorIdentityCard ==
                          false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateNewVehicle(context),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
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
                      _customerUpdateIdentityController.pickImageFromGallery(
                          context, imageType);
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
                      _customerUpdateIdentityController.pickImageFromCamera(
                          context, imageType);
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
