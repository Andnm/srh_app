import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cus_dbs_app/common/apis/message_api.dart';
import 'package:cus_dbs_app/common/entities/msg_content.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_booking_request.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_model.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_payment.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_search_request.dart';
import 'package:cus_dbs_app/common/widgets/notification_dialog.dart';
import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkeep/flutter_callkeep.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../pages/main/account/wallet/wallet_controller.dart';
import '../routes/routes.dart';
import '../store/user_store.dart';
import 'local_notification_handler.dart';

class FirebaseMessagingHandler {
  static HomeController get homeController => Get.find<HomeController>();
  static WalletController get walletController => Get.find<WalletController>();

  FirebaseMessagingHandler._();

  static Future<void> config() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    try {
      await messaging.requestPermission(
          sound: true,
          badge: true,
          alert: true,
          announcement: false,
          carPlay: false,
          criticalAlert: false,
          provisional: false);

      CallKeep.instance.onEvent.listen((event) async {
        if (event == null) return;
        final eventData = event.data as CallKeepCallData;
        var data = eventData.extra!;
        var messageTo = data["MessageFrom"];
        var id;
        if (AppRoles.isDriver) {
          id = UserStore.to.driverProfile.userID;
        } else {
          id = UserStore.to.customerProfile.userID;
        }
        print("CHECKing");
        print("EVENT data: $eventData");
        print("EXTRA data: $data");

        switch (event.type) {
          case CallKeepEventType.callAccept:
            Get.toNamed(AppRoutes.VoiceCall,
                parameters: {"messageTo": messageTo, "callRole": "audience"});
            break;
          case CallKeepEventType.callDecline:
            print("id check $id");
            print("messageTo check $messageTo");
            await sendNotification("cancel", messageTo);

            await sendMessageInVoiceCall(
                messageFrom: messageTo,
                messageTo: id,
                sendContent: "Cuộc gọi nhỡ",
                type: "CallMissed");
            break;
          default:
            break;
        }
      });

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);

      FirebaseMessaging.instance.getInitialMessage().then((message) async {
        if (message != null) {
          await handleMessage(message);
        }
      });

      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        // await handleMessage(message);
      });

      // if (Platform.isAndroid) {
      //khi thanh toán từ app khác xong sẽ bay về hàm onMessage này
      FirebaseMessaging.onMessage.listen((event) async {
        await handleMessage(event);
      });
    } on Exception catch (e) {
      print("$e");
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackground(RemoteMessage message) async {
    LocalNotificationService.showNotificationWithAndroid(message);
    NotificationModel notification = NotificationModel.fromJson((message.data));
    print('handle background Message::' + notification.toString());
    if (notification.data is NotificationPayment) {
      NotificationPayment notificationPayment = notification.data;
      String longMoneyValue = notificationPayment.totalMoney.toString();
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('walletBalance', longMoneyValue);
      // walletController.state.currentMoney.value =
      //    ;
      print("WALLET ADDED: ${notificationPayment.totalMoney} ");
      Get.toNamed(AppRoutes.viewWallet);
    }
  }

  static Future<void> handleMessage(RemoteMessage message) async {
    //handle for voicecall
    if (message.data["TypeModel"] == "VoiceCall") {
      Map<String, dynamic> data = jsonDecode(message.data["Data"]);
      if (data["CallType"] == 0) {
        var extraInfo = await MessageAPI.getInfoFromMessageTo(
            messageTo: data["MessageFrom"]);
        data = {
          ...data,
          ...extraInfo,
        };
        print("Extra Info: " + extraInfo.toString());
        print("CHECK DATA: " + data.toString());
        displayIncomingCall(const Uuid().v4(), data);
      } else if (data["CallType"] == 1) {
        CallKeep.instance.endAllCalls();
        if (Get.currentRoute.contains(AppRoutes.VoiceCall)) {
          Get.back();
        }
      }
      return;
    }
    //end handle for voicecall

    NotificationModel notification = NotificationModel.fromJson((message.data));
    if (Platform.isAndroid) {
      LocalNotificationService.showNotificationWithAndroid(message);
    }
    log('handleMessage::' + notification.toString());

    if (notification.data is NotificationSearchRequestModel) {
      NotificationSearchRequestModel searchRequestModel = notification.data;
      await homeController.updateSearchRequestDetail(searchRequestModel);
      if (AppRoles.isDriver) {
        if (searchRequestModel.status != 2) {
          showDialog(
              context: Get.context!,
              builder: (BuildContext context) =>
                  NotificationDialog(requestModel: searchRequestModel),
              barrierDismissible: false);
        }
      }
    } else if (notification.data is NotificationBookingModel) {
      NotificationBookingModel notificationBookingModel = notification.data;
      homeController.updateBookingDetail(notificationBookingModel.status,
          notificationBookingModel: notificationBookingModel);
    }

    switch (notification.typeModel) {
      case "WalletAddFunds":
        NotificationPayment notificationPayment = notification.data;
        Get.toNamed(AppRoutes.viewWallet);
        walletController.state.currentMoney.value =
            notificationPayment.totalMoney ??
                walletController.state.currentMoney.value;

        print('currentMoney ${walletController.state.currentMoney.value}');
        return;
      case "PaymentBookingSuccess":
      case "PaymentBookingFail":
        await homeController.findDriverToSearchRequest();
        Get.toNamed(AppRoutes.mapCustomer);
    }

    //update socket Noti
    if (await checkAuthSuccess()) {}
  }

  static Future<bool> checkAuthSuccess() async {
    return true;
  }

  static Future<void> displayIncomingCall(String uuid, dynamic message) async {
    final config = CallKeepIncomingConfig(
      uuid: uuid,
      callerName: message["name"],
      appName: 'Chatty App',
      avatar: message["avatar"],
      hasVideo: false,
      duration: 30000,
      acceptText: 'Accept',
      declineText: 'Decline',
      missedCallText: 'Missed call',
      callBackText: 'Call back',
      extra: message,
      androidConfig: CallKeepAndroidConfig(
        logo: "ic_logo",
        showCallBackAction: true,
        showMissedCallNotification: true,
        ringtoneFileName: 'system_ringtone_default',
        accentColor: '#0955fa',
        backgroundUrl: 'assets/test.png',
        incomingCallNotificationChannelName: 'Incoming Calls',
        missedCallNotificationChannelName: 'Missed Calls',
      ),
      iosConfig: CallKeepIosConfig(
        iconName: 'CallKitLogo',
        handleType: CallKitHandleType.generic,
        isVideoSupported: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtoneFileName: 'system_ringtone_default',
      ),
    );
    await CallKeep.instance.displayIncomingCall(config);
  }

  static Future<void> sendNotification(
      String callType, String messageTo) async {
    CallRequestEntity callRequestEntity = CallRequestEntity();
    callRequestEntity.callType = callType;
    callRequestEntity.messageTo = messageTo;
    await MessageAPI.callNotifications(params: callRequestEntity);
  }

  static Future<void> sendMessageInVoiceCall(
      {required String type,
      required String sendContent,
      String? messageTo,
      String? messageFrom}) async {
    try {
      final content = MessageRequestEntity(
        messageFrom: messageFrom!,
        messageTo: messageTo!,
        type: type,
        content: sendContent,
      );

      print("sendMessageInVoiceCall ${content.toString()} ");

      await MessageAPI.sendNewMessageCall(content);
    } catch (e) {
      print("error to sendMessageInVoiceCall $e");
    }
  }
}
