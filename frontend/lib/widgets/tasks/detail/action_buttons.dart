import 'package:creditask/providers/auth.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/widgets/_shared/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../../graphql/api.dart';

class ActionButtons extends StatefulWidget {
  final TaskDetail$Query$Task _task;
  final Request _request;

  ActionButtons(this._task, this._request);

  @override
  _ActionButtonsState createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  RunMutation _runUpdateApprovalMutation;
  RunMutation _runUpdateTaskMutation;

  void saveTaskChanges(String id, TaskState state, int neededTimeSeconds) {
    UpdateDetailTask$Mutation optimisticResult = UpdateDetailTask$Mutation()
      ..saveTask = (UpdateDetailTask$Mutation$SaveTask()
        ..task = (UpdateDetailTask$Mutation$SaveTask$Task()
          ..id = id
          ..state = state
          ..neededTimeSeconds = neededTimeSeconds));

    this._runUpdateTaskMutation(
        UpdateDetailTaskArguments(
                updateInput: TaskInputUpdate(
                    id: id, state: state, neededTimeSeconds: neededTimeSeconds))
            .toJson(),
        optimisticResult: optimisticResult.toJson());
  }

  void saveApprovalChanges(ApprovalInput approvalInput) {
    UpdateApproval$Mutation optimisticResult = UpdateApproval$Mutation()
      ..saveApproval = (UpdateApproval$Mutation$SaveApproval()
        ..approval =
            ((UpdateApproval$Mutation$SaveApproval$Approval()..id = approvalInput.id)
              ..state = approvalInput.state));

    this._runUpdateApprovalMutation(
        UpdateApprovalArguments(approval: approvalInput).toJson(),
        optimisticResult: optimisticResult.toJson());
  }

  List<RaisedButton> getActionButtons(AuthProvider auth, ThemeData theme) {
    var buttons = <RaisedButton>[];

    final isMyTask = auth.currentUser.id == widget._task.user?.id;
    if (isMyTask) {
      switch (widget._task.state) {
        case TaskState.toDo:
          buttons.add(RaisedButton(
            color: Colors.green,
            onPressed: () => DurationPicker(
                    title: Text('Benötigte Zeit'),
                    duration: Duration(seconds: widget._task.neededTimeSeconds))
                .show(context)
                .then((value) => saveTaskChanges(
                    widget._task.id, TaskState.toApprove, value.inSeconds)),
            child: Text('Auf gemacht setzen'),
          ));
          break;
        default:
          break;
      }
    } else {
      var myApproval = widget._task.approvals
          .firstWhere((a) => a.user.id == auth.currentUser.id);
      switch (widget._task.state) {
        case TaskState.toApprove:
          if (myApproval != null) {
            switch (myApproval.state) {
              case ApprovalState.none:
                buttons.add(RaisedButton(
                  color: Colors.green,
                  onPressed: () => saveApprovalChanges(ApprovalInput(
                      id: myApproval.id, state: ApprovalState.approved)),
                  child: Text('Akzeptieren'),
                ));
                buttons.add(RaisedButton(
                  color: Colors.redAccent,
                  onPressed: () => saveApprovalChanges(ApprovalInput(
                      id: myApproval.id, state: ApprovalState.declined)),
                  child: Text('Ablehnen'),
                ));
                break;
              case ApprovalState.approved:
                buttons.add(RaisedButton(
                  onPressed: () => saveApprovalChanges(ApprovalInput(
                      id: myApproval.id, state: ApprovalState.none)),
                  child: Text('Zurücksetzen'),
                ));
                buttons.add(RaisedButton(
                  color: Colors.redAccent,
                  onPressed: () => saveApprovalChanges(ApprovalInput(
                      id: myApproval.id, state: ApprovalState.declined)),
                  child: Text('Ablehnen'),
                ));
                break;
              case ApprovalState.declined:
                buttons.add(RaisedButton(
                  color: Colors.green,
                  onPressed: () => saveApprovalChanges(ApprovalInput(
                      id: myApproval.id, state: ApprovalState.approved)),
                  child: Text('Akzeptieren'),
                ));
                buttons.add(RaisedButton(
                  onPressed: () => saveApprovalChanges(ApprovalInput(
                      id: myApproval.id, state: ApprovalState.none)),
                  child: Text('Zurücksetzen'),
                ));
                break;
              default:
                break;
            }
          } else {
            buttons.add(RaisedButton(
              color: Colors.green,
              onPressed: () => saveApprovalChanges(ApprovalInput(
                  id: myApproval.id, state: ApprovalState.approved)),
              child: Text('Akzeptieren'),
            ));
            buttons.add(RaisedButton(
              color: Colors.redAccent,
              onPressed: () => saveApprovalChanges(ApprovalInput(
                  id: myApproval.id, state: ApprovalState.declined)),
              child: Text('Ablehnen'),
            ));
          }
          break;
        default:
          break;
      }
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    UpdateApprovalMutation approvalMutation = UpdateApprovalMutation();
    UpdateDetailTaskMutation taskMutation = UpdateDetailTaskMutation();
    final theme = Theme.of(context);
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Mutation(
          options: MutationOptions(
              document: approvalMutation.document,
              update: (GraphQLDataProxy cache, QueryResult result) {
                if (result.hasException) {
                  // TODO
                } else {
                  var newApprovalState =
                      UpdateApproval$Mutation.fromJson(result.data)
                          .saveApproval
                          .approval
                          .state;

                  var updatedTask =
                      TaskDetail$Query$Task.fromJson(widget._task.toJson())
                        ..approvals
                            .firstWhere((element) =>
                                element.user.id == auth.currentUser.id)
                            .state = newApprovalState;
                  if (!updatedTask.approvals.any((element) => element.state == ApprovalState.none)) {
                    if (updatedTask.approvals.any((element) => element.state == ApprovalState.declined)) {
                      updatedTask.state = TaskState.declined;
                    } else  {
                      updatedTask.state = TaskState.approved;
                    }
                  }

                  TaskDetail$Query query = TaskDetail$Query()
                    ..task = updatedTask;

                  cache.writeQuery(widget._request, data: query.toJson());
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
              onError: (OperationException error) {
                // TODO
              }),
          builder: (RunMutation runUpdateApprovalMutation, QueryResult result) {
            this._runUpdateApprovalMutation = runUpdateApprovalMutation;
            return Mutation(
              options: MutationOptions(
                  document: taskMutation.document,
                  update: (GraphQLDataProxy cache, QueryResult result) {
                    if (result.hasException) {
                      // TODO
                    } else {
                      UpdateDetailTask$Mutation$SaveTask$Task updatedTask =
                          UpdateDetailTask$Mutation.fromJson(result.data)
                              .saveTask
                              .task;

                      widget._task.toJson()..addAll(updatedTask.toJson());
                      TaskDetail$Query query = TaskDetail$Query()
                        ..task = (TaskDetail$Query$Task.fromJson(
                            widget._task.toJson()
                              ..addAll(updatedTask.toJson())));

                      cache.writeQuery(widget._request, data: query.toJson());
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
                  onError: (OperationException error) {
                    // TODO
                  }),
              builder: (RunMutation runUpdateTaskMutation, QueryResult result) {
                this._runUpdateTaskMutation = runUpdateTaskMutation;
                return ButtonBar(
                  children: getActionButtons(auth, theme),
                );
              },
            );
          },
        );
      },
    );
  }
}
