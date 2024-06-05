import 'package:cus_dbs_app/common/entities/booking_history.dart';

class RatingModel {
  String? id;
  String? bookingId;
  BookingHistory? booking;
  int? star;
  String? comment;
  String? imageUrl;
  String? dateCreated;

  RatingModel(
      {this.id,
      this.bookingId,
      this.booking,
      this.star,
      this.comment,
      this.imageUrl,
      this.dateCreated});

  RatingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['bookingId'];
    booking =
        json['booking'] != null ? new BookingHistory.fromJson(json['booking']) : null;
    star = json['star'];
    comment = json['comment'];
    imageUrl = json['imageUrl'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookingId'] = this.bookingId;
    if (this.booking != null) {
      data['booking'] = this.booking!.toJson();
    }
    data['star'] = this.star;
    data['comment'] = this.comment;
    data['imageUrl'] = this.imageUrl;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}