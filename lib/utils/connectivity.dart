import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetChecker {
  static final Connectivity _connectivity = Connectivity();
  static late StreamSubscription<List<ConnectivityResult>> _subscription;

  static Future<void> startListening() async {
    print("START LISTENING INTERNET");
    _subscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.every((result) => result == ConnectivityResult.none)) {
        showInternetDialog();
      }
      // else {
      //   if (Get.isDialogOpen!) {
      //     Get.back();
      //   }
      // }
    });
  }

  static Future<void> stopListening() async {
    _subscription.cancel();
  }

  static Future<void> showInternetDialog() async {
    await Get.dialog(
      barrierDismissible: true,
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text('Kết nối không ổn định'),
          content: const Text(
              'Vui lòng kiểm tra kết nối internet để tiếp tục sử dụng ứng dụng.'),
          actions: [
            TextButton(
              onPressed: () async {
                final connectivityResult =
                    await _connectivity.checkConnectivity();
                if (connectivityResult.isNotEmpty &&
                    connectivityResult.first != ConnectivityResult.none) {
                  Get.back();
                } else {
                  // Đóng dialog hiện tại
                  Get.back();
                  // Đợi 1 giây trước khi hiển thị lại dialog
                  await Future.delayed(const Duration(milliseconds: 500));
                  showInternetDialog();
                }
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
