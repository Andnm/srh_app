import 'package:cus_dbs_app/common/entities/msg_content.dart';
import 'package:get/get.dart';

import '../../app/message_type.dart';

class ChatState {
  RxList<Msgcontent> msgcontentList = <Msgcontent>[].obs;
  Rx<MESSAGE_TYPE> statusOfMessage = MESSAGE_TYPE.MESSAGE.obs;

  var to_userId = "".obs;
  var to_name = "".obs;
  var to_avatar = "".obs;
  var to_online = "".obs;

  RxBool more_status = false.obs;
  RxBool isLoading = false.obs;
}
