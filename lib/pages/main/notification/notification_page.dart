import 'package:cus_dbs_app/common/entities/notification/notification_model.dart';
import 'package:cus_dbs_app/common/widgets/error_indicator.dart';
import 'package:cus_dbs_app/pages/main/notification/index.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';

class NotificationPage extends GetView<NotificationController> {
  @override
  Widget build(BuildContext context) {
    controller.fetchNotificationListFromApi(1);

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text("Thông báo"),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () async {
                await controller.handleSeenAllNotify();
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 16.0,
                ),
                child: Icon(Icons.done_all),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: controller.state.dataNotifications.value.isEmpty
                  ? _buildEmptyNotification()
                  : PagedListView<int, NotificationEntity>(
                      pagingController: controller.pagingController,
                      builderDelegate:
                          PagedChildBuilderDelegate<NotificationEntity>(
                        itemBuilder: (context, notification, index) =>
                            _buildNotificationItem(notification),
                        firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(),
                        newPageErrorIndicatorBuilder: (_) => ErrorIndicator(),
                        noItemsFoundIndicatorBuilder: (_) =>
                            _buildEmptyNotification(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyNotification() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/notification_page.svg',
            width: 200,
            height: 200,
          ),
          Text(
            "Bạn hiện không có thông báo nào!",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationEntity notificationItem) {
    return GestureDetector(
      onTap: () {
        notificationItem.seen == false
            ? controller.handleSeenNotify(notificationItem.id ?? '')
            : null;
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.zero,
            child: Divider(
              height: 1,
              thickness: 1,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            color: notificationItem.seen == false
                ? Colors.blue.shade100.withOpacity(0.5)
                : Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  controller
                      .handleGetImageNoti(notificationItem.typeModel ?? ''),
                  height: 40,
                  width: 40,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificationItem.title ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        notificationItem.body ?? '',
                        style: TextStyle(
                          color: notificationItem.seen == false
                              ? Colors.black
                              : Colors.grey,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        controller.convertDateTimeStringToTime(
                            notificationItem.dateCreated ?? ''),
                        style: TextStyle(
                          color: notificationItem.seen == false
                              ? Colors.black
                              : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
