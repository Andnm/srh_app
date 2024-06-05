import 'package:cus_dbs_app/common/entities/linked_account_model.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class LinkedAccountState {
  Rx<List<LinkedAccountModel>> dataLinkedAccountList =
      Rx<List<LinkedAccountModel>>([]);
  Rx<List<BankModel>> dataBankList = Rx<List<BankModel>>([]);
  Rx<List<BankModel>> searchedBankList = Rx<List<BankModel>>([]);

  Rx<String> accountNumberState = ''.obs;
  Rx<String> accountNameState = ''.obs;
  Rx<LinkedAccountModel> selectedLinkedAccount = LinkedAccountModel().obs;
  Rx<String> errorLinkedAccount = ''.obs;
}
