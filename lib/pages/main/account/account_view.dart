import 'package:cus_dbs_app/common/widgets/item_list.dart';
import 'package:cus_dbs_app/global.dart';
import 'package:cus_dbs_app/pages/main/account/account_controller.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/index.dart';
import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/services/socket_service.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:cus_dbs_app/values/server.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../values/colors.dart';
import 'driver/statistics/statistics_controller.dart';

class AccountPage extends GetView<AccountController> {
  const AccountPage({Key? key}) : super(key: key);
  StatisticsController get statisticsController =>
      Get.find<StatisticsController>();
  @override
  Widget build(BuildContext context) {
    controller.fetchCustomerProfileFromApi();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text("Trang cá nhân"),
          backgroundColor: AppColors.whiteColor,
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          child: _buildProfileView(),
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    final userStore = UserStore.to;
    final isDriver = AppRoles.isDriver;
    final String? avatar = isDriver
        ? userStore.driverProfile.avatar
        : userStore.customerProfile.avatar;
    final String? name = isDriver
        ? userStore.driverProfile.name
        : userStore.customerProfile.name;
    final String? email = isDriver
        ? userStore.driverProfile.email
        : userStore.customerProfile.email;

    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 120.w,
                height: 120.h,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: controller.state.updatedAvatar.value.isNotEmpty
                        ? Image.network(
                            '${SERVER_API_URL}${controller.state.updatedAvatar.value}',
                            width: 150.w,
                            height: 150.h,
                            fit: BoxFit.cover,
                          )
                        : avatar != null
                            ? Image.network(
                                '${SERVER_API_URL}$avatar',
                                width: 150.w,
                                height: 150.h,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 150.w,
                                height: 150.h,
                                color: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.whiteColor,
                                  size: 50.sp,
                                ),
                              ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            '$name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),

          /// -- BUTTON
          const Divider(),
          SizedBox(height: 10.h),

          /// -- MENU
          ProfileMenu(isDriver: isDriver),

          const Divider(),
          SizedBox(height: 10.h),
          ItemListWidget(
            title: "Mật khẩu",
            icon: Icons.settings,
            onPress: () {
              showUnsupportedFunctionDialog();
            },
          ),

          ItemListWidget(
            title: "Đăng xuất",
            icon: Icons.logout,
            textColor: AppColors.errorRed,
            endIcon: false,
            onPress: () {
              showConfirmLogoutDialog();
            },
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.chat, parameters: {
                "messageTo": "8550b5e3-3320-4643-9b45-4ecc9c65d22a"
              });
            },
            child: const Text('Customer1'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.chat, parameters: {
                "messageTo": "399afea5-a212-4089-9100-70fae14387d4"
              });
            },
            child: const Text('Driver1'),
          ),
        ],
      ),
    );
  }

  void showUnsupportedFunctionDialog() {
    Get.defaultDialog(
      title: "Chưa hỗ trợ",
      titleStyle: TextStyle(fontSize: 20.sp),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0.w),
        child: Text("Chức năng chưa hỗ trợ!"),
      ),
      cancel: OutlinedButton(
        onPressed: () => Get.back(),
        child: const Text("Xác nhận"),
      ),
    );
  }

  void showConfirmLogoutDialog() {
    Get.defaultDialog(
      title: "Đăng xuất",
      titleStyle: const TextStyle(fontSize: 20),
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          "Bạn có chắc muốn đăng xuất ra khỏi hệ thống?",
          textAlign: TextAlign.center,
        ),
      ),
      cancel: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();

            Get.offAllNamed(AppRoutes.chooseRole);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade400,
            side: BorderSide.none,
          ),
          child: const Text(
            "Xác nhận",
            style: TextStyle(color: AppColors.whiteColor),
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
}

class ProfileMenu extends StatelessWidget {
  final bool isDriver;

  const ProfileMenu({Key? key, required this.isDriver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemListWidget(
          title: "Thông tin cá nhân",
          icon: Icons.info,
          onPress: () {
            isDriver
                ? Get.toNamed(AppRoutes.viewDriverProfile)
                : Get.toNamed(AppRoutes.updateCustomerProfile);
          },
        ),
        if (isDriver)
          ItemListWidget(
            title: "Thống kê",
            icon: Icons.dashboard,
            onPress: () {
              Get.toNamed(AppRoutes.viewStatistics);
            },
          ),
        ItemListWidget(
          title: "CCCD",
          icon: Icons.add_card,
          onPress: () {
            isDriver
                ? Get.toNamed(AppRoutes.viewDriverIdentityCard)
                : Get.toNamed(AppRoutes.updateCustomerIdentityCard);
          },
        ),
        if (!isDriver)
          ItemListWidget(
            title: "Xe của tôi",
            icon: Icons.car_crash_outlined,
            onPress: () {
              Get.toNamed(AppRoutes.viewVehicle);
            },
          ),
        if (!isDriver)
          ItemListWidget(
            title: "Trở thành tài xế của SRH",
            icon: Icons.handshake_outlined,
            onPress: () {
              //
            },
          ),
        if (isDriver)
          ItemListWidget(
            title: "Bằng lái của tôi",
            icon: Icons.card_membership,
            onPress: () {
              Get.toNamed(AppRoutes.viewDrivingLicense);
            },
          ),
        ItemListWidget(
          title: "Ví ${isDriver ? "tài xế" : "của tôi"}",
          icon: Icons.account_balance_wallet_outlined,
          onPress: () {
            Get.toNamed(AppRoutes.viewWallet);
          },
        ),
        if (!isDriver)
          ItemListWidget(
            title: "Quản lý liên kết",
            icon: Icons.wallet,
            onPress: () {
              Get.toNamed(AppRoutes.viewLinkedManagement);
            },
          ),
      ],
    );
  }
}
