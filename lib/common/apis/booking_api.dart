import 'package:cus_dbs_app/common/entities/booking_image.dart';
import 'package:cus_dbs_app/common/entities/rating.dart';
import 'package:cus_dbs_app/utils/http.dart';

class BookingAPI {
  static Future<dynamic> requestBooking({
    dynamic params,
  }) async {
    var response = await HttpUtil().post('api/Booking', data: params);
    return response;
  }

// nếu không sài cái này thì có thể xóa đi
  static Future<dynamic> getBookingCheckInImage({
    required String bookingId,
  }) async {
    var response =
        await HttpUtil().get('api/BookingImage/CheckInImage/$bookingId');
    return response;
  }

// nếu không sài cái này thì có thể xóa đi
  static Future<dynamic> getBookingCheckOutImage({
    required String bookingId,
  }) async {
    var response =
        await HttpUtil().get('api/BookingImage/CheckOutImage/$bookingId');
    return response;
  }

  static Future<List<BookingImage>> getAllBookingCheckInImage(
      {String? bookingId}) async {
    var response =
        await HttpUtil().get('api/BookingImage/CheckInImage/$bookingId');
    return List<BookingImage>.from(
        (response).map((e) => BookingImage.fromJson(e)));
  }

  static Future<List<BookingImage>> getAllBookingCheckOutImage(
      {String? bookingId}) async {
    var response =
        await HttpUtil().get('api/BookingImage/CheckOutImage/$bookingId');
    return List<BookingImage>.from(
        (response).map((e) => BookingImage.fromJson(e)));
  }

  //liên quan đến rating
  static Future<bool> checkBookingCanRating({
    required String bookingId,
  }) async {
    var response =
        await HttpUtil().get('api/Rating/CheckBookingCanRating/$bookingId');
    return response;
  }

//api này có thể cho cả cus lẫn driver
  static Future<RatingModel> getRatingByBookingId(
      {required String bookingId}) async {
    var response = await HttpUtil().get('api/Rating/Booking/$bookingId');
    return RatingModel.fromJson(response);
  }
}
