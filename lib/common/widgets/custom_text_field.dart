import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool readOnlyStatus;
  final void Function(String)? onChanged;
  final void Function()? onTap;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    required this.inputType,
    this.readOnlyStatus = true,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[500]!),
        ),
      ),
      controller: controller,
      readOnly: readOnlyStatus,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
