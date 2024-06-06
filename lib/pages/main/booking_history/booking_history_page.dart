import 'package:cus_dbs_app/common/entities/booking_history.dart';
import 'package:cus_dbs_app/common/methods/common_methods.dart';
import 'package:cus_dbs_app/common/widgets/error_indicator.dart';
import 'package:cus_dbs_app/common/widgets/status_text.dart';
import 'package:cus_dbs_app/pages/main/booking_history/_widget/booking_history_detail.dart';
import 'package:cus_dbs_app/pages/main/booking_history/index.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingHistoryPage extends GetView<BookingHistoryController> {
  @override
  Widget build(BuildContext context) {
    controller.fetchBookingHistoryByPageIndex(1);

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text("Lịch sử chuyến đi"),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: controller.state.data.value.isEmpty
                  ? _buildEmptyHistoryBooking()
                  : PagedListView<int, BookingHistory>(
                      pagingController: controller.pagingController,
                      builderDelegate:
                          PagedChildBuilderDelegate<BookingHistory>(
                        itemBuilder: (context, bookingHistoryItem, index) =>
                            _buildHistoryBookingItem(
                                bookingHistoryItem: bookingHistoryItem),
                        firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(),
                        newPageErrorIndicatorBuilder: (_) => ErrorIndicator(),
                        noItemsFoundIndicatorBuilder: (_) =>
                            _buildEmptyHistoryBooking(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyHistoryBooking() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/car_driving.png",
            height: 200,
            width: 200,
          ),
          Text(
            "Bạn đã trải nghiệm SecureRideHome chưa?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              CommonMethods.checkRedirectRole();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text("Đặt chuyến ngay"),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryBookingItem({
    required BookingHistory bookingHistoryItem,
  }) {
    return GestureDetector(
      onTap: () async {
        Get.to(BookingHistoryDetail(history: bookingHistoryItem));
        //lấy tất cả dữ liệu liên quan đến booking image
        //bao gồm cả rating
        controller.fetchAllBookingImageFromApi(
            bookingHistoryItem.id ?? '', bookingHistoryItem);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/car_icon.png"),
              backgroundColor: Colors.blue.shade100,
              radius: 30,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.convertDateTimeString(
                        bookingHistoryItem.dateCreated ?? ""),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bookingHistoryItem.searchRequest?.dropOffAddress ??
                              "",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            StatusText(
              status: bookingHistoryItem.status ?? "",
            )
          ],
        ),
      ),
    );
  }
}
