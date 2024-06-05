import 'package:cus_dbs_app/common/entities/booking_history.dart';
import 'package:cus_dbs_app/utils/http.dart';

class CustomerHistoryAPI {
  static Future<BookingHistoryList> getAllCustomerBookingHistoryByDesc(
      {required int pageIndex, required int pageSize}) async {
    var response = await HttpUtil().get(
        'api/Booking/ForCustomer?PageIndex=$pageIndex&PageSize=$pageSize&SortKey=DateCreated&SortOrder=DESC');
    return BookingHistoryList.fromJson(response);
  }
}
