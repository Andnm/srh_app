import 'dart:async';

import 'package:cus_dbs_app/common/apis/payment_api.dart';
import 'package:cus_dbs_app/common/apis/wallet_api.dart';
import 'package:cus_dbs_app/common/entities/payment.dart';
import 'package:cus_dbs_app/common/entities/wallet.dart';
import 'package:cus_dbs_app/pages/main/account/payment/index.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/_widgets/wallet_transaction_history.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'index.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class WalletController extends GetxController with WidgetsBindingObserver {
  final state = WalletState();
  final amountController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  LinkedAccountController get _linkedAccountController =>
      Get.find<LinkedAccountController>();

  @override
  void onInit() async {
    super.onInit();
    if (await checkExistUserWallet()) {
      await fetchWalletInfoFromApi();
    } else {
      await createUserWallet();
    }
  }

  // xử lý để lấy thông tin wallet
  Future<bool> checkExistUserWallet() async {
    handleLoading();

    try {
      var responseCheck = await WalletAPI.checkExistWallet();
      return responseCheck;
    } catch (e) {
      print("Error to CHECK wallet info $e");
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> createUserWallet() async {
    handleLoading();

    try {
      bool isDriver = AppRoles.isDriver;
      String userID = '';
      if (isDriver) {
        userID = UserStore.to.driverProfile.userID!;
      } else {
        userID = UserStore.to.customerProfile.userID!;
      }

      var responsePostWallet = await WalletAPI.postWallet(userID);
      state.currentMoney.value = responsePostWallet.totalMoney ?? 0;
    } catch (e) {
      print("Error to CREATE wallet info $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> fetchWalletInfoFromApi() async {
    handleLoading();

    try {
      var response = await WalletAPI.getWallet();
      state.currentMoney.value = response.totalMoney ?? 0;
    } catch (e) {
      print("Error to load wallet info $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

// xử lý phần thanh toán
  void changePaymentMethod(String selectedPaymentMethod) {
    state.selectedPaymentMethod.value = selectedPaymentMethod;
  }

  void changeSelectedPathPaymentMethod(String selectedPathPaymentMethod) {
    state.selectedImagePathPaymentMethod.value = selectedPathPaymentMethod;
  }

  bool checkValidAmountAddFunds() {
    final amount = convertAmountFromStringToNum(amountController.text.trim());

    if (amountController.text.trim().isEmpty) {
      state.errorFormatAmount.value = 'Vui lòng nhập số tiền muốn nạp';
      return false;
    }

    if (amount! < 100000 || amount > 10000000) {
      state.errorFormatAmount.value =
          'Số tiền nạp tối thiểu 100.000đ và tối đa là 10.000.000đ';
      return false;
    }

    return true;
  }

  num? convertAmountFromStringToNum(String amountString) {
    final amount = num.tryParse(amountString.replaceAll('.', ''));
    return amount;
  }

  Future<void> goToPaymentApp() async {
    handleLoading();

    try {
      late PaymentItem dataPayment = PaymentItem(
        amount: convertAmountFromStringToNum(amountController.text.trim()),
      );

      String responseLinkUrl = '';

      switch (state.selectedPaymentMethod.value) {
        case "VNPay":
          var response =
              await PaymentAPI.createVNPayPaymentUrl(dataPayment: dataPayment);
          responseLinkUrl = response;
          break;

        case "MoMo":
          var response =
              await PaymentAPI.createMoMoPaymentUrl(dataPayment: dataPayment);
          responseLinkUrl = response.data!.deeplink ?? '';
          break;

        default:
          Get.snackbar(
            'Thông báo:',
            'Tính năng chưa hỗ trợ, vui lòng chọn phương thức khác',
            backgroundColor: Colors.white,
            colorText: Colors.orange,
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
          return;
      }
      Get.back();
      if (responseLinkUrl.isNotEmpty) {
        //srh://app.unilinks.com
        final Uri _url = Uri.parse(responseLinkUrl);
        launchUrl(_url);
      } else {
        print("No deeplink returned in the response.");
      }
    } catch (e) {
      print("Error launch App $e");
    } finally {
      amountController.text = '';
      EasyLoading.dismiss();
    }
  }

// xử lý rút tiền
  Future<void> handleWithDrawFunds() async {
    handleLoading();

    try {
      num amount =
          convertAmountFromStringToNum(amountController.text.trim()) ?? 0;

      var response = await WalletAPI.withDrawFunds(amount,
          _linkedAccountController.state.selectedLinkedAccount.value.id ?? '');

      state.currentMoney.value = response.totalMoney ?? 0;
      amountController.text = '';
      Get.snackbar(
        'Thông báo',
        'Đăng ký rút tiền thành công, vui lòng chờ hệ thống xác nhận!',
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
      print("Error to load wallet info $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  bool checkCanWithDrawFunds() {
    if (amountController.text.trim().isEmpty) {
      state.errorFormatAmount.value = 'Vui lòng nhập số tiền muốn rút';
      return false;
    } else {
      //kiểm tra nếu như số tiền muốn rút lớn hơn số tiền hiện đang có trong SecureWallet

      if (convertAmountFromStringToNum(amountController.text.trim())! >
          state.currentMoney.value) {
        _linkedAccountController.state.errorLinkedAccount.value = state
                .errorFormatAmount.value =
            'Vui lòng nhập số tiền muốn rút phải nhỏ hơn hoặc bằng số tiền hiện có trong ví';
        return false;
      }
    }

    //kiểm tra nếu như ko có linked account thì sẽ báo gì đó
    if (_linkedAccountController.state.dataLinkedAccountList.value.isEmpty) {
      _linkedAccountController.state.errorLinkedAccount.value =
          'Không thể rút tiền khi chưa liên kết!';
      return false;
    }

    return true;
  }

  String getIconPath() {
    switch (state.selectedPaymentMethod.value) {
      case "Thẻ ATM":
        return "assets/icons/atm.png";
      case "MoMo":
        return "assets/icons/momo.png";
      case "VNPay":
        return "assets/icons/vnpay.png";
      default:
        return "assets/icons/atm.png";
    }
  }

// xử lý phần lấy lịch sử nạp ví history wallet transaction
  void _scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void changePage(int newPageIndex) {
    _scrollToTop();
    state.pageIndex.value = newPageIndex;
    fetchWalletTransactionHistoryByPageIndex(pageIndex: newPageIndex);
  }

  Future<void> fetchWalletTransactionHistoryByPageIndex(
      {required int pageIndex}) async {
    handleLoading();

    try {
      var response;
      response = await WalletAPI.getAllWalletTransactionByDesc(
          pageIndex: state.pageIndex.value, pageSize: state.pageSize.value);

      state.data.value = response.data ?? [];
      state.dataAfterFilter.value = groupTransactions(response.data ?? []);

      state.totalPage.value = response.totalPage ?? 0;
      state.totalSize.value = response.totalSize ?? 0;
    } catch (e) {
      // Get.snackbar('Error fetching wallet transaction history by page index:', '$e');
      print('Error fetching wallet transaction history by page index: $e');
    } finally {
      Get.to(WalletTransactionHistory());
      EasyLoading.dismiss();
    }
  }

// hàm này xử lý việc gom những object có cùng chung ngày tháng năm giao dịch
  List<GroupedTransactions> groupTransactions(dynamic dataList) {
    List<GroupedTransactions> groupedTransactions = [];

    for (var data in dataList) {
      bool isGrouped = false;

      for (var groupedTransaction in groupedTransactions) {
        String groupedTransactionDate =
            groupedTransaction.date.substring(0, 10);

        String dataDateCreated = data.dateCreated!.substring(0, 10);

        if (groupedTransactionDate == dataDateCreated) {
          groupedTransaction.transactions.add(data);
          isGrouped = true;
          break;
        }
      }

      if (!isGrouped) {
        groupedTransactions.add(
          GroupedTransactions(
            date: data.dateCreated ?? '',
            transactions: [data],
          ),
        );
      }
    }

    return groupedTransactions;
  }

  String generateTitleWalletTransactionByType(String type) {
    switch (type) {
      case "AddFunds":
        return "Nạp tiền vào ví";
      case "WithdrawFunds":
        return "Rút tiền từ ví";
      case "Income":
        return "Thu nhập từ chuyến đi";
      case "DriverIncome":
        return "Thu nhập của tài xế";
      case "Pay":
        return "Thanh toán chuyến đi";
      case "Refund":
        return "Hoàn tiền";
      default:
        return "Trạng thái không tồn tại";
    }
  }

  String convertDateTimeStringToDate(String inputDateTimeString) {
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(inputDateTimeString);
    } catch (e) {
      return "08/04/2024";
    }

    DateTime vietnamDateTime = dateTime.toLocal();

    String formattedDateTime = DateFormat('dd/MM/yyyy').format(vietnamDateTime);

    return formattedDateTime;
  }

  String convertDateTimeStringToTime(String inputDateTimeString) {
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(inputDateTimeString);
    } catch (e) {
      return "08/04/2024";
    }

    DateTime vietnamDateTime = dateTime.toLocal();

    String formattedDateTime = DateFormat('HH:mm').format(vietnamDateTime);

    return formattedDateTime;
  }

  String renderWalletCode(String input) {
    return input.replaceAll('-', '').toUpperCase();
  }

  String formatCurrency(num amount) {
    String formattedAmount = amount.toStringAsFixed(0);
    List<String> parts = [];

    for (int i = formattedAmount.length - 1; i >= 0; i -= 3) {
      int startIndex = i - 2;
      if (startIndex < 0) startIndex = 0;
      parts.add(formattedAmount.substring(startIndex, i + 1));
    }

    parts = parts.reversed.toList();

    String result = parts.join('.');

    result += 'đ';

    return result;
  }

  String handleShowPrice(String type, String status, num amount) {
    String sign = '';

    if (type == 'AddFunds' || type == 'Income' || type == 'Refund') {
      sign = '+';
    } else if (status == 'Waiting' && type == 'WithdrawFunds') {
      return formatCurrency(amount);
    } else {
      sign = '-';
    }

    String formattedAmount = formatCurrency(amount);

    return '$sign $formattedAmount';
  }

  void clearData() {
    amountController.clear();
    state.selectedPaymentMethod.value = '';
    state.amountAddFunds.value = '';
    state.errorFormatAmount.value = '';
    state.currentMoney.value = 0;
    _linkedAccountController.state.errorLinkedAccount.value = '';
  }

  void clearWalletTransactionHistoryData() {
    state.pageIndex.value = 1;
    state.pageSize.value = 10;
    state.totalPage.value = 0;
    state.totalSize.value = 0;
    state.pageSkip.value = 0;
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
  }
}
