import 'dart:async';
import 'dart:math';
import 'package:cus_dbs_app/common/apis/notification_api.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_model.dart';
import 'package:cus_dbs_app/pages/main/main/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'index.dart';

class NotificationController extends GetxController {
  final state = NotificationState();
  static const _pageSize = 10;
  final pagingController =
      PagingController<int, NotificationEntity>(firstPageKey: 0);
  static MainController get _mainController => Get.find<MainController>();

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      fetchNotificationListFromApi(pageKey);
    });
  }

  Future<void> fetchNotificationListFromApi(int pageKey) async {
    if (pageKey == 0) {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true,
      );
    }

    try {
      state.dataNotifications.value =
          await NotificationService.getNotificationsList();
      fetchPage(pageKey);
    } catch (e) {
      print('Error fetching notification list: $e');
      pagingController.error = 'Error fetching notification list: $e';
    } finally {
      EasyLoading.dismiss();
    }
  }

  void fetchPage(int pageKey) {
    try {
      final start = pageKey;
      final end = start + _pageSize;
      final newNotifications = state.dataNotifications.value.sublist(
        start,
        end > state.dataNotifications.value.length
            ? state.dataNotifications.value.length
            : end,
      );
      final isLastPage = newNotifications.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newNotifications);
      } else {
        final nextPageKey = pageKey + newNotifications.length;
        pagingController.appendPage(newNotifications, nextPageKey);
      }
    } catch (e) {
      pagingController.error = 'Error fetching page: $e';
    }
  }

  dynamic handleGetImageNoti(String typeModel) {
    dynamic assetImage;

    switch (typeModel) {
      case 'WalletAddFunds':
        assetImage = "assets/images/WalletAddFunds.png";
        break;
      case 'WalletWithDrawFunds':
        assetImage = "assets/images/WalletWithDrawFunds.png";
        break;
      case 'WalletRefund':
        assetImage = "assets/images/WalletRefund.png";
        break;
      case 'WalletIncome':
        assetImage = "assets/images/WalletIncome.png";
        break;
      case 'PaymentBookingSuccess':
        assetImage = "assets/images/PaymentBookingSuccess.png";
        break;
      case 'PaymentBookingFail':
        assetImage = "assets/images/PaymentBookingFail.png";
        break;
      case 'Booking':
        assetImage = "assets/images/car_icon.png";
        break;
      case 'SearchRequest':
        assetImage = "assets/images/SearchRequest.png";
        break;
      default:
        assetImage = "assets/images/personal_update.png";
        break;
    }

    return assetImage;
  }

  String convertDateTimeStringToTime(String inputDateTimeString) {
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(inputDateTimeString);
    } catch (e) {
      return "08/04/2024";
    }

    DateTime vietnamDateTime = dateTime.toLocal();

    String formattedDateTime =
        DateFormat('HH:mm - dd/MM').format(vietnamDateTime);

    return formattedDateTime;
  }

  Future<void> handleSeenNotify(String notiId) async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    try {
      await NotificationService.seenNotify(notiId: notiId);

      if (_mainController.state.notiCount.value > 0) {
        _mainController.state.notiCount.value =
            _mainController.state.notiCount.value - 1;
      }

      var notification =
          state.dataNotifications.value.firstWhere((noti) => noti.id == notiId,
              // ignore: cast_from_null_always_fails
              orElse: () => null as NotificationEntity);
      notification.seen = true;
      state.dataNotifications.value =
          List<NotificationEntity>.from(state.dataNotifications.value);
    } catch (e) {
      print('Error to seen noti: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> handleSeenAllNotify() async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    try {
      state.dataNotifications.value = await NotificationService.seenAllNotify();
      _mainController.state.notiCount.value = 0;
      print("noti count: ${_mainController.state.notiCount.value}");
    } catch (e) {
      print('Error to seen all noti: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
