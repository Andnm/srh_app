import 'package:cus_dbs_app/common/entities/linked_account_model.dart';
import 'package:cus_dbs_app/common/widgets/currency_input_formatter.dart';
import 'package:cus_dbs_app/common/widgets/divider_custom.dart';
import 'package:cus_dbs_app/pages/main/account/payment/_widgets/selected_linked_account.dart';
import 'package:cus_dbs_app/pages/main/account/payment/index.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/index.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class WithdrawFunds extends GetView<WalletController> {
  const WithdrawFunds({Key? key}) : super(key: key);
  LinkedAccountController get _linkedAccountController =>
      Get.find<LinkedAccountController>();

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
          title: Text("Rút tiền"),
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
                            'Số tiền rút',
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
                              'Số tiền muốn rút là bội của 10đ, tối thiểu 100.000đ và tối đa là 10.000.000đ',
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
                            'Tài khoản thụ hưởng',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Column(
                            children: [
                              _linkedAccountController
                                      .state.dataLinkedAccountList.value.isEmpty
                                  ? _buildEmptyLinkedAccount()
                                  : SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Column(
                                          children: _linkedAccountController
                                              .state.dataLinkedAccountList.value
                                              .map((linkedItem) {
                                            return GestureDetector(
                                              onTap: () {
                                                _linkedAccountController
                                                    .state
                                                    .selectedLinkedAccount
                                                    .value = linkedItem;
                                              },
                                              child: _buildLinkedAccountOption(
                                                  linkedItem: linkedItem),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                            ],
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
                  if (controller.checkCanWithDrawFunds()) {
                    Get.defaultDialog(
                      title: "Xác nhận",
                      titleStyle: const TextStyle(fontSize: 20),
                      content: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          "Bạn có chắc muốn rút tiền về tài khoản này?",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      cancel: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.handleWithDrawFunds();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade400,
                              side: BorderSide.none),
                          child: const Text(
                            "Xác nhận",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      confirm: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: const Text("Không"),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade400,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Xác nhận',
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

  Widget _buildEmptyLinkedAccount() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/atm.png",
            height: 200,
            width: 200,
          ),
          Text(
            "Bạn chưa liên kết với ngân hàng nào!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          !AppRoles.isDriver
              ? ElevatedButton(
                  onPressed: () async {
                    Get.to(SelectedLinkedAccountPage());
                    if (_linkedAccountController
                        .state.searchedBankList.value.isEmpty) {
                      await _linkedAccountController.fetchAllBanksFromAPI();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text("Liên kết ngay"),
                )
              : Container(),
          SizedBox(height: 10),
          if (_linkedAccountController.state.errorLinkedAccount.value != '')
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                _linkedAccountController.state.errorLinkedAccount.value,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLinkedAccountOption({
    required LinkedAccountModel linkedItem,
  }) {
    bool isSelected =
        _linkedAccountController.state.selectedLinkedAccount.value ==
            linkedItem;
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          linkedItem.linkedImgUrl == null
              ? CircleAvatar(
                  backgroundImage: AssetImage("assets/images/car_icon.png"),
                  backgroundColor: Colors.blue.shade100,
                  radius: 30,
                )
              : ClipOval(
                  child: Image.network(
                    linkedItem.linkedImgUrl ?? '',
                    width: 70,
                    height: 30,
                  ),
                ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          linkedItem.brand ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          _linkedAccountController.showLastFourDigits(
                              linkedItem.accountNumber ?? ''),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    isSelected
                        ? Icon(
                            Icons.radio_button_checked,
                            color: Colors.blue.shade400,
                            size: 20,
                          )
                        : Container(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
