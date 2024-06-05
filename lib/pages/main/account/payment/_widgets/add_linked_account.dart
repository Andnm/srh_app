import 'package:cus_dbs_app/common/entities/linked_account_model.dart';
import 'package:cus_dbs_app/common/widgets/custom_text_field.dart';
import 'package:cus_dbs_app/pages/main/account/payment/linked_account_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AddLinkedAccountPage extends GetView<LinkedAccountController> {
  final BankModel bankModel;

  const AddLinkedAccountPage({Key? key, required this.bankModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                controller.clearData();
                Get.back();
              }),
          title: Text('${bankModel.shortName}'),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 10, right: 16),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Thông tin tại ngân hàng',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 20),
                            CustomTextField(
                              inputType: TextInputType.number,
                              labelText: "Số thẻ/tài khoản",
                              prefixIcon: Icons.numbers,
                              controller: controller.accountNumberController,
                              onChanged: (value) {
                                controller.state.accountNumberState.value =
                                    value;
                              },
                              readOnlyStatus: false,
                            ),
                            SizedBox(height: 30),
                            CustomTextField(
                              inputType: TextInputType.text,
                              labelText: "Chủ thẻ/tài khoản",
                              prefixIcon: Icons.person,
                              controller: controller.accountNameController,
                              onChanged: (value) {
                                controller.state.accountNameState.value = value;
                              },
                              readOnlyStatus: false,
                            ),
                            SizedBox(height: 30),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade200,
                                borderRadius: BorderRadius.circular(
                                    10), // Độ cong của góc viền
                              ),
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Các thông tin được nhập là thông tin bạn đã đăng ký tại ${bankModel.shortName} khi mỏ tài khoản/thẻ',
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Wrap(
                                    children: [
                                      Text(
                                        'Mọi thông tin của bạn đều được bảo mật theo tiêu chuẩn quốc tế PCI DSS',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.state.accountNumberState.value.isNotEmpty &&
                      controller.state.accountNameState.value.isNotEmpty
                  ? () {
                      controller.handleCreateNewLinkedAccount(
                          bankModel: bankModel, typeLinked: "Bank");
                    }
                  : null,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: controller
                                .state.accountNumberState.value.isNotEmpty &&
                            controller.state.accountNameState.value.isNotEmpty
                        ? Colors.blue
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      'Liên kết',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
