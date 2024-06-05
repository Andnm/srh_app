import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:cus_dbs_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteAuthMiddleware extends GetMiddleware {
  @override
  int? priority = 0;

  RouteAuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    String? customerDateLogin = UserStore.to.customerProfile.dateLogin;
    String? driverDateLogin = UserStore.to.driverProfile.dateLogin;
    String? customerExpiresIn = UserStore.to.customerProfile.dateLogin;
    String? driverExpiresIn = UserStore.to.driverProfile.dateLogin;
    if (isExpiredToken(customerDateLogin ?? driverDateLogin ?? '', UserStore.to.customerProfile.expiresIn ?? UserStore.to.driverProfile.expiresIn ?? -1) ||
        route == AppRoutes.customerSignIn ||
        route == AppRoutes.initial) {
      return null;
    } else {
      UserStore.to.clearStorage();
      return const RouteSettings(name: AppRoutes.customerSignIn);
    }
  }
}
