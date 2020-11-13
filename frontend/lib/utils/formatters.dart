import 'package:flutter/services.dart';

class MinutesTextFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.length > 0) {
      int newIntValue = int.tryParse(newValue.text);
      if (newIntValue != null && newIntValue < 60) {
        return newValue;
      } else {
        return oldValue;
      }
    } else {
      return newValue;
    }
  }
}

class HoursTextFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.length > 0) {
      int newIntValue = int.tryParse(newValue.text);
      if (newIntValue != null) {
        return newValue;
      } else {
        return oldValue;
      }
    } else {
      return newValue;
    }
  }
}
