import 'package:cus_dbs_app/common/entities/booking_history.dart';
import 'package:cus_dbs_app/common/entities/booking_image.dart';
import 'package:cus_dbs_app/common/widgets/divider_custom.dart';
import 'package:cus_dbs_app/common/widgets/item_list.dart';
import 'package:cus_dbs_app/common/widgets/new_rating_dialog.dart';
import 'package:cus_dbs_app/common/widgets/status_text.dart';
import 'package:cus_dbs_app/pages/main/booking_history/index.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:cus_dbs_app/values/server.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:get/get.dart';
import 'dart:convert';

class BookingHistoryDetail extends GetView<BookingHistoryController> {
  const BookingHistoryDetail({Key? key, required this.history})
      : super(key: key);

  final BookingHistory history;
  @override
  Widget build(BuildContext context) {
    print("history booking: ${history}");
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          title: Text(
            'Chi tiết chuyến đi',
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                controller.clearData();
                Get.back();
              }),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  driver
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        height: 70,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                history.driver?.avatar == null
                                    ? Image.asset(
                                        "assets/images/avatarman.png",
                                        width: 60,
                                        height: 60,
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: Image.network(
                                          '${SERVER_API_URL}${history.driver?.avatar ?? ""}',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                Transform.translate(
                                  offset: Offset(6, 45),
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${history.driver?.star ?? ''}",
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.orange.shade700,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    history.driver?.name ?? "",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    history.driver?.email ?? "",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DividerCustom(),

                    //rating
                    if (controller.state.canRateBooking.value)
                      if (!AppRoles.isDriver)
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Chuyến đi của bạn thế nào:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        Get.dialog(
                                          Dialog(
                                            surfaceTintColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            child: NewRatingDialog(
                                              bookingId: history.id ?? "",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (int i = 0; i < 5; i++)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.grey,
                                                size: 35,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DividerCustom(),
                          ],
                        ),

                    if (controller.state.ratingDataId.value.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  AppRoles.isDriver
                                      ? 'Khách hàng phản hồi chuyến đi: '
                                      : 'Phản hồi của bạn:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  child: RatingBarIndicator(
                                    rating: controller
                                            .state.ratingData.value.star
                                            ?.toDouble() ??
                                        0.0,
                                    itemCount: 5,
                                    itemSize: 20,
                                    direction: Axis.horizontal,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber.shade800,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Đánh giá: " +
                                      (controller
                                              .state.ratingData.value.comment ??
                                          ''),
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DividerCustom(),
                        ],
                      ),

                    //chuyến đi
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chuyến đi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              controller.convertDateTimeString(
                                  history.dateCreated ?? ""),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Mã chuyến đi: ' +
                                              controller.renderBookingCode(
                                                  history.id ?? ""),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: IconButton(
                                    icon: Icon(Icons.copy),
                                    iconSize: 18,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),

                            // điểm đón
                            SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.my_location,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        history.searchRequest?.pickupAddress ??
                                            "",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        softWrap: true,
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // điểm thả
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        history.searchRequest?.dropOffAddress ??
                                            "",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        softWrap: true,
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Divider(
                              thickness: 1,
                              color: Colors.grey.shade400,
                            ),

                            //distance
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.share_location,
                                  size: 20,
                                  color: Colors.grey.shade500,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '${history.searchRequest?.distance} km',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    DividerCustom(),

                    //thông tin chi tiết
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thông tin chi tiết',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Hình thức: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.getBookingTypeDescription(
                                        history.searchRequest?.bookingType ??
                                            ""),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Trạng thái: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                StatusText(
                                  status: history.status ?? "",
                                ),
                              ],
                            ),

                            if (true)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Lý do hủy chuyến: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "asd",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Người hủy chuyến: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "asdasd2435465768767645344wetrhfgdf",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            //thời gian đón khách
                            if (history.pickUpTime != null)
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Thời gian đón khách: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: controller.convertDateTimeString(
                                          history.pickUpTime ?? ""),
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            //thời gian trả khách
                            if (history.dropOffTime != null)
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Thời gian trả khách: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: controller.convertDateTimeString(
                                          history.dropOffTime ?? ""),
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            SizedBox(height: 8),

                            //Thông tin người đặt
                            if (history.searchRequest?.bookingType == "Someone")
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Thông tin người đặt: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          history
                                                          .searchRequest
                                                          ?.customerBookedOnBehalf
                                                          ?.imageUrl !=
                                                      null &&
                                                  history
                                                          .searchRequest
                                                          ?.customerBookedOnBehalf
                                                          ?.imageUrl !=
                                                      ''
                                              ? InstaImageViewer(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      '${history.searchRequest?.customerBookedOnBehalf?.imageUrl}',
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child: Container(
                                                    color: Colors.grey[200],
                                                  ),
                                                )
                                        ],
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Họ và tên: ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            TextSpan(
                                              text: history
                                                  .searchRequest
                                                  ?.customerBookedOnBehalf
                                                  ?.name,
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Số điện thoại: ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            TextSpan(
                                              text: history
                                                  .searchRequest
                                                  ?.customerBookedOnBehalf
                                                  ?.phoneNumber,
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),

                            // ảnh khách hàng trước chuyến đi
                            if (history.status != 'Accept' &&
                                history.status != 'Arrived' &&
                                history.status != 'CheckIn' &&
                                history.status != 'Cancel')
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ảnh khách hàng trước chuyến đi: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        controller
                                                        .state
                                                        .customerBookingImageCheckin
                                                        .value
                                                        .bookingImageUrl !=
                                                    null &&
                                                controller
                                                        .state
                                                        .customerBookingImageCheckin
                                                        .value
                                                        .bookingImageUrl !=
                                                    ''
                                            ? InstaImageViewer(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    '${SERVER_API_URL}${controller.state.customerBookingImageCheckin.value.bookingImageUrl ?? ''}',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Container(
                                                  color: Colors.grey[200],
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                ],
                              ),

                            // ảnh khách hàng sau chuyến đi
                            if (history.status == 'Complete')
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ảnh khách hàng sau chuyến đi: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        controller
                                                        .state
                                                        .customerBookingImageCheckout
                                                        .value
                                                        .bookingImageUrl !=
                                                    null &&
                                                controller
                                                        .state
                                                        .customerBookingImageCheckout
                                                        .value
                                                        .bookingImageUrl !=
                                                    ''
                                            ? InstaImageViewer(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    '${SERVER_API_URL}${controller.state.customerBookingImageCheckout.value.bookingImageUrl ?? ''}',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Container(
                                                  color: Colors.grey[200],
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                ],
                              ),

                            //Thông tin chiếc xe
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thông tin chiếc xe: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _customTextSpanWidget(
                                      labelText: 'Biển số xe: ',
                                      descriptionText: history.searchRequest
                                              ?.bookingVehicle?.licensePlate ??
                                          "",
                                    ),
                                    _customTextSpanWidget(
                                      labelText: 'Hãng xe: ',
                                      descriptionText: history.searchRequest
                                              ?.bookingVehicle?.brand ??
                                          "",
                                    ),
                                    _customTextSpanWidget(
                                      labelText: 'Nhãn hiệu: ',
                                      descriptionText: history.searchRequest
                                              ?.bookingVehicle?.model ??
                                          "",
                                    ),
                                    _customTextSpanWidget(
                                      labelText: 'Màu xe: ',
                                      descriptionText: history.searchRequest
                                              ?.bookingVehicle?.color ??
                                          "",
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),

                            // ảnh xe trước chuyến đi
                            if (history.status != 'Accept' &&
                                history.status != 'Arrived' &&
                                history.status != 'CheckIn' &&
                                history.status != 'Cancel')
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ảnh xe trước chuyến đi: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: controller
                                              .state
                                              .listVehicleBookingImageCheckin
                                              .value
                                              .isEmpty
                                          ? _buildEmptyImagesList()
                                          : _buildImagesFromList(
                                              controller
                                                  .state
                                                  .listVehicleBookingImageCheckin
                                                  .value,
                                            ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                ],
                              ),

                            // ảnh xe sau chuyến đi
                            if (history.status == 'Complete' ||
                                history.status == 'CheckOut')
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ảnh xe sau chuyến đi: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: controller
                                              .state
                                              .listVehicleBookingImageCheckin
                                              .value
                                              .isEmpty
                                          ? _buildEmptyImagesList()
                                          : _buildImagesFromList(
                                              controller
                                                  .state
                                                  .listVehicleBookingImageCheckout
                                                  .value,
                                            ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    DividerCustom(),

                    // thanh toán
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thanh toán',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Giá cước',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                controller.formatCurrency(
                                    history.searchRequest?.price ?? 0),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey.shade400,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    controller.getIconPath(history.searchRequest
                                            ?.bookingPaymentMethod ??
                                        ""),
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    controller.getBookingPaymentMethod(history
                                            .searchRequest
                                            ?.bookingPaymentMethod ??
                                        ""),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                controller.formatCurrency(
                                    history.searchRequest?.price ?? 0),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DividerCustom(),

                    //another option
                    Column(
                      children: [
                        ItemListWidget(
                          title: "Bảo hiểm chuyến đi",
                          icon: Icons.car_crash_outlined,
                          onPress: () {},
                        ),
                        ItemListWidget(
                          title: "Xuất hóa đơn",
                          icon: Icons.file_open_outlined,
                          onPress: () {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Báo cáo sự cố',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildImagesFromList(List<BookingImage> imagesList) {
    return imagesList.asMap().entries.map((entry) {
      int index = entry.key;
      BookingImage imageObject = entry.value;
      return Padding(
        padding:
            EdgeInsets.only(right: index < imagesList.length - 1 ? 20.0 : 0.0),
        child: SizedBox(
          height: 100,
          width: 100,
          child: InstaImageViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${SERVER_API_URL}${imageObject.bookingImageUrl ?? ''}',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildEmptyImagesList() {
    return List.generate(
      4,
      (index) => Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: SizedBox(
          height: 100,
          width: 100,
          child: Container(
            color: Colors.grey[200],
          ),
        ),
      ),
    );
  }

  Widget _customTextSpanWidget({
    required String labelText,
    required String descriptionText,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: labelText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          TextSpan(
            text: descriptionText,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
