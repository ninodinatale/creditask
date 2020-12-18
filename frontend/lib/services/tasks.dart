import 'dart:async';

import 'package:creditask/enums/editable_task_properties.dart';
import 'package:creditask/graphql/api.dart';
import 'package:creditask/utils/date_format.dart';
import 'package:flutter/material.dart';

StreamController<void> _controller =
    StreamController<void>.broadcast(sync: true);

StreamSubscription<void> subscribeToTaskDidChange(void Function() callback) {
  return _controller.stream.listen((_) => callback());
}

void emitTaskDidChange() {
  _controller.add(null);
}

bool canEditTaskProperty(EditableTaskProperties property, TaskState taskState) {
  switch (taskState) {
    case TaskState.toDo:
      return true;
    case TaskState.toApprove:
      return property == EditableTaskProperties.name;
    case TaskState.declined:
    case TaskState.approved:
      return false;
    default:
      return false;
  }
}

IconData approvalIconData(ApprovalState approvalState) {
  switch (approvalState) {
    case ApprovalState.none:
      return Icons.radio_button_unchecked;
      break;
    case ApprovalState.approved:
      return Icons.check_circle_outline;
      break;
    case ApprovalState.declined:
      return Icons.highlight_off;
      break;
    default:
      return Icons.help_outline;
      break;
  }
}

Map<String, List<SimpleTaskMixin>> splitByDueDays(List<SimpleTaskMixin> tasks) {
  final overdue = <SimpleTaskMixin>[];
  final today = <SimpleTaskMixin>[];
  final next7Days = <SimpleTaskMixin>[];
  final later = <SimpleTaskMixin>[];

  for (final task in tasks) {
    var now = DateTime.now();

    now = floorDay(now);

    // make now the start of the day
    final periodEnd = DateTime.parse(task.periodEnd);

    if (periodEnd.isAtSameMomentAs(now)) {
      today.add(task);
    } else if (periodEnd.isBefore(now)) {
      overdue.add(task);
    } else if (periodEnd.isBefore(now.add(Duration(days: 7)))) {
      next7Days.add(task);
    } else {
      later.add(task);
    }
  }

  return {'overdue': overdue, 'today': today, 'next7Days': next7Days, 'later': later};
}
