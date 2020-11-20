import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FactorInput extends TextFormField {
  FactorInput({
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
              labelText: 'Faktor',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Eingabe darf nicht leer sein';
              } else {
                double parsedValue = double.tryParse(value);
                if (parsedValue == null) {
                  return 'Eingabe muss eine Zahl sein';
                } else if (parsedValue <= 0) {
                  return 'Eingabe muss grösser als 0 sein';
                }
              }
              return null;
            });
}
