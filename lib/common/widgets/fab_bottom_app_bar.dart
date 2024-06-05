import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({required this.iconData, required this.text});
  IconData? iconData;
  String text;
}

// ignore: must_be_immutable
class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    super.key,
    required this.items,
    this.height = 60.0,
    this.iconSize = 30.0,
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    required this.notchedShape,
    required this.onTabSelected,
    required this.tabSelected,
    this.notificationBadge,
  });
  late int? tabSelected;
  final List<FABBottomAppBarItem> items;
  final int? notificationBadge; // Optional parameter for the notification badge
  final double? height;
  final double? iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      widget.tabSelected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
        notificationBadge: index == 3
            ? widget.notificationBadge
            : null, // Display badge only for index 3
      );
    });

    return BottomAppBar(
      shape: widget.notchedShape,
      color: widget.backgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
    int? notificationBadge,
  }) {
    Color color =
        widget.tabSelected == index ? widget.selectedColor : Colors.grey;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (notificationBadge != null &&
                    notificationBadge > 0 &&
                    index == 3)
                  badges.Badge(
                    badgeContent: Text(
                      notificationBadge.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Icon(
                      item.iconData,
                      size: widget.iconSize,
                      color: color,
                    ),
                  ),
                if (notificationBadge != null &&
                    notificationBadge == 0 &&
                    index == 3)
                  Icon(
                    item.iconData,
                    size: widget.iconSize,
                    color: color,
                  ),
                if (index != 3)
                  Icon(
                    item.iconData,
                    size: widget.iconSize,
                    color: color,
                  ),
                Text(
                  item.text,
                  style: TextStyle(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
