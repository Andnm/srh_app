import 'package:cus_dbs_app/utils/http.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_model.dart';

class NotificationService {
  static Future<List<NotificationEntity>> getNotificationsList() async {
    var response = await HttpUtil('signalR').get('api/Notification');
    return List<NotificationEntity>.from(
        (response).map((e) => NotificationEntity.fromJson(e)));
  }

  static Future<String> seenNotify({required String? notiId}) async {
    var response =
        await HttpUtil('signalR').put('api/Notification/SeenNotify/$notiId');
    return response;
  }

  static Future<List<NotificationEntity>> seenAllNotify() async {
    var response =
        await HttpUtil('signalR').put('api/Notification/SeenAllNotify');
    return List<NotificationEntity>.from(
        (response).map((e) => NotificationEntity.fromJson(e)));
  }
}
