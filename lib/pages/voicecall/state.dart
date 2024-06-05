import 'package:get/get.dart';

class VoiceState {
  RxBool isJoined = false.obs;
  RxBool openMicrophone = true.obs;
  RxBool enableSpeaker = false.obs;
  RxString callTime = "00.00".obs;
  RxString callStatus = "not connected".obs;

  var messageTo = "".obs;

  var to_name = "".obs;
  var to_avatar = "".obs;
  var doc_id = "".obs;

  //receiver audience
  //anchor is caller
  var callRole = "audience".obs;
  var channelId = "".obs;
}
