import 'dart:io';

import 'package:cus_dbs_app/app/booking_status_type.dart';
import 'package:cus_dbs_app/common/entities/customer.dart';

import 'package:cus_dbs_app/common/entities/driver.dart';
import 'package:cus_dbs_app/common/entities/place.dart';
import 'package:cus_dbs_app/utils/http.dart';
import 'package:dio/dio.dart';

import '../../values/roles.dart';
import '../entities/booking.dart';
import '../entities/booking_image.dart';
import 'dart:convert';

import '../entities/driver_statistics.dart';

class DriverAPI {
  static Future<Map<String, dynamic>> getDriverProfile() async {
    var response = await HttpUtil().get('api/Driver/Profile');
    return response;
  }

  static Future<DriverItem> login({
    DriverExternalLogin? params,
  }) async {
    var response = await HttpUtil()
        .post('api/Driver/ExternalLogin', data: params?.toJson());
    return DriverItem.fromJson(response);
  }

  static Future<DriverItem> loginWithEmailAndPassword({
    DriverInternalLogin? params,
  }) async {
    var response =
        await HttpUtil().post('api/Driver/Login', data: params?.toJson());
    return DriverItem.fromJson(response);
  }

  static Future<String> register({
    DriverItem? params,
  }) async {
    var response =
        await HttpUtil().post('api/Driver/Register', data: params?.toJson());
    return response;
  }

  static Future<String> updateDriverLocationToBackEnd({
    PlaceLocation? params,
  }) async {
    var response =
        await HttpUtil().put('api/Driver/Location', data: params?.toJson());
    return response;
  }

  static Future<dynamic> sendLocationToCustomerForTracking(
      {required String? customerId,
      required double? currentLatitude,
      required double? currentLongitude}) async {
    var response =
        await HttpUtil().put('api/Driver/TrackingDriverLocation', data: {
      "customerId": customerId,
      "latitude": currentLatitude,
      "longitude": currentLongitude
    });
    return DriverItem.fromJson(response);
  }

  static Future<String> switchToOnline() async {
    var response = await HttpUtil().put('api/Driver/Status/Online');
    return response;
  }

  static Future<String> switchToOffline() async {
    var response = await HttpUtil().put('api/Driver/Status/Offline');
    return response;
  }

  static Future<List<BookingData>?> getAllCustomerBooking() async {
    var response = await HttpUtil().get('api/Booking/ForDriver');
    return CustomerBooking.fromJson(response).data;
  }

  static Future<List<CustomerItem>> getAllCustomer(
      {int? pageIndex, int? pageSize}) async {
    var response = await HttpUtil().get(
        'api/Customer?PageIndex=$pageIndex&PageSize=$pageSize&SortOrder=DESC');
    var data = response['data'] as List<dynamic>;
    return data.map((json) => CustomerItem.fromJson(json)).toList();
  }

  static Future<dynamic> requestBooking({
    dynamic params,
  }) async {
    var response = await HttpUtil().post('api/Booking', data: params);
    return response;
  }

  static Future<BookingItem> responseBooking({
    required BOOKING_STATUS bookingStatus,
    BookingRequestModel? params,
  }) async {
    String? pathUrl;
    switch (bookingStatus) {
      case BOOKING_STATUS.PENDING:
        break;
      case BOOKING_STATUS.ACCEPT:
        pathUrl = 'ChangeStatusToArrived';
        break;
      case BOOKING_STATUS.ARRIVED:
        pathUrl = 'ChangeStatusToCheckIn';
        break;
      case BOOKING_STATUS.CHECKIN:
        pathUrl = 'ChangeStatusToOnGoing';
        break;
      case BOOKING_STATUS.ONGOING:
        pathUrl = 'ChangeStatusToCheckOut';
        break;
      case BOOKING_STATUS.CHECKOUT:
        pathUrl = 'ChangeStatusToComplete';
        break;
      case BOOKING_STATUS.COMPLETE:
        break;
      case BOOKING_STATUS.CANCEL:
        if (AppRoles.isDriver) {
          pathUrl = 'DriverCancelBooking';
        } else {
          pathUrl = 'CustomerCancelBooking';
        }
        break;
      default:
        break;
    }
    var response;
    if (pathUrl == null) {
      response = await requestBooking(params: params?.toBookingJson());
    } else {
      response = await HttpUtil().put('api/Booking/$pathUrl',
          data: params?.toChangeStatusBookingJson());
    }
    return BookingItem.fromJson(response);
  }

  static Future<BookingImage> checkInAndOut(
      {required BookingImage params, required bool isCheckIn}) async {
    String pathUrl;
    FormData formData = FormData.fromMap(await params?.toJson() ?? Map());
    if (isCheckIn == true) {
      pathUrl = 'api/BookingImage/CheckIn';
    } else {
      pathUrl = 'api/BookingImage/CheckOut';
    }
    var response = await HttpUtil.getDio(
      isMultiPart: true,
    ).post(pathUrl, data: formData);
    return BookingImage.fromJson(response.data);
  }

  static Future<dynamic> cancelBooking({
    required String? bookingId,
    required String? cancelReason,
    required List<File>? capturedImages,
  }) async {
    FormData formData = FormData.fromMap({
      'bookingId': bookingId,
      'cancelReason': cancelReason,
      if (capturedImages != null)
        'files': capturedImages
            .map((file) => MultipartFile.fromFileSync(file.path))
            .toList(),
    });

    var response = await HttpUtil.getDio(isMultiPart: true)
        .post('api/BookingCancel/Driver', data: formData);
    return response;
  }

  static Future<dynamic> changePublicGender({
    bool? isPublicGender,
  }) async {
    var jsonData = jsonEncode({'isPublicGender': isPublicGender});
    print('isPublicGender  $jsonData');

    var response =
        await HttpUtil().put('api/Driver/ChangePublicGender', data: jsonData);
    print('response public gender + $response');
    return response;
  }

  static Future<DriverItem> isMissSearchRequest(
      {required String? customerId}) async {
    var response = await HttpUtil().put(
        'api/SearchRequest/SearchRequestDriverMiss?CustomerId=$customerId');
    return DriverItem.fromJson(response);
  }

  static Future<dynamic> addCheckInNote(
      {required String? bookingId, String? checkInNote}) async {
    var response = await HttpUtil().put("api/Booking/AddCheckInNote",
        data: {"bookingId": bookingId, "checkInNote": checkInNote});
    return response.toString();
  }

  static Future<dynamic> addCheckOutNote(
      {required String? bookingId, String? checkOutNote}) async {
    var response = await HttpUtil().put("api/Booking/AddCheckOutNote",
        data: {"bookingId": bookingId, "checkOutNote": checkOutNote});
    return response.toString();
  }

  static Future<YearlyDriverStatistics> getStatisticsByYear({
    required int? year,
  }) async {
    var response = await HttpUtil().get("api/Driver/DriverStatistics/$year");
    return YearlyDriverStatistics.fromJson(response);
  }

  static Future<MonthlyDriverStatistics> getDriverMonthlyStatistics({
    required int? month,
    required int? year,
  }) async {
    var response =
        await HttpUtil().get("api/Driver/DriverMonthlyStatistics/$month/$year");
    return MonthlyDriverStatistics.fromJson(response);
  }
}
