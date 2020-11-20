import 'package:creditask/graphql/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreditsCalcInput extends StatefulWidget {
  @required
  final void Function(CreditsCalc) onChanged;
  final CreditsCalc initialValue;

  CreditsCalcInput({this.onChanged, this.initialValue});

  @override
  _CreditsCalcInputState createState() =>
      _CreditsCalcInputState(initialValue, onChanged);
}

class _CreditsCalcInputState extends State<CreditsCalcInput> {
  CreditsCalc _selectedValue;
  final void Function(CreditsCalc) onChanged;

  _CreditsCalcInputState(this._selectedValue, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Credits Berechnung'
      ),
      value: _selectedValue,
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
        onChanged(value);
      },
      items: [
        DropdownMenuItem(
          child: Text('Anhand Minuten'),
          value: CreditsCalc.byFactor,
        ),
        DropdownMenuItem(
          child: Text('Pauschal'),
          value: CreditsCalc.fixed,
        ),
      ],
    );
  }
}
