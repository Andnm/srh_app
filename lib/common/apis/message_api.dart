import 'dart:convert';
import 'dart:io';

import 'package:cus_dbs_app/common/entities/base.dart';
import 'package:cus_dbs_app/common/entities/msg_content.dart';
import 'package:cus_dbs_app/utils/http.dart';
import 'package:cus_dbs_app/values/server.dart';
import 'package:dio/dio.dart';

class MessageAPI {
  static Future<MessageSwagger> getMessage(MessageQuery messageQuery) async {
    final httpUtil = HttpUtil();
    final json = await httpUtil.get(
        '${SERVER_API_NOTI_URL}api/Message/${messageQuery.messageTo}',
        queryParameters: messageQuery.toJson());
    return MessageSwagger.fromJson(json);
  }

  static Future<String> sendMessage(
      MessageRequestEntity messageRequestEntity) async {
    var response = await HttpUtil().post('${SERVER_API_NOTI_URL}api/Message',
        data: messageRequestEntity.toJson());

    // return Msgcontent.fromJson(jsonDecode(response));
    return response;
  }

  static Future<String> sendNewMessageCall(
      MessageRequestEntity messageRequestEntity) async {
    var response = await HttpUtil().post(
        '${SERVER_API_NOTI_URL}api/Message/NewMessageCall',
        data: messageRequestEntity.toJson());

    // return Msgcontent.fromJson(jsonDecode(response));
    return response;
  }

  static Future<Msgcontent> uploadImg({
    File? file,
    String? messageTo,
  }) async {
    String fileName = file!.path.split("/").last;
    FormData data = FormData.fromMap({
      "File": await MultipartFile.fromFile(file.path, filename: fileName),
      "messageTo": messageTo
    });
    var response = await HttpUtil()
        .post('${SERVER_API_NOTI_URL}api/Message/SendImage', data: data);
    return Msgcontent.fromJson(response);
  }

  static Future<void> callNotifications({
    CallRequestEntity? params,
  }) async {
    await HttpUtil().post('${SERVER_API_NOTI_URL}api/Message/CallNotification',
        data: params?.toJson());
  }

  static Future<String> callToken({
    CallTokenRequestEntity? params,
  }) async {
    var response = await HttpUtil().get(
        '${SERVER_API_NOTI_URL}api/Message/RtcToken',
        queryParameters: params?.toJson());
    return response;
  }

  static Future<void> inConversation(
      ConversationInOut conversationInOut) async {
    await HttpUtil().post('${SERVER_API_NOTI_URL}api/Message/InConversation',
        data: conversationInOut.toJson());
  }

  static Future<void> outConversation(
      ConversationInOut conversationInOut) async {
    await HttpUtil().post('${SERVER_API_NOTI_URL}api/Message/OutConversation',
        data: conversationInOut.toJson());
  }

  static Future<Map<String, dynamic>> getInfoFromMessageTo(
      {String? messageTo}) async {
    var response = await HttpUtil().get('api/Customer/GetForChat/${messageTo}');
    return response;
  }
}
