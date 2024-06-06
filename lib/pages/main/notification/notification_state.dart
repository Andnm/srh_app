import 'package:cus_dbs_app/common/entities/notification/notification_model.dart';
import 'package:get/get.dart';

class NotificationState {
  Rx<List<NotificationEntity>> dataNotifications =
      Rx<List<NotificationEntity>>([]);
  Rx<int> pageIndex = 1.obs;
  Rx<int> pageSize = 10.obs;
  Rx<int> totalPage = 0.obs;
  Rx<int> totalSize = 0.obs;
  Rx<int> pageSkip = 0.obs;
}
