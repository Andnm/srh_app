import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Có lỗi xảy ra khi tải trang.',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
