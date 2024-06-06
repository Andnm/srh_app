import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:crypto/crypto.dart';
import 'package:cus_dbs_app/common/apis/message_api.dart';
import 'package:cus_dbs_app/common/entities/msg_content.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:cus_dbs_app/utils/firebase_messaging_handler.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:cus_dbs_app/values/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkeep/flutter_callkeep.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

import 'state.dart';

class VoiceController extends GetxController {
  VoiceController();

  final state = VoiceState();
  final player = AudioPlayer();
  String appId = APPID;
  late String? messageFrom;
  late final RtcEngine engine;
  bool hasAudience = false;

  ChannelProfileType channelProfileType =
      ChannelProfileType.channelProfileCommunication;

  @override
  void onInit() async {
    super.onInit();
    var data = Get.parameters;
    state.callRole.value = data["callRole"] ?? "";
    state.messageTo.value = data["messageTo"] ?? "";
    if (AppRoles.isDriver) {
      messageFrom = UserStore.to.driverProfile.userID;
    } else {
      messageFrom = UserStore.to.customerProfile.userID;
    }
    await initEngine();
    await getInfo();
  }

  Future<void> initEngine() async {
    await player.setAsset("assets/audios/Sound_Horizon.mp3");
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));

    engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        print('[onError] err: $err, , msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        print('onConnection ${connection.toJson()}');
        state.isJoined.value = true;
      },
      onUserJoined:
          (RtcConnection connection, int remoteUid, int elapsed) async {
        await player.pause();
        hasAudience = true;
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        print('...user left the room...');
        state.isJoined.value = false;
      },
      onRtcStats: (RtcConnection connection, RtcStats stats) {
        print('time...');
        print(stats.duration);
      },
    ));

    await engine.enableAudio();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioGameStreaming);
    await joinChannel();
    //send notification to the other user
    if (state.callRole == "anchor") {
      await sendNotification("voice");
      await player.play();
    }
  }

  Future<void> toggleSpeaker() async {
    if (state.enableSpeaker.value) {
      await engine.setEnableSpeakerphone(false);
      state.enableSpeaker.value = false;
    } else {
      await engine.setEnableSpeakerphone(true);
      state.enableSpeaker.value = true;
    }
  }

  Future<void> sendNotification(String callType) async {
    CallRequestEntity callRequestEntity = CallRequestEntity();
    callRequestEntity.callType = callType;
    callRequestEntity.messageTo = state.messageTo.value;
    print("...the other user's token is ${state.messageTo.value}");
    await MessageAPI.callNotifications(params: callRequestEntity);
  }

  Future<String> getToken() async {
    if (state.callRole == "anchor") {
      state.channelId.value = md5
          .convert(utf8.encode("${messageFrom}_${state.messageTo}"))
          .toString();
    } else {
      state.channelId.value = md5
          .convert(utf8.encode("${state.messageTo}_${messageFrom}"))
          .toString();
    }

    CallTokenRequestEntity callTokenRequestEntity = CallTokenRequestEntity();
    callTokenRequestEntity.channelName = state.channelId.value;
    print("...chanel id is ${state.channelId.value}");
    var res = await MessageAPI.callToken(params: callTokenRequestEntity);
    return res;
  }

  Future<void> joinChannel() async {
    await Permission.microphone.request();
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);

    String token = await getToken();
    if (token.isEmpty) {
      EasyLoading.dismiss();
      Get.back();
      return;
    }

    await engine.joinChannel(
        token: token,
        channelId: state.channelId.value,
        uid: 0,
        options: ChannelMediaOptions(
            channelProfile: channelProfileType,
            clientRoleType: ClientRoleType.clientRoleBroadcaster));

    EasyLoading.dismiss();
  }

  Future<void> leaveChannel() async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    await player.pause();
    state.isJoined.value = false;

    if (hasAudience) {
      await sendMessageInVoiceCall(
        type: "CallSuccess",
        sendContent: "Cuộc gọi thoại",
      );
    }

    await sendNotification("cancel");

    EasyLoading.dismiss();
    Get.back();
  }

  Future<void> sendMessageInVoiceCall({
    required String type,
    required String sendContent,
  }) async {
    try {
      final content = MessageRequestEntity(
        messageFrom:
            state.callRole == "anchor" ? messageFrom! : state.messageTo.value,
        messageTo:
            state.callRole == "anchor" ? state.messageTo.value : messageFrom!,
        type: type,
        content: sendContent,
      );
      print("sendMessageInVoiceCall ${content.toString()} ");

      await MessageAPI.sendNewMessageCall(content);
    } catch (e) {
      print("error to sendMessageInVoiceCall $e");
    }
  }

  Future<void> getInfo() async {
    var data =
        await MessageAPI.getInfoFromMessageTo(messageTo: state.messageTo.value);

    state.to_name.value = data["name"] ?? "";
    state.to_avatar.value = data["avatar"] ?? "";
    print("get Info ${state.to_name.value}");
    print("get Info ${state.to_avatar.value}");
  }

  Future<void> _dispose() async {
    await CallKeep.instance.endAllCalls();
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
  }

  @override
  void onClose() {
    _dispose();
    super.onClose();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
}
