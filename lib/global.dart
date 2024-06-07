import 'dart:developer';
import 'dart:io';

import 'package:cus_dbs_app/common/apis/fcm_token_api.dart';
import 'package:cus_dbs_app/common/entities/fcm_token.dart';
import 'package:cus_dbs_app/firebase_options.dart';
import 'package:cus_dbs_app/services/socket_service.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:cus_dbs_app/store/storage.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:cus_dbs_app/utils/connectivity.dart';
import 'package:cus_dbs_app/utils/firebase_messaging_handler.dart';
import 'package:cus_dbs_app/utils/local_notification_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class Global {
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isAndroid) {
      LocalNotificationService.initialize();
    }
    await Firebase.initializeApp(
      name: "cus_dbs_app",
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInit().whenComplete(() => FirebaseMessagingHandler.config());
    await Get.putAsync<StorageService>(() => StorageService().init());
    Get.put<UserStore>(UserStore());
  }

  static Future firebaseInit() async {
    // FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    //   print("FCM Refresh token: $fcmToken");
    // }).onError((error) => print(error.toString()));
    FirebaseMessaging.onBackgroundMessage(
        FirebaseMessagingHandler.firebaseMessagingBackground);
  }

  static Future onNewToken() async {
    FirebaseMessaging.instance.getToken().then((token) async {
      if (token != null) {
        log("New token: $token");
        FcmTokenModel fcmTokenModel = FcmTokenModel(fcmToken: token);
        var response =
            await FcmTokenAPI.sendFcmTokenToServer(params: fcmTokenModel);
        log('Response Token: $response');
      }
    }).onError((error, stackTrace) {
      Get.snackbar("Error", " Occurred while processing FCM token: $error");
    });
  }

  static Future removeFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        FcmTokenModel fcmTokenModel = FcmTokenModel(fcmToken: token);
        print(" token after delete: $token");
        var response =
            await FcmTokenAPI.removeFcmTokenFromServer(params: fcmTokenModel);
        print('Response remove token: $response');
      }
    } catch (error) {
      print('Error removing FCM token: $error');
      if (error is DioError) {
        if (error.response?.statusCode == 401) {
          print('Token đã hết hạn hoặc không hợp lệ');
        } else {
          print('Lỗi khi xóa FCM token: ${error.response?.statusCode}');
        }
      } else {
        print('Lỗi không xác định khi xóa FCM token');
      }

      throw error;
    }
  }
}
