import 'dart:async';
import 'package:cus_dbs_app/common/apis/booking_api.dart';
import 'package:cus_dbs_app/common/apis/customer_history_api.dart';
import 'package:cus_dbs_app/common/apis/driver_history_api.dart';
import 'package:cus_dbs_app/common/entities/booking_image.dart';
import 'package:cus_dbs_app/common/entities/rating.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'index.dart';
import 'dart:math';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cus_dbs_app/common/entities/booking_history.dart';

class BookingHistoryController extends GetxController {
  final state = BookingHistoryState();
  final ScrollController scrollController = ScrollController();

  final PagingController<int, BookingHistory> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      fetchBookingHistoryByPageIndex(pageKey);
    });
  }

  Future<void> fetchBookingHistoryByPageIndex(int pageKey) async {
    if (pageKey == 1) {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true,
      );
    }

    try {
      var response;
      if (AppRoles.isDriver) {
        response = await DriverHistoryAPI.getAllDriverBookingHistoryByDesc(
            pageIndex: pageKey, pageSize: state.pageSize.value);
      } else {
        response = await CustomerHistoryAPI.getAllCustomerBookingHistoryByDesc(
            pageIndex: pageKey, pageSize: state.pageSize.value);
      }

      state.data.value = response.data ?? [];
      state.totalPage.value = response.totalPage ?? 0;

      final isLastPage = state.totalPage.value < state.pageSize.value;
      if (isLastPage) {
        pagingController.appendLastPage(state.data.value);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(state.data.value, nextPageKey);
      }
    } catch (e) {
      // Get.snackbar('Error fetching booking history by page index:', '$e');
      print('Error fetching booking history by page index: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  String convertDateTimeString(String inputDateTimeString) {
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(inputDateTimeString);
    } catch (e) {
      return "06:41 - 08/04/2024";
    }

    DateTime vietnamDateTime = dateTime.toLocal();

    String formattedDateTime =
        DateFormat('HH:mm - dd/MM/yyyy').format(vietnamDateTime);

    return formattedDateTime;
  }

  String renderBookingCode(String input) {
    return input.replaceAll('-', '').toUpperCase();
  }

//calculator distance
  String calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c;

    return distance.toStringAsFixed(2);
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  String getBookingTypeDescription(String bookingType) {
    if (bookingType == "MySelf") {
      return "Tự đặt";
    } else if (bookingType == "Someone") {
      return "Đặt hộ";
    } else {
      return "";
    }
  }

  String getBookingPaymentMethod(String bookingPaymentMethod) {
    switch (bookingPaymentMethod) {
      case "VNPay":
        return "VNPay";
      case "MoMo":
        return "MoMo";
      case "SecureWallet":
        return "SecureWallet";
      default:
        return "Tiền mặt";
    }
  }

  String getIconPath(String bookingPaymentMethod) {
    switch (bookingPaymentMethod) {
      case "Thẻ ATM":
        return "assets/icons/atm.png";
      case "MoMo":
        return "assets/icons/momo.png";
      case "VNPay":
        return "assets/icons/vnpay.png";
      case "SecureWallet":
        return "assets/icons/wallet.png";
      default:
        return "assets/icons/cash.png";
    }
  }

  String formatCurrency(num amount) {
    String formattedAmount = amount.toStringAsFixed(0);
    List<String> parts = [];

    for (int i = formattedAmount.length - 1; i >= 0; i -= 3) {
      int startIndex = i - 2;
      if (startIndex < 0) startIndex = 0;
      parts.add(formattedAmount.substring(startIndex, i + 1));
    }

    parts = parts.reversed.toList();

    String result = parts.join('.');

    result += 'đ';

    return result;
  }

  Future<void> fetchAllBookingImageFromApi(
      String bookingId, BookingHistory bookingHistoryItem) async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);

    try {
      if (bookingHistoryItem.status != "Cancel") {
        List<BookingImage> responseCheckin =
            await BookingAPI.getAllBookingCheckInImage(bookingId: bookingId);
        List<BookingImage> responseCheckout =
            await BookingAPI.getAllBookingCheckOutImage(bookingId: bookingId);

        // xóa dữ liệu cũ
        state.listVehicleBookingImageCheckin.value.clear();
        state.listVehicleBookingImageCheckout.value.clear();
        state.customerBookingImageCheckin.value = BookingImage();
        state.customerBookingImageCheckout.value = BookingImage();

        for (var image in responseCheckin) {
          if (image.bookingImageType != 'Customer') {
            state.listVehicleBookingImageCheckin.value.add(image);
          } else {
            state.customerBookingImageCheckin.value = image;
          }
        }

        for (var image in responseCheckout) {
          if (image.bookingImageType != 'Customer') {
            state.listVehicleBookingImageCheckout.value.add(image);
          } else {
            state.customerBookingImageCheckout.value = image;
          }
        }

        //xử lý vụ hiển thị rating
        bool responseCheckRating =
            await BookingAPI.checkBookingCanRating(bookingId: bookingId);

        state.canRateBooking.value = responseCheckRating;

        // nếu trả về true tức là có thể rating
        //còn trả về false tức là đã có rating sẽ gọi api để get rating
        if (!responseCheckRating) {
          state.ratingData.value =
              await BookingAPI.getRatingByBookingId(bookingId: bookingId);

          state.ratingDataId.value = state.ratingData.value.id ?? '';
        }
      }

      //lấy booking cancel
      if (bookingHistoryItem.status == "Cancel") {
        var resBookingCancel =
            await BookingAPI.getBookingCancelByBookingId(bookingId: bookingId);

        state.bookingCancelData.value = resBookingCancel;
      }
    } catch (e) {
      print('Error fetching booking detail: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  //clear data
  void clearData() {
    state.customerBookingImageCheckin.value = BookingImage();
    state.customerBookingImageCheckout.value = BookingImage();
    state.listVehicleBookingImageCheckin.value = [];
    state.listVehicleBookingImageCheckout.value = [];
    state.ratingData.value = RatingModel();
    state.ratingDataId.value = '';
    state.canRateBooking.value = false;
  }

  @override
  void onClose() {
    state.data.value = [];
    pagingController.dispose();
    super.onClose();
  }
}
