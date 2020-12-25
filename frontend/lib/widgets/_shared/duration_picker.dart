import 'package:creditask/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class DurationPicker {
  final Widget title;
  final Duration duration;

  DurationPicker({@required this.title, @required this.duration});

  Future<Duration> show(BuildContext context) {
    final hours = duration.inHours;
    var minutes = duration.inMinutes.remainder(60);
    var secs = duration.inSeconds.remainder(60);
    if (secs > 0) {
      minutes++;
    }

    final hoursController = TextEditingController(text: hours.toString());
    final minutesController = TextEditingController(text: minutes.toString());

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: title,
            actions: [
              TextButton(
                child: Text('ABBRECHEN'),
                onPressed: () => Navigator.pop(context),
              ),
              RaisedButton(
                child: Text('SPEICHERN'),
                onPressed: () => Navigator.pop(
                    context,
                    Duration(
                        hours: int.parse(hoursController.text),
                        minutes: int.parse(minutesController.text))),
              ),
            ],
            content: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: hoursController,
                    decoration: InputDecoration(helperText: 'Stunden'),
                    inputFormatters: [HoursTextFormatter()],
                    keyboardType: TextInputType.number,
                  ),
                ),
                Text('  :  '),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: minutesController,
                    decoration: InputDecoration(helperText: 'Minuten'),
                    inputFormatters: [MinutesTextFormatter()],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            )));
  }
}
