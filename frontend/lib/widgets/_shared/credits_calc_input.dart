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
    ThemeData themeData = Theme.of(context);

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        // artemisUnknown shouldn't be listed, therefore -1
        itemCount: CreditsCalc.values.length - 1,
        itemBuilder: (context, index) {
          return ListTile(
            // TODO do this with creditscalc values and translations
            title: Text(index == 0 ? 'Anhand Minuten' : 'Pauschal'),
            leading: Radio<CreditsCalc>(
                activeColor: themeData.accentColor,
                value: CreditsCalc.values[index],
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                  onChanged(value);
                }),
          );
        });
  }
}
