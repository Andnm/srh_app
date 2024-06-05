import 'dart:convert';

import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings("ic_launcher");
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final message = RemoteMessage.fromMap(jsonDecode(details.payload!));
        print(message.notification!.body);
        // Get.toNamed(AppRoutes.chat,
        //     parameters: {"messageTo": "8550b5e3-3320-4643-9b45-4ecc9c65d22a"});
      },
    );
  }

  static Future<NotificationDetails> notificationDetails() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'dbsapp',
      'channel name',
      groupKey: 'com.example.flutter_push_notifications',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      color: AppColors.primaryElement,
    );
    return NotificationDetails(android: androidNotificationDetails);
  }

  static Future<void> showNotificationWithAndroid(RemoteMessage message) async {
    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
          DateTime.now().microsecond,
          message.notification!.title ?? "",
          message.notification!.body ?? "",
          await notificationDetails(),
          payload: jsonEncode(message.toMap()));
    }
  }
}
