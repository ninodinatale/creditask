import 'package:creditask/utils/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeriodInput extends StatelessWidget {
  @required
  final void Function(DateTimeRange) onSaved;
  final FocusNode focusNode;
  final DateTimeRange initialValue;

  PeriodInput({
    void Function(DateTimeRange) onSaved,
    FocusNode focusNode,
    DateTimeRange initialValue,
  })  : onSaved = onSaved,
        focusNode = focusNode,
        initialValue = initialValue;

  final TextEditingController _controller = TextEditingController();

  void showPicker(BuildContext context) {
    showDateRangePicker(
        context: context,
        initialDateRange: initialValue,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 265)))
        .then((value) {
      _controller.text = getInputString(value);
      onSaved(value);
    });
  }

  String getInputString(DateTimeRange value) {
    if (value != null) {
      return '${localDateStringOfDateTime(value.start)} - ${localDateStringOfDateTime(value.end)}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) {
      _controller.text = getInputString(initialValue);
    }
    return TextFormField(
        focusNode: focusNode,
        controller: _controller,
        onTap: () => showPicker(context),
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Frühestens machen am',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Eingabe darf nicht leer sein';
          }
          return null;
        });
  }
}
