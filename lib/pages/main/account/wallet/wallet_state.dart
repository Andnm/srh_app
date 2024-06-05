import 'package:cus_dbs_app/common/entities/notification/notification_model.dart';
import 'package:cus_dbs_app/common/entities/wallet.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class WalletState {
  Rx<String> selectedPaymentMethod = 'SecureWallet'.obs;
  Rx<String> selectedImagePathPaymentMethod = 'assets/icons/wallet.png'.obs;
  Rx<String> amountAddFunds = ''.obs;
  Rx<String> errorFormatAmount = ''.obs;

  Rx<num> currentMoney = 0.obs;

// state về history wallet transaction
  Rx<List<WalletTransaction>> data = Rx<List<WalletTransaction>>([]);
  Rx<List<GroupedTransactions>> dataAfterFilter =
      Rx<List<GroupedTransactions>>([]);
  Rx<int> pageIndex = 1.obs;
  Rx<int> pageSize = 10.obs;
  Rx<int> totalPage = 0.obs;
  Rx<int> totalSize = 0.obs;
  Rx<int> pageSkip = 0.obs;
}
