import 'package:cus_dbs_app/common/widgets/currency_input_formatter.dart';
import 'package:cus_dbs_app/common/widgets/divider_custom.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddFunds extends GetView<WalletController> {
  const AddFunds({Key? key}) : super(key: key);

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
                controller.fetchWalletInfoFromApi();
              }),
          title: Text("Nạp tiền"),
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
                    DividerCustom(),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Số tiền nạp vào ví',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            controller: controller.amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyInputFormatter()
                            ],
                            onChanged: (value) => {
                              controller.state.errorFormatAmount.value = '',
                            },
                            decoration: InputDecoration(
                              hintText: 'Nhập số tiền',
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue[500]!),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 12.0,
                              ),
                              suffixText: 'VND',
                            ),
                          ),
                        ],
                      ),
                    ),

                    //error
                    if (controller.state.errorFormatAmount.value != '')
                      Padding(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Text(
                          controller.state.errorFormatAmount.value,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),

                    //note
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Số tiền nạp vào ví là bội của 10đ, tối thiểu 100.000đ và tối đa là 10.000.000đ',
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    DividerCustom(),

                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Phương thức nạp tiền',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          InkWell(
                            onTap: () {
                              showPaymentMethodBottomSheet(context);
                            },
                            child: Row(
                              children: [
                                Image.asset(controller.getIconPath(),
                                    height: 30, width: 30, fit: BoxFit.cover),
                                SizedBox(width: 15),
                                Text(
                                  controller.state.selectedPaymentMethod.value,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () {
                  if (controller.checkValidAmountAddFunds()) {
                    showConfirmValuePayment(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade400,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

// hiện chọn lại phương thức thanh toán
  void showPaymentMethodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
          onClosing: () {
            controller.changePaymentMethod('');
          },
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Chọn phương thức thanh toán',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildPaymentMethodOption(
                    context,
                    'Thẻ ATM',
                    'assets/icons/atm.png',
                  ),
                  _buildPaymentMethodOption(
                    context,
                    'MoMo',
                    'assets/icons/momo.png',
                  ),
                  _buildPaymentMethodOption(
                    context,
                    'VNPay',
                    'assets/icons/vnpay.png',
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade400,
                    ),
                    child: Text(
                      'Xác nhận',
                      style: TextStyle(
                        color: Colors.white,
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

  Widget _buildPaymentMethodOption(
    BuildContext context,
    String title,
    String iconPath,
  ) {
    return Obx(
      () => InkWell(
        onTap: () {
          controller.changePaymentMethod(title);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Image.asset(iconPath, height: 30, width: 30, fit: BoxFit.cover),
              SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              if (controller.state.selectedPaymentMethod == title)
                Icon(
                  Icons.check,
                  color: Colors.blue.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }

// hiện xác nhận trước khi điều hướng qua app payment
  void showConfirmValuePayment(BuildContext context) {
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
                  Text(
                    'Xác nhận',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade400,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Số tiền nạp vào ví'),
                            Text(controller.amountController.text + 'đ'),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Số tiền cộng thêm'),
                            Text(
                              '0đ',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tổng số tiền cộng vào ví'),
                            Text(
                              controller.amountController.text + 'đ',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade400,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Tổng thanh toán',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  controller.state.selectedPaymentMethod.value,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              controller.amountController.text + 'đ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.goToPaymentApp();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade400,
                    ),
                    child: Text(
                      'Thanh toán',
                      style: TextStyle(
                        color: Colors.white,
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
}
