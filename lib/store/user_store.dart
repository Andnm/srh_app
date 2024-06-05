import 'dart:convert';

import 'package:cus_dbs_app/common/entities/customer.dart';
import 'package:cus_dbs_app/common/entities/driver.dart';
import 'package:cus_dbs_app/store/storage.dart';
import 'package:cus_dbs_app/values/storage.dart';
import 'package:get/get.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();
  final _customer_profile = CustomerItem().obs;
  final _driver_profile = DriverItem().obs;

  String token = '';

  CustomerItem get customerProfile => _customer_profile.value;
  DriverItem get driverProfile => _driver_profile.value;
  bool get hasToken => token.isNotEmpty;
  bool get isCustomer => _customer_profile.value.userID != null;
  bool get isDriver => _driver_profile.value.userID != null;
  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }

  Future<List<String>?> getRoles() async {
    final customer = await UserStore.to.getCustomerProfile();

    final driver = await UserStore.to.getDriverProfile();

    // final customerRoles = (customer.roles?.length ?? 0) > 0
    //     ? customer.roles
    //     : (driver.roles?.length ?? 0) > 0
    //         ? driver.roles
    //         : [];
    // print('Customer roles $customerRoles');
    // final userRole = (customerRoles?.length ?? 0) > 1
    //     ? (isCustomer ? customerRole : driverRole)
    //     : (customerRoles?.firstOrNull ?? '');
    // print('user role $userRole');
    // return customer.userID != null ? customerRole : driverRole;
    final List<String>? userRoles = (customer.roles?.length ?? 0) > 0
        ? customer.roles
        : (driver.roles?.length ?? 0) > 0
            ? driver.roles
            : [];

    return userRoles;
  }

  CustomerItem getCustomerProfile() {
    token = StorageService.to.getString(STORAGE_USER_TOKEN_KEY);
    var profileOffline = StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
    if (profileOffline.isNotEmpty) {
      _customer_profile(CustomerItem.fromJson(jsonDecode(profileOffline)));
    }
    return customerProfile;
  }

  DriverItem getDriverProfile() {
    token = StorageService.to.getString(STORAGE_USER_TOKEN_KEY);
    var profileOffline = StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
    print("String result profile login ${_driver_profile.toString()}");
    if (profileOffline.isNotEmpty) {
      _driver_profile(DriverItem.fromJson(jsonDecode(profileOffline)));
      print("get result profile login ${_driver_profile.toString()}");
    }

    return driverProfile;
  }

  Future<void> setToken(String value) async {
    await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
    token = value;
  }

  Future<void> saveCustomerProfile(CustomerItem profile) async {
    StorageService.to.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(profile));
    _customer_profile(profile);

    setToken(profile.access_token!);
  }

  Future<void> saveDriverProfile(DriverItem profile) async {
    StorageService.to
        .setString(STORAGE_USER_PROFILE_KEY, jsonEncode(profile.toJson()));
    _driver_profile(profile);
    // _driver_profile.value=profile;
    print("SAVE DRIVER_PROFILE: ${profile}");
    setToken(profile.access_token!);
  }

  Future<void> clearStorage() async {
    await StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
    await StorageService.to.remove(STORAGE_USER_PROFILE_KEY);

    token = '';
  }
}
