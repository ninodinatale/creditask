import 'dart:async';

import 'package:creditask/providers/auth.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/widgets/_shared/loadnig_button_content.dart';
import 'package:creditask/widgets/_shared/user_avatar.dart';
import 'package:creditask/widgets/tasks/detail/task_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../../graphql/api.dart';

class TaskToApprove extends StatefulWidget {
  final ToApproveTasksOfUser$Query$ToApproveTasksOfUser _task;
  final Request _request;

  const TaskToApprove(this._task, this._request);

  @override
  _TaskToApproveState createState() => _TaskToApproveState();
}

class _TaskToApproveState extends State<TaskToApprove> {
  bool _isLoading = false;

  RunMutation _runMutation;

  Future<void> _showConfirmDialog(ApprovalInput approvalInput) async {
    final text = approvalInput.state == ApprovalState.approved
        ? 'Akzeptieren'
        : 'Ablehnen';
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  title: Text('$text'),
                  content: SingleChildScrollView(
                    child: Text('Willst du $text?'),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Abbrechen'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    RaisedButton(
                      child: LoadingButtonContent(_isLoading, text),
                      onPressed: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _isLoading = true;
                              });
                              // TODO add optimistic result
                              this._runMutation(UpdateApprovalArguments(
                                      approval: approvalInput)
                                  .toJson());
                            },
                    ),
                  ],
                ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    String myApprovalId = widget._task.approvals
        .firstWhere((element) => element.user.id == auth.currentUser.id)
        .id;
    UpdateApprovalMutation mutation = UpdateApprovalMutation();
    return Mutation(
      options: MutationOptions(
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          document: mutation.document,
          update: (GraphQLDataProxy cache, QueryResult result) {
            if (result.hasException) {
              // TODO
            } else {
              var updatedApproval =
                  UpdateApproval$Mutation.fromJson(result.data)
                      .saveApproval
                      .approval;

              // TODO make this more performant
              final clonedTask =
                  ToApproveTasksOfUser$Query$ToApproveTasksOfUser.fromJson(
                      widget._task.toJson());
              clonedTask.approvals
                  .firstWhere((element) => element.id == updatedApproval.id)
                  .state = updatedApproval.state;
              final updatedTaskJson = clonedTask.toJson();
              cache.writeQuery(widget._request, data: updatedTaskJson);
              Navigator.of(context).pop();
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
        final themeData = Theme.of(context);
        this._runMutation = runMutation;
        return ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskDetailScreen(widget._task.id))),
            leading: UserAvatar(widget._task.user.publicName),
            title: Text(widget._task.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget._task.approvals.map((a) {
                final _apprStateData = approvalStateData(a.state, context);
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Icon(
                        _apprStateData.item1,
                        color: _apprStateData.item2?.withOpacity(0.6),
                        size: 15,
                      ),
                    ),
                    Text(a.user.publicName),
                  ],
                );
              }).toList(),
            ));
      },
    );
  }
}
