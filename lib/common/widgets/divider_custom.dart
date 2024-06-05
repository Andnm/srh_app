import 'package:flutter/material.dart';

class DividerCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
