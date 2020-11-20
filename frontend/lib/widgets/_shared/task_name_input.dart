import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskNameInput extends TextFormField {
  TaskNameInput({
    bool autofocus = false,
    FocusNode focusNode,
    FormFieldSetter<String> onSaved,
  }) : super(
            focusNode: focusNode,
            autofocus: autofocus,
            onSaved: onSaved,
            decoration: InputDecoration(
                labelText: 'Name'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Eingabe darf nicht leer sein';
              } else if (value.length < 3) {
                return 'Eingabe muss mindestens 3 Zeichen lang sein';
              }
              return null;
            });
}
