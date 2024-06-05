import 'package:cus_dbs_app/common/entities/emergency.dart';

import '../../utils/http.dart';

class EmergencyAPI {
  static Future<Emergency> requestEmergencyOfCustomer({
    required Emergency emergencyInfo,
  }) async {
    var response = await HttpUtil()
        .post('api/Emergency/Customer', data: emergencyInfo.toJson());
    return Emergency.fromJson(response);
  }

  static Future<Emergency> requestEmergencyOfDriver({
    required Emergency emergencyInfo,
  }) async {
    var response = await HttpUtil()
        .post('api/Emergency/Driver', data: emergencyInfo.toJson());
    return Emergency.fromJson(response);
  }
}
