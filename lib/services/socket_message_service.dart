import 'package:cus_dbs_app/common/entities/msg_content.dart';
import 'package:cus_dbs_app/pages/chat/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signalr_core/signalr_core.dart';

import '../store/user_store.dart';
import '../values/roles.dart';

class SignalRMessageService {
  static ChatController get _chatController => Get.find<ChatController>();
  static final SignalRMessageService _instance =
      SignalRMessageService._internal();
  factory SignalRMessageService() => _instance;
  SignalRMessageService._internal();

  static HubConnection? _connection;

  static Future<void> initialize() async {
    try {
      String? userId;

      if (AppRoles.isDriver) {
        userId = UserStore.to.driverProfile.userID;
      } else {
        userId = UserStore.to.customerProfile.userID;
      }

      if (userId == null) {
        print('UserId is null, unable to connect to socket');
        return;
      }
      List<int> retryDelays = [0, 2000, 5000, 10000, 20000, 30000];
      String token = UserStore.to.token;
      String url =
          'https://ims.hisoft.vn/notificationHub?id=$userId&access_token=$token';

      try {
        _connection = HubConnectionBuilder()
            .withUrl(
                url,
                HttpConnectionOptions(
                  logging: (level, message) => print(message),
                ))
            .withAutomaticReconnect(retryDelays)
            .build();

        _connection = HubConnectionBuilder()
            .withUrl(
                url,
                HttpConnectionOptions(
                  logging: (level, message) => print(message),
                ))
            .withAutomaticReconnect(retryDelays)
            .build();
      } catch (e) {
        print('Error building HubConnection: $e');
      }

      try {
        _connection?.onreconnecting((exception) {
          print(
              'SignalR connection lost, trying to reconnect. Error: $exception');
        });

        _connection?.onreconnected((connectionId) {
          print(
              'SignalR connection reestablished. ConnectionId: $connectionId');
        });

        await _connection!.start();

        print('Connected to SignalR');
      } catch (e) {
        print('Error connecting to SignalR: $e');
      }

      try {
        listenEvent("NewMessage", (arguments) async {
          if (arguments is List && arguments.isNotEmpty) {
            var message =
                Msgcontent.fromJson(arguments[0] as Map<String, dynamic>);
            _chatController.state.msgcontentList.insert(0, message);
            // _chatController.updateMessageStatusFromSocket(message.type);
            _chatController.state.msgcontentList.refresh();
            if (_chatController.myScrollController.hasClients) {
              _chatController.myScrollController.animateTo(
                  _chatController.myScrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut);
            }
            if (message.type == "Message") {
              _chatController.myInputController.clear();
            }
          }
        });
      } catch (e) {
        print('Error registering event handlers: $e');
      }
    } catch (e) {
      print('Error initializing SignalR: $e');
    }
  }

  static Future<void> disconnect() async {
    try {
      await _connection?.stop();
      print('Disconnected from Message SignalR');
    } catch (e) {
      print('Error disconnecting from SignalR: $e');
    }
  }

  static Future<void> invoke(String methodName, List<Object>? args) async {
    try {
      await _connection?.invoke(methodName, args: args);
    } catch (e) {
      print('Error invoking method on SignalR: $e');
    }
  }

  static listenEvent(String methodName, MethodInvocationFunc newMethod) {
    try {
      _connection?.on(methodName, newMethod);
    } catch (e) {
      print('Error registering event handler on SignalR: $e');
    }
  }

  static stopListenEvent(String methodName, {MethodInvocationFunc? method}) {
    try {
      if (method != null) {
        _connection?.off(methodName, method: method);
      } else {
        _connection?.off(methodName);
      }
      print('Stopped listening to event: $methodName');
    } catch (e) {
      print('Error stopping event listener on SignalR: $e');
    }
  }
}
