import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final formatter = NumberFormat("#,###", "vi_VN");

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final int selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;
    final f = NumberFormat("#,###", "vi_VN");

    final number = int.parse(newValue.text.replaceAll(',', ''));
    final newString = f.format(number);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(
        offset: newString.length - selectionIndexFromTheRight,
      ),
    );
  }
}
