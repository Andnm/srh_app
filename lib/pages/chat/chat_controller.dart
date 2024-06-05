import 'dart:io';

import 'package:cus_dbs_app/common/apis/message_api.dart';
import 'package:cus_dbs_app/common/entities/msg_content.dart';
import 'package:cus_dbs_app/pages/chat/chat_state.dart';
import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/services/socket_message_service.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/message_type.dart';
import '../../values/roles.dart';

class ChatController extends GetxController {
  static HomeController get homeController => Get.find<HomeController>();
  final ImagePicker _picker = ImagePicker();

  File? _photo;
  final myInputController = TextEditingController();
  final state = ChatState();
  late String messageTo;
  late String? userId;
  late String? token;

  var listener;
  var pageIndex = 1;
  var totalPage;
  var isLoadmore = true;
  ScrollController myScrollController = ScrollController();

  @override
  void onInit() async {
    super.onInit();

    token = UserStore.to.token;
    if (AppRoles.isDriver) {
      userId = UserStore.to.driverProfile.userID;
    } else {
      userId = UserStore.to.customerProfile.userID;
      // messageTo = homeController.driverInfo!.id!;
    }
    var parameters = Get.parameters;

    messageTo = parameters['messageTo']!;
    print("messageTo log${messageTo.toString()}");
    await getInfo();

    await inConversation(); // Gọi inConversation sau khi khởi tạo messageTo
    await SignalRMessageService.initialize();
  }

  @override
  void onReady() async {
    super.onReady();
    state.msgcontentList.clear();
    var messages = await MessageAPI.getMessage(
        MessageQuery(messageTo: messageTo, PageIndex: 1, PageSize: 10));
    messages.data?.forEach((element) {
      state.msgcontentList.add(element);
    });
    totalPage = messages.totalPage;
    myScrollController.addListener(() {
      if (myScrollController.position.pixels ==
          myScrollController.position.maxScrollExtent) {
        if (pageIndex < totalPage) {
          state.isLoading.value = true;
          pageIndex = pageIndex + 1;
          asyncLoadMoreData();
        }
      }
    });
  }

  Future<void> asyncLoadMoreData() async {
    var messages = await MessageAPI.getMessage(
        MessageQuery(messageTo: messageTo, PageIndex: pageIndex, PageSize: 10));
    messages.data?.forEach((element) {
      state.msgcontentList.add(element);
    });
    state.isLoading.value = false;
  }

  void sendMessage() async {
    String sendContent = myInputController.text;
    if (sendContent.isEmpty) {
      print("content is empty");
      return;
    }

    final content = MessageRequestEntity(
      messageFrom: userId!,
      messageTo: messageTo,
      type: "Message",
      content: sendContent,
    );

    await MessageAPI.sendMessage(content)
        .then((value) => {myInputController.clear()});
  }

  void closeAllPop() {
    Get.focusScope?.unfocus();
    state.more_status.value = false;
  }

  void audioCall() {
    state.more_status.value = false;
    Get.toNamed(AppRoutes.VoiceCall, parameters: {
      "messageTo": messageTo,
      "callRole": "anchor",
    });
  }

  void goMore() {
    state.more_status.value = state.more_status.value ? false : true;
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print("No image selected");
    }
  }

  Future uploadFile() async {
    await MessageAPI.uploadImg(file: _photo, messageTo: messageTo);
  }

  Future inConversation() async {
    await MessageAPI.inConversation(ConversationInOut(messageTo: messageTo));
  }

  Future outConversation() async {
    await MessageAPI.outConversation(ConversationInOut(messageTo: messageTo));
  }

  Future<void> getInfo() async {
    var data = await MessageAPI.getInfoFromMessageTo(messageTo: messageTo);

    state.to_name.value = data["name"] ?? "";
    state.to_avatar.value = data["avatar"] ?? "";
    print("get Info ${state.to_name.value}");
    print("get Info ${state.to_avatar.value}");
  }

  @override
  void onClose() async {
    super.onClose();
    myInputController.dispose();
    myScrollController.dispose();
    await SignalRMessageService.disconnect();
    await outConversation();
  }
}
