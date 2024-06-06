import 'package:cus_dbs_app/common/widgets/custom_text_field.dart';
import 'package:cus_dbs_app/pages/auth/customer/register/index.dart';
import 'package:cus_dbs_app/pages/auth/customer/signin/_widgets/create_identity_card.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_profile/index.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// file này là để xử lý khi người dùng đăng ký bằng EMAIL PASSWORD và GG
class CreateNewProfileCustomer extends GetView<CustomerRegisterController> {
  CustomerUpdateProfileController get _customerUpdateProfileController =>
      Get.find<CustomerUpdateProfileController>();

  @override
  Widget build(BuildContext context) {
    final Map<String?, String> genderMap = {
      null: 'Lựa chọn giới tính',
      'Male': 'Nam',
      'Female': 'Nữ',
      'Other': 'Khác'
    };
    
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(''),
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/icons/icon.png",
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cập nhập hồ sơ khách hàng',
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Nói cho chúng tôi biết về bản thân bạn',
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
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller:
                        _customerUpdateProfileController.phoneNumberController,
                    onChanged: (value) {
                      _customerUpdateProfileController
                          .state.errorPhoneNumber.value = '';
                      _customerUpdateProfileController.state.hasError.value =
                          false;
                      _customerUpdateProfileController.state.phoneNumber.value =
                          value;
                    },
                    decoration: InputDecoration(
                      label: Wrap(
                        children: [
                          Text("Số điện thoại"),
                          Padding(
                            padding: EdgeInsets.all(3.0),
                          ),
                          const Text('*', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                    ),
                  ),
                  Text(
                    _customerUpdateProfileController
                            .state.errorPhoneNumber.value.isNotEmpty
                        ? _customerUpdateProfileController
                            .state.errorPhoneNumber.value
                        : '',
                    style: TextStyle(color: Colors.red),
                  ),
                  // Gender
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Giới tính',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.transgender),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        isDense: true,
                        value: _customerUpdateProfileController
                                .state.gender.value.isNotEmpty
                            ? _customerUpdateProfileController
                                .state.gender.value
                            : null,
                        onChanged: (String? newValue) {
                          _customerUpdateProfileController.state.gender.value =
                              newValue!;
                        },
                        items: genderMap.entries.map((entry) {
                          return DropdownMenuItem<String?>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // dob
                  SizedBox(height: 20),
                  CustomTextField(
                    inputType: TextInputType.datetime,
                    labelText: "Ngày sinh",
                    prefixIcon: Icons.date_range,
                    controller: _customerUpdateProfileController.dobController,
                    onChanged: (value) {
                      _customerUpdateProfileController.state.errorDob.value =
                          '';
                    },
                    onTap: () {
                      _customerUpdateProfileController.selectDate(context);
                      _customerUpdateProfileController.state.errorDob.value =
                          '';
                    },
                  ),
                  Text(
                    _customerUpdateProfileController
                            .state.errorDob.value.isNotEmpty
                        ? _customerUpdateProfileController.state.errorDob.value
                        : '',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              !_customerUpdateProfileController.isButtonEnabled()
                                  ? AppColors.primaryElement
                                  : Colors.grey.shade200),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              !_customerUpdateProfileController
                                      .isButtonEnabled()
                                  ? AppColors.primaryElementText
                                  : Colors.grey),
                          overlayColor: MaterialStateProperty.all<Color>(
                              !_customerUpdateProfileController
                                      .isButtonEnabled()
                                  ? AppColors.primaryElement.withOpacity(0.8)
                                  : Colors.grey),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide.none)),
                      child: Text(
                        'Tiếp tục',
                        style: TextStyle(color: AppColors.primaryElementText),
                      ),
                      onPressed: () async {
                        _customerUpdateProfileController.isButtonEnabled()
                            ? null
                            : {
                                await _customerUpdateProfileController
                                    .handleCustomerUpdateProfileAfterRegister(),
                                if (_customerUpdateProfileController
                                        .state.hasError.value ==
                                    false)
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateNewIdentityCard(context),
                                      ),
                                    ),
                                  },
                              };
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
