import 'package:creditask/providers/graphql.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/utils/transformers.dart';
import 'package:creditask/widgets/_shared/error_screen.dart';
import 'package:creditask/widgets/_shared/task_state_icon.dart';
import 'package:creditask/widgets/tasks/detail/assignment_tile.dart';
import 'package:creditask/widgets/tasks/detail/fixed_credits_tile.dart';
import 'package:creditask/widgets/tasks/detail/needed_time_tile.dart';
import 'package:creditask/widgets/tasks/detail/period_end_tile.dart';
import 'package:creditask/widgets/tasks/detail/period_start_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphql/api.dart';
import 'action_buttons.dart';
import 'factor_tile.dart';

class TaskDetail extends StatefulWidget {
  final TaskDetail$Query$Task _task;

  TaskDetail(this._task);

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  RunMutation _runMutation;

  bool _isLoading = false;

  _TaskDetailState();

  void saveChanges(TaskInputUpdate taskInputUpdate) {
    setState(() {
      _isLoading = true;
    });
    // TODO add optimistic result
    this._runMutation(
        UpdateDetailTaskArguments(updateInput: taskInputUpdate).toJson());
  }

  @override
  Widget build(BuildContext context) {
    UpdateDetailTaskMutation mutation = UpdateDetailTaskMutation();
    return Mutation(
      options: MutationOptions(
          documentNode: mutation.document,
          // will be called for both optimistic and final results
          update: (Cache cache, QueryResult result) {
            if (result.hasException) {
              return ErrorDialog(result.exception.toString());
            } else {
              var updatedTask =
                  UpdateDetailTask$Mutation.fromJson(result.data).saveTask.task;
              var updatedTaskJson = widget._task.toJson()
                ..addAll(updatedTask.toJson());
              cache.write(uuidFromObject(updatedTaskJson), updatedTaskJson);
              emitTaskDidChange();
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Änderung gespeichert'),
                      Icon(Icons.check, color: Colors.green)
                    ],
                  )));
            }
          },
          onCompleted: (_) =>
              // TODO remove this if optimistic result is implemented
              setState(() {
                _isLoading = false;
              }),
          onError: (OperationException error) {
            // TODO
          }),
      builder: (RunMutation runMutation, QueryResult result) {
        this._runMutation = runMutation;
        return ListView(
          shrinkWrap: true,
          children: [
            Card(
              child: ListTile(
                leading: TaskStateIcon(widget._task.state), // TODO get icon
                title: Text(transformTaskState(widget._task.state)),
              ),
            ),
            AssignmentTile(widget._task, _isLoading, saveChanges),
            widget._task.creditsCalc == CreditsCalc.fixed
                ? FixedCreditsTile(widget._task, _isLoading, saveChanges)
                : FactorTile(widget._task, _isLoading, saveChanges),
            NeededTimeTile(widget._task, saveChanges),
            PeriodStartTile(widget._task, saveChanges),
            PeriodEndTile(widget._task, saveChanges),
            ActionButtons(widget._task),
          ],
        );
      },
    );
  }
}