import 'package:creditask/providers/auth.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/widgets/_shared/duration_picker.dart';
import 'package:creditask/widgets/tasks/set_task_done_button.dart';
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

  void _showApproveConfirmDialog(DetailTaskMixin$Approvals approval) {
    final _msgCtrl = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Akzeptieren'),
              actions: [
                TextButton(
                  child: Text('ABBRECHEN'),
                  onPressed: () => Navigator.pop(context),
                ),
                RaisedButton(
                    child: const Text('AKZEPTIEREN'),
                    onPressed: () {
                      saveApprovalChanges(ApprovalInput(
                          id: approval.id,
                          state: ApprovalState.approved,
                          message: _msgCtrl.text));
                      Navigator.pop(context);
                    }),
              ],
              content: Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Nachricht', helperText: 'Optional'),
                  controller: _msgCtrl,
                ),
              ),
            ));
  }

  void _showToDoConfirmDialog(TaskDetail$Query$Task task) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Auf zu machen setzen'),
              actions: [
                TextButton(
                  child: Text('ABBRECHEN'),
                  onPressed: () => Navigator.pop(context),
                ),
                RaisedButton(
                    child: const Text('ZU MACHEN'),
                    onPressed: () {
                      saveTaskChanges(widget._task.id, TaskState.toDo,
                          task.neededTimeSeconds);
                      Navigator.pop(context);
                    }),
              ],
              content:
                  Text('Die Aufgabe wieder auf zu machen setzen? Schaue die '
                      'Nachrichten der Benutzer an, welche die Aufgabe '
                      'abgelehnt haben, um zu sehen, was du besser machen '
                      'solltest.'),
            ));
  }

  void _showDeclineConfirmDialog(DetailTaskMixin$Approvals approval) {
    final _msgCtrl = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Ablehnen'),
              actions: [
                TextButton(
                  child: Text('ABBRECHEN'),
                  onPressed: () => Navigator.pop(context),
                ),
                RaisedButton(
                    child: const Text('ABLEHNEN'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        saveApprovalChanges(ApprovalInput(
                            id: approval.id,
                            state: ApprovalState.declined,
                            message: _msgCtrl.text));
                        Navigator.pop(context);
                      }
                    }),
              ],
              content: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Grund muss angegeben werden';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Grund'),
                  controller: _msgCtrl,
                ),
              ),
            ));
  }

  void _showResetConfirmDialog(DetailTaskMixin$Approvals approval) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Zurücksetzen'),
              actions: [
                TextButton(
                  child: Text('ABBRECHEN'),
                  onPressed: () => Navigator.pop(context),
                ),
                RaisedButton(
                    child: const Text('ZURÜCKSETZEN'),
                    onPressed: () {
                      saveApprovalChanges(ApprovalInput(
                          id: approval.id, state: ApprovalState.none));
                      Navigator.pop(context);
                    }),
              ],
              content: Text('Willst du den Status zurücksetzen?'),
            ));
  }

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
              ..state = approvalInput.state
              ..message = approvalInput.message));

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
                .then((value) {
              if (value != null) {
                saveTaskChanges(
                    widget._task.id, TaskState.toApprove, value.inSeconds);
              }
            }),
            child: Text('GEMACHT'),
          ));
          break;
        case TaskState.declined:
          buttons.add(RaisedButton(
            color: theme.primaryColor,
            onPressed: () => _showToDoConfirmDialog(widget._task),
            child: const Text('ZU MACHEN'),
          ));
          break;
        case TaskState.approved:
          SetTaskDoneButton(
              taskId: widget._task.id,
              onUpdate: (GraphQLDataProxy cache, QueryResult result) {
                if (result.hasException) {
                  // TODO
                } else {
                  final _query = (TaskDetail$Query()..task = widget._task)
                    ..task.state = TaskState.done;

                  cache.writeQuery(widget._request, data: _query.toJson());

                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Änderung gespeichert'),
                      Icon(Icons.check, color: Colors.green)
                    ],
                  )));
                }
              });
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
                  onPressed: () => _showApproveConfirmDialog(myApproval),
                  child: const Text('AKZEPTIEREN'),
                ));
                buttons.add(RaisedButton(
                  color: Colors.redAccent,
                  onPressed: () => _showDeclineConfirmDialog(myApproval),
                  child: const Text('ABLEHNEN'),
                ));
                break;
              case ApprovalState.approved:
                buttons.add(RaisedButton(
                  onPressed: () => _showResetConfirmDialog(myApproval),
                  child: Text('ZURÜCKSETZEN'),
                ));
                buttons.add(RaisedButton(
                  color: Colors.redAccent,
                  onPressed: () => _showDeclineConfirmDialog(myApproval),
                  child: const Text('ABLEHNEN'),
                ));
                break;
              case ApprovalState.declined:
                buttons.add(RaisedButton(
                  color: Colors.green,
                  onPressed: () => _showApproveConfirmDialog(myApproval),
                  child: const Text('AKZEPTIEREN'),
                ));
                buttons.add(RaisedButton(
                  onPressed: () => _showResetConfirmDialog(myApproval),
                  child: Text('ZURÜCKSETZEN'),
                ));
                break;
              default:
                break;
            }
          } else {
            buttons.add(RaisedButton(
              color: Colors.green,
              onPressed: () => _showApproveConfirmDialog(myApproval),
              child: const Text('AKZEPTIEREN'),
            ));
            buttons.add(RaisedButton(
              color: Colors.redAccent,
              onPressed: () => _showDeclineConfirmDialog(myApproval),
              child: const Text('ABLEHNEN'),
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
              fetchPolicy: FetchPolicy.cacheAndNetwork,
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
                  var newApprovalMsg =
                      UpdateApproval$Mutation.fromJson(result.data)
                          .saveApproval
                          .approval
                          .message;

                  var updatedTask =
                      TaskDetail$Query$Task.fromJson(widget._task.toJson())
                        ..approvals.firstWhere((element) {
                          if (element.user.id == auth.currentUser.id) {
                            element.state = newApprovalState;
                            element.message = newApprovalMsg;
                            return true;
                          }
                          return false;
                        });

                  if (!updatedTask.approvals
                      .any((element) => element.state == ApprovalState.none)) {
                    if (updatedTask.approvals.any(
                        (element) => element.state == ApprovalState.declined)) {
                      updatedTask.state = TaskState.declined;
                    } else {
                      updatedTask.state = TaskState.approved;
                    }
                  }

                  TaskDetail$Query query = TaskDetail$Query()
                    ..task = updatedTask;

                  cache.writeQuery(widget._request, data: query.toJson());
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
                  fetchPolicy: FetchPolicy.cacheAndNetwork,
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
