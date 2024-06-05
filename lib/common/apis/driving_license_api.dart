import 'package:cus_dbs_app/common/entities/driving_license.dart';
import 'package:cus_dbs_app/utils/http.dart';

class DrivingLicenseAPI {
  static Future<List<DrivingLicense>> getAllDrivingLicense() async {
    var response = await HttpUtil().get('api/DrivingLicense');

    return List<DrivingLicense>.from(
        (response).map((e) => DrivingLicense.fromJson(e)));
  }

  static Future<List<DrivingLicenseImage>> getAllDrivingLicenseImage(
      {String? drivingLicenseId}) async {
    var response = await HttpUtil()
        .get('api/DrivingLicense/DrivingLicenseImage/$drivingLicenseId');
    return List<DrivingLicenseImage>.from(
        (response).map((e) => DrivingLicenseImage.fromJson(e)));
  }
}
