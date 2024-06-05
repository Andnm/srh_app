import 'package:cus_dbs_app/pages/main/account/payment/index.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/_widgets/add_funds.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/_widgets/wallet_transaction_history.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/_widgets/withdraw_funds.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'index.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class WalletPage extends GetView<WalletController> {
  String paymentMethod = '';

  LinkedAccountController get _linkedAccountController =>
      Get.find<LinkedAccountController>();

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
          title: Text("SecureWallet"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                //cards
                Container(
                  height: 200,
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      MyCard(
                        balance: controller.state.currentMoney.value,
                        color: Colors.blue[300],
                        cardType: 'assets/icons/mastercard.png',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyButton(
                        iconPath: "assets/icons/sendmoney.png",
                        textButton: "Nạp tiền",
                        onPressed: () {
                          showPaymentMethodBottomSheet(context);
                        },
                      ),
                      MyButton(
                        iconPath: "assets/icons/card.png",
                        textButton: "Rút tiền",
                        onPressed: () {
                          Get.to(WithdrawFunds());
                          _linkedAccountController.fetchGetAllLinkedAccount();
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.0),

                //column -> stats, transaction
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      MyListTile(
                        iconPath: "assets/icons/statistics.png",
                        title: "Thống kê",
                        subTitle: "Thanh toán & thu nhập",
                        onPressed: () {
                          showUnsupportedFunctionDialog();
                        },
                      ),
                      MyListTile(
                        iconPath: "assets/icons/transaction.png",
                        title: "Lịch sử dùng ví",
                        subTitle: "Xem tất cả giao dịch",
                        onPressed: () async {
                          controller.fetchWalletTransactionHistoryByPageIndex(
                            pageIndex: 1,
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showPaymentMethodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
          onClosing: () {
            controller.changePaymentMethod('');
          },
          builder: (BuildContext context) {
            return Obx(
              () => Container(
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
                      onPressed:
                          controller.state.selectedPaymentMethod.isEmpty ||
                                  controller.state.selectedPaymentMethod ==
                                      "SecureWallet"
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  Get.to(AddFunds());
                                },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                      ),
                      child: Text(
                        'Tiếp tục',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
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
    return InkWell(
      onTap: () {
        controller.changePaymentMethod(title);

        paymentMethod = title;
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Image.asset(iconPath, height: 30, width: 30, fit: BoxFit.cover),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
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
    );
  }
}

class MyButton extends StatelessWidget {
  final String iconPath;
  final String textButton;
  final VoidCallback? onPressed;

  const MyButton({
    Key? key,
    required this.iconPath,
    required this.textButton,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            height: 80,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(iconPath),
            ),
          ),
          SizedBox(height: 4),
          Text(
            textButton,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final num balance;
  final String cardType;
  final color;

  const MyCard({
    super.key,
    required this.balance,
    required this.color,
    required this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    String formattedBalance =
        NumberFormat.currency(locale: 'vi').format(balance);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: 300,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Số dư",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 10),
                    Image.asset(
                      cardType,
                      height: 50,
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '$formattedBalance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subTitle;
  final VoidCallback? onPressed;

  const MyListTile({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.subTitle,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 70,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(iconPath),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}

void showUnsupportedFunctionDialog() {
  Get.defaultDialog(
    title: "Chưa hỗ trợ",
    titleStyle: const TextStyle(fontSize: 20),
    content: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Text("Chức năng chưa hỗ trợ!"),
    ),
    cancel: OutlinedButton(
      onPressed: () => Get.back(),
      child: const Text("Xác nhận"),
    ),
  );
}
