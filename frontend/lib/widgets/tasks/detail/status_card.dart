import 'package:creditask/graphql/api.graphql.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/utils/transformers.dart';
import 'package:creditask/widgets/_shared/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'approvals_list.dart';

class StatusCard extends StatelessWidget {
  final TaskDetail$Query$Task _task;

  const StatusCard(this._task);

  @override
  Widget build(BuildContext context) {
    final _taskStateData = taskStateData(_task.state);

    return Card(
      child: Column(
        children: [
          Card(
            color: _taskStateData.item2?.withOpacity(0.7),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(_taskStateData.item1),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      children: [
                        Text(
                          transformTaskState(_task.state),
                          style: TextStyle(fontSize: 18),
                        ),
                        // TODO decline reasons
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (![TaskState.toDo, TaskState.done]
              .contains(_task.state))
            ApprovalsList(_task),
        ],
      ),
    );
  }
}
