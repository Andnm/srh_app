import 'package:flutter/material.dart';

class StatusText extends StatelessWidget {
  final String status;

  StatusText({required this.status});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);
    final String statusName = statusInfo['name'];
    final Color statusColor = statusInfo['color'];

    return Text(
      statusName,
      style: TextStyle(
        color: statusColor,
        fontSize: 15,
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status) {
      case 'Accept':
        return {'name': 'Đã chấp nhận', 'color': Colors.teal};
      case 'Arrived':
        return {'name': 'Đã đến điểm đón', 'color': Colors.purple};
      case 'CheckIn':
        return {'name': 'Đang chụp xác nhận', 'color': Colors.orange};
      case 'OnGoing':
        return {'name': 'Đang di chuyển', 'color': Colors.blue};
      case 'CheckOut':
        return {'name': 'Đang chụp xác nhận', 'color': Colors.orange};
      case 'Waiting':
        return {'name': 'Đang xử lý', 'color': Colors.orange};
      case 'Success':
        return {'name': 'Thành công', 'color': Colors.green};
      case 'Complete':
        return {'name': 'Hoàn thành', 'color': Colors.green};
      case 'PayBooking':
        return {'name': 'Đang thanh toán', 'color': Colors.orange};
      case 'Cancel':
        return {'name': 'Đã hủy cuốc', 'color': Colors.red};
      case 'Failure':
        return {'name': 'Không thành công', 'color': Colors.red};
      default:
        return {'name': status, 'color': Colors.grey};
    }
  }
}
