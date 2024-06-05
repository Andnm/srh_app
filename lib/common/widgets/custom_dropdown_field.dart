import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String labelText;
  final String placeholderText;
  final bool editMode;
  final List<String?> items;

  const CustomDropdownField({
    Key? key,
    this.value,
    this.onChanged,
    required this.labelText,
    required this.placeholderText,
    required this.editMode,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.transgender),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[500]!),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          isDense: true,
          value: value,
          onChanged:  onChanged ,
          items: items.map((String? value) {
            return DropdownMenuItem<String?>(
              value: value,
              child: Text(value == '' ? placeholderText : value!),
            );
          }).toList(),
        ),
      ),
    );
  }
}
