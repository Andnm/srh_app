import 'package:cus_dbs_app/common/entities/wallet.dart';
import 'package:cus_dbs_app/common/methods/common_methods.dart';
import 'package:cus_dbs_app/common/widgets/divider_custom.dart';
import 'package:cus_dbs_app/common/widgets/status_text.dart';
import 'package:cus_dbs_app/pages/main/account/payment/linked_account_controller.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/_widgets/add_funds.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/wallet_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class WalletTransactionHistory extends GetView<WalletController> {
  const WalletTransactionHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text("Lịch sử dùng ví"),
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              controller.clearWalletTransactionHistoryData();
              Get.back();
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: controller.state.dataAfterFilter.value.isEmpty
                  ? _buildEmptyWalletTransaction()
                  : SingleChildScrollView(
                      controller: controller.scrollController,
                      child: Column(
                        children: controller.state.dataAfterFilter.value.map(
                          (history) {
                            return GestureDetector(
                              onTap: () {
                                //
                              },
                              child: _buildWalletTransactionItem(
                                groupWalletTransaction: history,
                                context: context,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
            ),
            _buildPaginationWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: controller.state.pageIndex.value == 1
                ? () {}
                : () {
                    controller.changePage(controller.state.pageIndex.value - 1);
                  },
            color: Colors.blue,
          ),
          Obx(() => Text(
                'Trang ${controller.state.pageIndex.value} trong tổng ${controller.state.totalPage.value} trang',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              )),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: controller.state.totalPage.value == 0 ||
                    controller.state.pageIndex.value ==
                        controller.state.totalPage.value
                ? () {}
                : () {
                    controller.changePage(controller.state.pageIndex.value + 1);
                  },
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWalletTransaction() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/wallet_transaction.png",
            height: 200,
            width: 200,
          ),
          Text(
            "Bạn đã nạp tiền vào ví lần nào chưa?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.to(AddFunds());
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
            child: Text("Nạp tiền ngay"),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletTransactionItem({
    required GroupedTransactions groupWalletTransaction,
    required BuildContext context,
  }) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: Text(
              controller
                  .convertDateTimeStringToDate(groupWalletTransaction.date),
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Column(
            children: groupWalletTransaction.transactions
                .map((walletTransactionItem) {
              return GestureDetector(
                onTap: () {
                  //
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              controller.generateTitleWalletTransactionByType(
                                  walletTransactionItem.typeWalletTransaction ??
                                      ''),
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    controller.convertDateTimeStringToTime(
                                            walletTransactionItem.dateCreated ??
                                                '') +
                                        ' | ' +
                                        controller.renderWalletCode(
                                            walletTransactionItem.id ?? ''),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey.shade600,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Handle overflow by ellipsis
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            controller.handleShowPrice(
                                walletTransactionItem.typeWalletTransaction ??
                                    '',
                                walletTransactionItem.status ?? '',
                                walletTransactionItem.totalMoney ?? 0),
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          StatusText(status: walletTransactionItem.status ?? '')
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
