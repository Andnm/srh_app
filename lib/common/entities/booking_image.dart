import 'dart:io';

import 'package:cus_dbs_app/common/entities/notification/notification_booking_request.dart';
import 'package:cus_dbs_app/common/entities/search_request_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class BookingImage {
  String? id;
  String? bookingId;
  NotificationBookingModel? booking;
  String? bookingImageUrl;
  String? bookingImageType;
  File? bookingImageFile;
  String? bookingImageTime;

  BookingImage(
      {this.id,
      this.bookingId,
      this.booking,
      this.bookingImageUrl,
      this.bookingImageFile,
      this.bookingImageType,
      this.bookingImageTime});

  BookingImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['bookingId'];
    booking = json['booking'] != null
        ? new NotificationBookingModel.fromJson(json['booking'])
        : null;
    bookingImageUrl = json['imageUrl'];
    bookingImageType = json['bookingImageType'];
    bookingImageTime = json['bookingImageTime'];
  }

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['BookingId'] = this.bookingId;

    data['File'] = await MultipartFile.fromFile(
      this.bookingImageFile!.path,
    );
    data['BookingImageType'] = this.bookingImageType;

    return data;
  }

  @override
  String toString() {
    return 'BookingImage{id: $id, bookingId: $bookingId, booking: $booking, bookingImageUrl: $bookingImageUrl, bookingImageType: $bookingImageType, bookingImageFile: $bookingImageFile, bookingImageTime: $bookingImageTime}';
  }
}
