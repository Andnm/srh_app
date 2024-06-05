import 'booking.dart';
import 'notification/notification_booking_request.dart';
import 'notification/notification_payment.dart';

class Emergency {
  String? id;
  User? sender;
  User? handler;
  NotificationBookingModel? booking;
  String? note;
  String? solution;
  String? status;
  String? emergencyType;
  String? senderAddress;
  double? senderLatitude;
  double? senderLongitude;

  Emergency(
      {this.id,
      this.sender,
      this.handler,
      this.booking,
      this.note,
      this.solution,
      this.status,
      this.emergencyType,
      this.senderAddress,
      this.senderLatitude,
      this.senderLongitude});

  Emergency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender = json['sender'] != null ? new User.fromJson(json['sender']) : null;
    handler =
        json['handler'] != null ? new User.fromJson(json['handler']) : null;
    booking = json['booking'] != null
        ? new NotificationBookingModel.fromJson(json['booking'])
        : null;
    note = json['note'];
    solution = json['solution'];
    status = json['status'];
    emergencyType = json['emergencyType'];
    senderAddress = json['senderAddress'];
    senderLatitude = json['senderLatitude'];
    senderLongitude = json['senderLongitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    if (this.handler != null) {
      data['handler'] = this.handler!.toJson();
    }
    if (this.booking != null) {
      data['booking'] = this.booking!.toJson();
    }
    data['note'] = this.note;
    data['solution'] = this.solution;
    data['status'] = this.status;
    data['emergencyType'] = this.emergencyType;
    data["bookingId"] = this.booking!.id;
    data['senderAddress'] = this.senderAddress;
    data['senderLatitude'] = this.senderLatitude;
    data['senderLongitude'] = this.senderLongitude;
    return data;
  }

  @override
  String toString() {
    return 'Emergency{id: $id, sender: $sender, handler: $handler, booking: $booking, note: $note, solution: $solution, status: $status, emergencyType: $emergencyType, senderAddress: $senderAddress, senderLatitude: $senderLatitude, senderLongitude: $senderLongitude}';
  }
}
