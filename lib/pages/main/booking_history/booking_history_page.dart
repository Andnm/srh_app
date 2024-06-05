import 'package:cus_dbs_app/common/entities/booking_history.dart';
import 'package:cus_dbs_app/common/methods/common_methods.dart';
import 'package:cus_dbs_app/common/widgets/status_text.dart';
import 'package:cus_dbs_app/pages/main/booking_history/_widget/booking_history_detail.dart';
import 'package:cus_dbs_app/pages/main/booking_history/index.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingHistoryPage extends GetView<BookingHistoryController> {
  @override
  Widget build(BuildContext context) {
    controller.fetchBookingHistoryByPageIndex(pageIndex: 1);

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
                  : SingleChildScrollView(
                      controller: controller.scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: controller.state.data.value.map((history) {
                            return GestureDetector(
                              onTap: () async {
                                Get.to(BookingHistoryDetail(history: history));
                                //lấy tất cả dữ liệu liên quan đến booking image
                                //bao gồm cả rating
                                controller.fetchAllBookingImageFromApi(
                                    history.id ?? '');                             
                              },
                              child: _buildHistoryBookingItem(
                                  bookingHistoryItem: history),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
            _buildPaginationWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: controller.state.pageIndex.value == 1
                ? () {}
                : () {
                    controller.changePage(controller.state.pageIndex.value - 1);
                  },
            color: Colors.blue,
          ),
          Obx(() => Text(
                'Trang ${controller.state.pageIndex.value} trong tổng ${controller.state.totalPage.value} trang',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              )),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: controller.state.totalPage.value == 0 ||
                    controller.state.pageIndex.value ==
                        controller.state.totalPage.value
                ? () {}
                : () {
                    controller.changePage(controller.state.pageIndex.value + 1);
                  },
            color: Colors.blue,
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.only(bottom: 20.0),
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
                        bookingHistoryItem.searchRequest?.dropOffAddress ?? "",
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
    );
  }
}
