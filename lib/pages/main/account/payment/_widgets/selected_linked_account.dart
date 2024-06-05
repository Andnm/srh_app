import 'package:cus_dbs_app/common/entities/linked_account_model.dart';
import 'package:cus_dbs_app/common/widgets/divider_custom.dart';
import 'package:cus_dbs_app/pages/main/account/payment/_widgets/add_linked_account.dart';
import 'package:cus_dbs_app/pages/main/account/payment/linked_account_controller.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/wallet_controller.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SelectedLinkedAccountPage extends GetView<LinkedAccountController> {
  const SelectedLinkedAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              }),
          title: Text("Liên kết ngân hàng"),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                margin: EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm ngân hàng',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                    suffixIcon: controller.searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              controller.searchController.clear();
                              controller.searchByName('');
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    controller.searchByName(value);
                  },
                ),
              ),
            ),
            Expanded(
              child: controller.state.searchedBankList.value.isEmpty
                  ? Center(
                      child: Text(
                        'Không có ngân hàng phù hợp!',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: controller.state.searchedBankList.value.map(
                            (bankItem) {
                              return GestureDetector(
                                onTap: () {
                                  final userStore = UserStore.to;
                                  final isDriver = AppRoles.isDriver;
                                  final String? name = isDriver
                                      ? userStore.driverProfile.name
                                      : userStore.customerProfile.name;

                                  controller.accountNameController.text =
                                      name ?? '';
                                  controller.state.accountNameState.value =
                                      name ?? '';

                                  Get.to(
                                    AddLinkedAccountPage(
                                      bankModel: bankItem,
                                    ),
                                  );
                                },
                                child: _buildBankOption(bankItem: bankItem),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankOption({
    required BankModel bankItem,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.network(
                  bankItem.logo ?? '',
                  width: 70,
                  height: 30,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      bankItem.shortName ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 12),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue.shade400,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
