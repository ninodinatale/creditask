import 'package:creditask/graphql/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskStateIcon extends StatelessWidget {
  final TaskState taskState;

  TaskStateIcon(this.taskState);

  @override
  Icon build(BuildContext context) {
    IconData iconData;
    MaterialColor color;
    switch (taskState) {
      case TaskState.toDo:
        iconData = Icons.check_box_outline_blank_rounded;
        break;
      case TaskState.toApprove:
        iconData = Icons.access_time;
        color = Colors.green;
        break;
      case TaskState.approved:
        iconData = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case TaskState.declined:
        iconData = Icons.close_outlined;
        color = Colors.red;
        break;
      default:
        iconData = Icons.help;
    }

    return Icon(
      iconData,
      color: color,
    );
  }
}