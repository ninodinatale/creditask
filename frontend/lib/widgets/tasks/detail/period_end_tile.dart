import 'package:creditask/enums/editable_task_properties.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/utils/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../graphql/api.dart';

class PeriodEndTile extends StatefulWidget {
  final TaskDetail$Query$Task _task;
  final void Function(TaskInputUpdate taskInputUpdate) _onSave;

  PeriodEndTile(this._task, this._onSave);

  @override
  _PeriodEndTileState createState() => _PeriodEndTileState();
}

class _PeriodEndTileState extends State<PeriodEndTile> {
  bool _isEdit = false;
  bool _overdue = false;

  _PeriodEndTileState();

  @override
  void initState() {
    super.initState();
    setTaskState();
  }

  @override
  void didUpdateWidget(PeriodEndTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    setTaskState();
  }

  void setTaskState() {
    var now = DateTime.now();
    now = floorDay(now);
    final periodEnd = DateTime.parse(widget._task.periodEnd);
    _overdue = periodEnd.isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(children: [
      ListTile(
        leading: Icon(Icons.event_busy), // TODO get icon
        title: _isEdit
            ? null
            : Text(
                'Spätestens machen am',
              ),
        subtitle: Text(
            '${localDateStringOfIsoDateString(widget._task.periodEnd)} (${relativeDateStringOf(widget._task.periodEnd)})',
            style: TextStyle(
                color: widget._task.state == TaskState.toDo && _overdue
                    ? theme.errorColor
                    : null)),
        trailing: _isEdit ||
                !canEditTaskProperty(
                    EditableTaskProperties.periodEnd, widget._task.state)
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
                      if (value != null) {
                        widget._onSave(TaskInputUpdate(
                          id: widget._task.id,
                          periodStart: dateTimeToIsoDateString(value.start),
                          periodEnd: dateTimeToIsoDateString(value.end),
                        ));
                      }
                    })),
      ),
    ]);
  }
}
