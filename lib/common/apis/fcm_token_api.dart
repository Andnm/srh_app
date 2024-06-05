import 'package:cus_dbs_app/common/entities/fcm_token.dart';
import 'package:cus_dbs_app/utils/http.dart';

class FcmTokenAPI {
  static Future<String?> sendFcmTokenToServer(
      {required FcmTokenModel params}) async {
    try {
      final httpUtil = HttpUtil(); // Sử dụng HttpUtil
      final response = await httpUtil.post(
        'https://ims.hisoft.vn/api/User/FcmToken',
        data: params.toJson(),
      );
      return response;
    } catch (error) {
      print('Error sending FCM token to server: $error');
      return null;
    }
  }

  static Future<String?> removeFcmTokenFromServer(
      {required FcmTokenModel params}) async {
    try {
      final httpUtil = HttpUtil(); 
      final response = await httpUtil.delete(
        'https://ims.hisoft.vn/api/User/FcmToken',
        data: params.toJson(),
      );
      return response;
    } catch (error) {
      print('Error sending FCM token to server: $error');
      return null;
    }
  }
}
