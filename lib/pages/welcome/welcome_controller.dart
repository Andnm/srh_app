import 'package:cus_dbs_app/common/methods/common_methods.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:get/get.dart';

import '../../values/roles.dart';

class WelcomeController extends GetxController {
  WelcomeController();

  final title = "SRH";

  Future<void> onReady() async {
    super.onReady();
    Future.delayed(const Duration(seconds: 3), () async {
      List<String>? userRoles = await UserStore.to.getRoles();
      AppRoles.roles = userRoles;
      print("userRoles $userRoles");
      CommonMethods.checkRedirectRole();
    });
  }
}
