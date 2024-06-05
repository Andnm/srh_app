import 'package:cus_dbs_app/common/widgets/custom_text_field.dart';
import 'package:cus_dbs_app/pages/auth/customer/signin/_widgets/create_identity_card.dart';
import 'package:cus_dbs_app/pages/auth/customer/signin/sigin_customer_controller.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// file này là để xử lý khi người dùng đăng ký bằng PHONE NUMBER
class CreateNewInfoCustomer extends GetView<CustomerSignInController> {
  CustomerSignInController get _customerSignInController =>
      Get.find<CustomerSignInController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('Đăng ký người dùng'),
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
                    keyboardType: TextInputType.text,
                    controller: _customerSignInController.nameController,
                    decoration: InputDecoration(
                      label: Wrap(
                        children: [
                          Text("Họ và tên"),
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
                  SizedBox(height: 20),
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
                        value: _customerSignInController
                                .state.gender.value.isNotEmpty
                            ? _customerSignInController.state.gender.value
                            : null,
                        onChanged: (String? newValue) {
                          _customerSignInController.state.gender.value =
                              newValue!;
                        },
                        items: <String?>[null, 'Male', 'Female', 'Other'].map(
                          (String? value) {
                            return DropdownMenuItem<String?>(
                              value: value,
                              child: Text(value ?? 'Lựa chọn giới tính'),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),

                  // dob
                  SizedBox(height: 20),
                  CustomTextField(
                    inputType: TextInputType.datetime,
                    labelText: "Ngày sinh",
                    prefixIcon: Icons.date_range,
                    controller: _customerSignInController.dobController,
                    onChanged: (value) {
                      _customerSignInController.state.errorDob.value = '';
                    },
                    onTap: () {
                      _customerSignInController.selectDate(context);
                      _customerSignInController.state.errorDob.value = '';
                    },
                  ),

                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: _customerSignInController
                                .isButtonEnabled()
                            ? MaterialStateProperty.all<Color>(
                                AppColors.primaryElement)
                            : MaterialStateProperty.all<Color>(Colors.white),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            _customerSignInController.isButtonEnabled()
                                ? AppColors.primaryElementText
                                : Colors.grey),
                        overlayColor: MaterialStateProperty.all<Color>(
                            _customerSignInController.isButtonEnabled()
                                ? AppColors.primaryElement.withOpacity(0.8)
                                : Colors.transparent),
                        side: _customerSignInController.isButtonEnabled()
                            ? MaterialStateProperty.all<BorderSide>(
                                BorderSide.none)
                            : MaterialStateProperty.all<BorderSide>(
                                BorderSide(color: Colors.grey)),
                      ),
                      child: Text(
                        'Tiếp tục',
                        style: TextStyle(
                          color: _customerSignInController.isButtonEnabled()
                              ? AppColors.primaryElementText
                              : Colors.grey,
                        ),
                      ),
                      onPressed: _customerSignInController.isButtonEnabled()
                          ? () async {
                              await _customerSignInController
                                  .handleCustomerUpdateProfile();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CreateNewIdentityCard(context),
                                ),
                              );
                            }
                          : () {},
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
