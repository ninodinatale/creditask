import 'dart:async';

import 'package:creditask/enums/editable_task_properties.dart';
import 'package:creditask/graphql/api.dart';
import 'package:creditask/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

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

Tuple2<IconData, Color> taskStateData(TaskState taskState) {
  IconData iconData;
  MaterialColor color;
  switch (taskState) {
    case TaskState.toDo:
      iconData = Icons.check_box_outline_blank_rounded;
      break;
    case TaskState.toApprove:
      iconData = Icons.access_time;
      color = Colors.amber;
      break;
    case TaskState.approved:
      iconData = Icons.check_circle_outline;
      color = Colors.green;
      break;
    case TaskState.declined:
      iconData = Icons.close_outlined;
      color = Colors.red;
      break;
    case TaskState.done:
      iconData = Icons.check_circle_outline;
      color = Colors.green;
      break;
    default:
      iconData = Icons.help;
  }

  return Tuple2(iconData, color);
}

Tuple2<IconData, Color> approvalStateData(ApprovalState approvalState, BuildContext ctx) {
  IconData iconData;
  Color color;
  final theme = Theme.of(ctx);
  switch (approvalState) {
    case ApprovalState.none:
      iconData = Icons.radio_button_unchecked;
      color = theme.colorScheme.onSurface;
      break;
    case ApprovalState.approved:
      iconData = Icons.check_circle_outline;
      color = Colors.green;
      break;
    case ApprovalState.declined:
      iconData = Icons.highlight_off;
      color = Colors.red;
      break;
    default:
      iconData = Icons.help_outline;
      break;
  }

  return Tuple2(iconData, color);
}

Map<String, List<T>> splitByDueDays<T extends SimpleTaskMixin>(List<T> tasks) {
  final overdue = <T>[];
  final today = <T>[];
  final next7Days = <T>[];
  final later = <T>[];

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
