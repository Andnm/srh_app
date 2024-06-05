import 'package:cus_dbs_app/common/entities/linked_account_model.dart';
import 'package:cus_dbs_app/common/widgets/divider_custom.dart';
import 'package:cus_dbs_app/pages/main/account/payment/_widgets/selected_linked_account.dart';
import 'package:cus_dbs_app/pages/main/account/payment/_widgets/selected_method_payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'index.dart';

class LinkedAccountPage extends GetView<LinkedAccountController> {
  const LinkedAccountPage();
  @override
  Widget build(BuildContext context) {

    controller.fetchGetAllLinkedAccount();
    
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
          title: Text("Quản lý liên kết"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //style ví secure wallet

            DividerCustom(),

            Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Các liên kết khác hiện có',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: controller.state.dataLinkedAccountList.value
                      .map((linkedItem) {
                    return GestureDetector(
                      onTap: () {
                        _showLinkedAccountBottomSheet(context, linkedItem);
                      },
                      child: _buildLinkedAccountOption(linkedItem: linkedItem),
                    );
                  }).toList(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Container(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    Get.to(SelectedLinkedAccountPage());
                    if (controller.state.searchedBankList.value.isEmpty) {
                      await controller.fetchAllBanksFromAPI();
                    }
                  },
                  child: Text(
                    'Thêm liên kết mới',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedAccountOption({
    required LinkedAccountModel linkedItem,
  }) {
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                          controller.showLastFourDigits(
                              linkedItem.accountNumber ?? ''),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue.shade400,
                      size: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLinkedAccountBottomSheet(
      BuildContext context, LinkedAccountModel linkedItem) {
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
                  Center(
                    child: Text(
                      'Chi tiết',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: controller
                          .getColorByBrandName(linkedItem.brand ?? ''),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            linkedItem.brand!.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            linkedItem.user?.name?.toUpperCase() ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            controller
                                .maskNumber(linkedItem.accountNumber ?? ''),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: Colors.grey[500],
                        size: 25,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Wrap(
                          children: [
                            Text(
                              'Thông tin thanh toán của bạn đã được mã hóa để đảm bảo an toàn',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //button
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: OutlinedButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Xác nhận",
                          titleStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          content: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              "Bạn có chắc chắn muốn xóa thẻ này?",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          cancel: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                controller.handleCancelLinkedAccount(
                                    linkedAccountModel: linkedItem);
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
                      },
                      child: Text(
                        'Hủy liên kết',
                        style: TextStyle(fontSize: 15, color: Colors.black),
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
