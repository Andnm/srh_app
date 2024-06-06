import 'package:cus_dbs_app/common/entities/booking.dart';
import 'package:cus_dbs_app/common/entities/booking_history.dart';
import 'package:cus_dbs_app/common/entities/booking_image.dart';
import 'package:cus_dbs_app/common/entities/rating.dart';
import 'package:get/get.dart';

class BookingHistoryState {
  Rx<List<BookingHistory>> data = Rx<List<BookingHistory>>([]);
  Rx<int> pageIndex = 1.obs;
  Rx<int> pageSize = 10.obs;
  Rx<int> totalPage = 0.obs;
  Rx<int> totalSize = 0.obs;
  Rx<int> pageSkip = 0.obs;
  Rx<bool> canRateBooking = false.obs;

  //avatar driver

  // list image checkin and check out (cái này hình như không dùng tới)
  //nhưng vẫn để đề phòng bug
  Rx<List<BookingImage>> listBookingImages = Rx<List<BookingImage>>([]);

// vehicle booking image
  Rx<List<BookingImage>> listVehicleBookingImageCheckin =
      Rx<List<BookingImage>>([]);
  Rx<List<BookingImage>> listVehicleBookingImageCheckout =
      Rx<List<BookingImage>>([]);

  // customer image
  Rx<BookingImage> customerBookingImageCheckin =
      Rx<BookingImage>(BookingImage());
  Rx<BookingImage> customerBookingImageCheckout =
      Rx<BookingImage>(BookingImage());

  Rx<RatingModel> ratingData = Rx<RatingModel>(RatingModel());
  Rx<String> ratingDataId = Rx<String>("");

  Rx<BookingCancelModel> bookingCancelData =
      Rx<BookingCancelModel>(BookingCancelModel());
}
