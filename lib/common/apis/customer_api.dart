import 'dart:convert';

import 'package:cus_dbs_app/common/entities/customer.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_payment.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_search_request.dart';
import 'package:cus_dbs_app/utils/http.dart';
import 'package:dio/dio.dart';

import '../entities/booking.dart';
import '../entities/driver.dart';
import '../entities/place.dart';
import '../entities/price_configuration.dart';
import '../entities/search_request_model.dart';

class CustomerAPI {
  static Future<CustomerItem> login({
    CustomerExternalLogin? params,
  }) async {
    var response = await HttpUtil()
        .post('api/Customer/ExternalLogin', data: params?.toJson());
    return CustomerItem.fromJson(response);
  }

  static Future<CustomerItem> loginWithEmailAndPassword({
    CustomerItem? params,
  }) async {
    var response =
        await HttpUtil().post('api/Customer/Login', data: params?.toJson());
    return CustomerItem.fromJson(response);
  }

  static Future<List<OnlineNearByDriver>> getOnlineNearByDrivers(
      {required OnlineNearByDriver? params}) async {
    var isFemaleDriver = params?.toJson()['IsFemaleDriver'] ?? '';
    var response = await HttpUtil().get(
        'api/Driver/Online?Radius=${params?.toJson()['Radius']}&Latitude=${params?.toJson()['Latitude']}&Longitude=${params?.toJson()['Longitude']}&IsFemaleDriver=$isFemaleDriver');
    return List<OnlineNearByDriver>.from(
        (response).map((e) => OnlineNearByDriver.fromJson(e)));
  }

  static Future<String> register({
    CustomerRegister? params,
  }) async {
    var response =
        await HttpUtil().post('api/Customer/Register', data: params?.toJson());
    return response;
  }

  static Future<Map<String, dynamic>> updateProfile({
    CustomerUpdateProfile? params,
  }) async {
    var response =
        await HttpUtil().put('api/Customer/Profile', data: params?.toJson());
    return response;
  }

  static Future<User> changeAvatarProfile({
    dynamic imageUrl,
  }) async {
    var response = await HttpUtil().put('api/Customer/Avatar', data: imageUrl);
    return User.fromJson(response);
  }

  static Future<Map<String, dynamic>> getCustomerProfile() async {
    var response = await HttpUtil().get('api/Customer/Profile');
    return response;
  }

  static Future<Map<String, dynamic>> getAll() async {
    var response = await HttpUtil().get('api/Customer/Profile');
    return response;
  }

  static Future<dynamic> checkExistSearchRequestProcessing() async {
    var response = await HttpUtil()
        .get('api/SearchRequest/CheckExistSearchRequestProcessing');
    if (response != null) {
      if (response is Map<String, dynamic>) {
        print("response hehe: ${response}");
        return SearchRequestModel.fromJson(response);
      } else {
        print("No content in response");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<dynamic> checkExistBookingNotComplete() async {
    var response =
        await HttpUtil().get('api/Booking/CheckExistBookingNotComplete');
    return response;
  }

  static Future<dynamic> sendNotiBooking() async {
    var response = await HttpUtil().get('api/Booking/SendNotiBooking');
    return response;
  }

  static Future<bool> sendSearchRequestToDriver(
      {required String? searchRequestId, required String? driverId}) async {
    var response = await HttpUtil().get(
        'api/SearchRequest/SendSearchRequestToDriver/${searchRequestId}/${driverId}');
    return response;
  }

  static Future<PriceConfiguration?> getPriceConfiguration() async {
    var response = await HttpUtil().get('api/PriceConfiguration');

    if (response is Map<String, dynamic>) {
      return PriceConfiguration.fromJson(response);
    } else {
      return null;
    }
  }

  static Future<List<DriverItem>> getAllDriver(
      {int? pageIndex, int? pageSize}) async {
    var response = await HttpUtil().get(
        'api/Driver?PageIndex=$pageIndex&PageSize=$pageSize&SortOrder=DESC');
    var data = response['data'] as List<dynamic>;
    return data.map((json) => DriverItem.fromJson(json)).toList();
  }

  static Future<bool> checkExistUserWithPhoneNumber(
      {dynamic? phoneNumber}) async {
    var response = await HttpUtil()
        .post('api/Customer/CheckExistUserWithPhoneNumber', data: phoneNumber);
    return response;
  }

  static Future<bool> checkExistUserWithEmail({dynamic? email}) async {
    print('email api $email');
    var response = await HttpUtil()
        .post('api/Customer/CheckExistUserWithEmail', data: email);
    return response;
  }

  static Future<BookingRating> rateBooking({
    BookingRating? params,
  }) async {
    FormData formData = FormData.fromMap(params?.toJson() ?? Map());
    var response = await HttpUtil.getDio(
      isMultiPart: true,
    ).post('api/Rating', data: formData);
    return BookingRating.fromJson(response.data);
  }

  static Future<dynamic> cancelBooking(
      {required String? bookingId, required String? cancelReason}) async {
    FormData formData = FormData.fromMap({
          'BookingId': bookingId,
          "CancelReason": cancelReason,
        } ??
        Map());
    var response = await HttpUtil.getDio(isMultiPart: true)
        .post('api/BookingCancel/Customer', data: formData);
    return response;
  }

  static Future<String> updateCustomerLocationToBackEnd({
    PlaceLocation? params,
  }) async {
    var response = await HttpUtil()
        .put('api/Customer/UpdateLocation', data: params?.toJson());
    return response;
  }

  static Future<SearchRequestModel>? updateNewDriverToSearchRequest({
    required String searchRequestId,
    required String oldDriverId,
    required String newDriverId,
  }) async {
    var response = await HttpUtil().put('api/SearchRequest/NewDriver', data: {
      "searchRequestId": searchRequestId,
      "oldDriverId": oldDriverId,
      "newDriverId": newDriverId,
    });

    return SearchRequestModel.fromJson(response);
  }
}
