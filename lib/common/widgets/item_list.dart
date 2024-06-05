import 'package:flutter/material.dart';

class ItemListWidget extends StatelessWidget {
  const ItemListWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blue.shade400.withOpacity(0.1),
        ),
        child: Icon(icon, color: Colors.blue.shade400),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black,
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child:
                  const Icon(Icons.arrow_right, size: 18.0, color: Colors.grey))
          : null,
    );
  }
}
