import 'package:cus_dbs_app/common/widgets/divider_custom.dart';
import 'package:cus_dbs_app/pages/main/account/payment/linked_account_controller.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/wallet_controller.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../../values/colors.dart';
import '../../../home/home_controller.dart';

class SelectedMethodPayment extends GetView<LinkedAccountController> {
  const SelectedMethodPayment({Key? key}) : super(key: key);

  WalletController get _walletController => Get.find<WalletController>();
  HomeController get _homeController => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            }),
        title: Text("Quản lý thanh toán"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Divider(
              color: Colors.grey.shade400,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Phương thức thanh toán khả dụng',
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.0.h),
                  _buildPaymentMethodOption(
                    context,
                    'VNPay',
                    'assets/icons/vnpay.png',
                  ),
                  SizedBox(height: 20.h),
                  _buildPaymentMethodOption(
                    context,
                    'MoMo',
                    'assets/icons/momo.png',
                  ),
                  SizedBox(height: 20.h),
                  _buildPaymentMethodOption(
                    context,
                    'SecureWallet',
                    'assets/icons/wallet.png',
                  ),
                  SizedBox(height: 20.h),
                  _buildPaymentMethodOption(
                    context,
                    'Thẻ ATM',
                    'assets/icons/atm.png',
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
            DividerCustom(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Thêm phương thức thanh toán',
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.0.h),
                  _buildAddMorePaymentMethodOption(
                    context,
                    'Thẻ quốc tế',
                    'assets/icons/visa_card.png',
                  ),
                  SizedBox(height: 20.h),
                  _buildAddMorePaymentMethodOption(
                    context,
                    'Viettel Money',
                    'assets/icons/viettel_money.png',
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    BuildContext context,
    String title,
    String iconPath,
  ) {
    return Obx(
      () => InkWell(
        onTap: _homeController.isEnoughMoney || title != 'SecureWallet'
            ? () {
                _walletController.changePaymentMethod(title);
                _walletController.changeSelectedPathPaymentMethod(iconPath);
                Get.back();
              }
            : null,
        child: Row(
          children: [
            Image.asset(iconPath, height: 40.h, width: 40.w, fit: BoxFit.cover),
            SizedBox(width: 15.w),
            Text(
              title,
              style: TextStyle(fontSize: 16.sp),
            ),
            Spacer(),
            if (_walletController.state.selectedPaymentMethod == title &&
                (_homeController.isEnoughMoney || title != 'SecureWallet'))
              Icon(
                Icons.check,
                color: Colors.blue.shade400,
                size: 26.sp,
              ),
            if (!_homeController.isEnoughMoney && title == 'SecureWallet')
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.viewWallet);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryElement,
                ),
                child: Text(
                  'Nạp tiền',
                  style: TextStyle(color: AppColors.surfaceWhite),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMorePaymentMethodOption(
    BuildContext context,
    String title,
    String iconPath,
  ) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Image.asset(iconPath, height: 40.h, width: 40.w, fit: BoxFit.cover),
          SizedBox(width: 15.w),
          Text(
            title,
            style: TextStyle(fontSize: 16.sp),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 16.sp,
          ),
        ],
      ),
    );
  }
}
