import 'package:creditask/enums/editable_task_properties.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/utils/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../graphql/api.dart';

class PeriodStartTile extends StatefulWidget {
  final TaskDetail$Query$Task _task;
  final void Function(TaskInputUpdate taskInputUpdate) _onSave;

  PeriodStartTile(this._task, this._onSave);

  @override
  _PeriodStartTileState createState() => _PeriodStartTileState();
}

class _PeriodStartTileState extends State<PeriodStartTile> {
  bool _isEdit = false;

  _PeriodStartTileState();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: Icon(Icons.event_available), // TODO get icon
        title: _isEdit ? null : Text('Frühstens machen am'),
        subtitle: Text(
            '${localDateStringOfIsoDateString(widget._task.periodStart)} (${relativeDateStringOf(widget._task.periodStart)})'),
        trailing: _isEdit ||
                !canEditTaskProperty(
                    EditableTaskProperties.periodStart, widget._task.state)
            ? null
            : IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDateRangePicker(
                            context: context,
                            initialDateRange: DateTimeRange(
                              start: DateTime.parse(widget._task.periodStart),
                              end: DateTime.parse(widget._task.periodEnd),
                            ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)))
                        .then((value) {
                      widget._onSave(TaskInputUpdate(
                        id: widget._task.id,
                        periodStart: dateTimeToIsoDateString(value.start),
                        periodEnd: dateTimeToIsoDateString(value.end),
                      ));
                    })),
      ),
    ]);
  }
}
