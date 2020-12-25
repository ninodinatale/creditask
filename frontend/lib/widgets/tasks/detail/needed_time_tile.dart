import 'package:creditask/enums/editable_task_properties.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/utils/date_format.dart';
import 'package:creditask/widgets/_shared/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../graphql/api.dart';

class NeededTimeTile extends StatefulWidget {
  final TaskDetail$Query$Task _task;
  final void Function(TaskInputUpdate taskInputUpdate) _onSave;

  NeededTimeTile(this._task, this._onSave);

  @override
  _NeededTimeTileState createState() => _NeededTimeTileState();
}

class _NeededTimeTileState extends State<NeededTimeTile> {
  bool _isEdit = false;

  _NeededTimeTileState();

  @override
  Widget build(BuildContext context) {
    Duration _duration = Duration(seconds: widget._task.neededTimeSeconds);
    return Column(children: [
      ListTile(
          leading: Icon(Icons.event_busy), // TODO get icon
          title: _isEdit ? null : Text('Benötigte Zeit'),
          subtitle:
              Text(secondsToElapsedTimeString(widget._task.neededTimeSeconds)),
          trailing: _isEdit ||
                  !canEditTaskProperty(EditableTaskProperties.neededTimeSeconds,
                      widget._task.state)
              ? null
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => DurationPicker(
                              title: Text('Benötigte Zeit'),
                              duration: _duration)
                          .show(context)
                          .then((value) {
                        if (value != null) {
                          widget._onSave(TaskInputUpdate(
                            id: widget._task.id,
                            neededTimeSeconds: value.inSeconds,
                          ));
                        }
                      }))),
    ]);
  }
}
