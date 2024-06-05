import 'dart:async';

import 'package:cus_dbs_app/common/apis/linked_account_api.dart';
import 'package:cus_dbs_app/common/entities/linked_account_model.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'index.dart';

class LinkedAccountController extends GetxController {
  WalletController get _walletController => Get.find<WalletController>();

  TextEditingController searchController = TextEditingController();

  final state = LinkedAccountState();
  final accountNumberController = TextEditingController();
  final accountNameController = TextEditingController();
  final brandController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    ever(state.dataBankList, (_) {
      searchByName('');
    });
  }

  void updateBankList(List<BankModel> banks) {
    state.dataBankList.value = banks;
  }

  void searchByName(String name) {
    state.searchedBankList.value = state.dataBankList.value.where((bank) {
      return bank.shortName!.toLowerCase().contains(name.toLowerCase());
    }).toList();
  }

  void handleLoading() {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
  }

  //xử lý lấy all bank VN
  Future<void> fetchAllBanksFromAPI() async {
    handleLoading();

    

    try {
      var response = await LinkedAccountAPI.fetchAllBanks();
      state.dataBankList.value = response.data!;
    } catch (e) {
      print('Error fetching all bank from api: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  //xử lý các linked bank
  Future<void> fetchGetAllLinkedAccount() async {
    handleLoading();

    try {
      state.dataLinkedAccountList.value =
          await LinkedAccountAPI.getAllLinkedAccount();

      state.selectedLinkedAccount.value = state.dataLinkedAccountList.value[0];
    } catch (e) {
      print('Error fetching linked account: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> handleCancelLinkedAccount(
      {required LinkedAccountModel linkedAccountModel}) async {
    handleLoading();

    try {
      await LinkedAccountAPI.deleteLinkedAccount(
          linkedAccountId: linkedAccountModel.id ?? '');
      Get.back();
      Get.back();
      fetchGetAllLinkedAccount();
    } catch (e) {
      print('Error delete linked account: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> handleCreateNewLinkedAccount(
      {required BankModel bankModel, required String typeLinked}) async {
    handleLoading();
    late LinkedAccountModel? linkedAccountModel = LinkedAccountModel(
      accountNumber: accountNumberController.text.trim(),
      brand: bankModel.shortName,
      linkedImgUrl: bankModel.logo,
      type: typeLinked,
    );

    try {
      await LinkedAccountAPI.createLinkedAccount(
        dataLinkedAccount: linkedAccountModel,
      );

      clearData();
      fetchGetAllLinkedAccount();
      Get.back();
      Get.back();
      Get.snackbar(
        'Thông báo',
        'Thêm liên kết thành công!',
        backgroundColor: Colors.white,
        colorText: Colors.green,
        borderWidth: 1,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      );
    } catch (e) {
      print('Error create linked account: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  //hàm phụ trợ
  String showLastFourDigits(String number) {
    if (number.length <= 4) {
      return number;
    } else {
      return number.substring(number.length - 4);
    }
  }

  String maskNumber(String number) {
    if (number.length <= 4) {
      return number;
    } else {
      String lastFourDigits = number.substring(number.length - 4);
      String maskedString = '*' * (number.length - 4) + lastFourDigits;
      return maskedString;
    }
  }

  dynamic getColorByBrandName(String brandName) {
    Color backgroundColor;
    String lowerCaseBrandName = brandName.toLowerCase();

    switch (lowerCaseBrandName) {
      case 'eximbank':
        backgroundColor = Color(0xFF009DDE);
        break;
      case 'sacombank':
      case 'cbbank':
        backgroundColor = Color(0xFF01589F);
        break;
      case 'tpbank':
        backgroundColor = Color(0xFF512F7C);
        break;
      case 'vpbank':
        backgroundColor = Color(0xFF009C4D);
        break;
      case 'agribank':
        backgroundColor = Color(0xFF99243E);
        break;
      case 'bidv':
        backgroundColor = Color(0xFF006B68);
        break;
      case 'vib':
      case 'hongleong':
      case 'ibkhn':
      case 'ibkhcm':
      case 'indovinabank':
        backgroundColor = Color(0xFF0065B3);
        break;
      case 'techcombank':
      case 'cimb':
      case 'dbsbank':
      case 'hsbc':
      case 'publicbank':
      case 'viettelmoney':
        backgroundColor = Color(0xFFEC1C24);
        break;
      case 'acb':
      case 'dongabank':
        backgroundColor = Color(0xFF164CA9);
        break;
      case 'mbbank':
      case 'gpbank':
        backgroundColor = Color(0xFF1E01CE);
        break;
      case 'ocb':
        backgroundColor = Color(0xFF008C45);
        break;
      case 'momo':
        backgroundColor = Color(0xFFA50162);
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return backgroundColor;
  }

  void clearData() {
    accountNameController.clear();
    accountNumberController.clear();
    state.accountNameState.value = '';
    state.accountNumberState.value = '';
  }

  @override
  void onClose() {
    super.onClose();
  }
}
