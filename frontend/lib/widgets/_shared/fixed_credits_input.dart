import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FixedCreditsInput extends TextFormField {
  FixedCreditsInput({
    String initialValue,
    FocusNode focusNode,
    bool autofocus = false,
    FormFieldSetter<String> onSaved,
  }) : super(
            initialValue: initialValue,
            focusNode: focusNode,
            autofocus: autofocus,
            keyboardType: TextInputType.number,
            onSaved: onSaved,
            decoration: const InputDecoration(
              labelText: 'Pauschale Credits',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Eingabe darf nicht leer sein';
              } else {
                int parsedValue = int.tryParse(value);
                if (parsedValue == null) {
                  return 'Eingabe muss eine Ganzzahl sein';
                } else if (parsedValue <= 0) {
                  return 'Eingabe muss grösser als 0 sein';
                }
              }
              return null;
            });
}
