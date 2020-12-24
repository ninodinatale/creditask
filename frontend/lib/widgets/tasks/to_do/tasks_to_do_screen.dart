import 'dart:async';

import 'package:creditask/providers/auth.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/utils/date_format.dart';
import 'package:creditask/widgets/_shared/user_avatar.dart';
import 'package:creditask/widgets/tasks/detail/task_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../../graphql/api.dart';
import '../../_shared/error_screen.dart';

class TasksToDoScreen extends StatefulWidget {
  @override
  _TasksToDoScreenState createState() => _TasksToDoScreenState();
}

class _TasksToDoScreenState extends State<TasksToDoScreen> {
  StreamSubscription<void> _subscription;
  Request _request;

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  List<Widget> getListTilesFor(List<UsersTodoTasks$Query$TodoTasksOfUser> tasks,
      String title, bool overdue, ThemeData theme) {
    return [
      tasks.length > 0
          ? Padding(
              child: Text(title, style: theme.textTheme.caption),
              padding: EdgeInsets.only(top: 20))
          : SizedBox.shrink(),
      ...ListTile.divideTiles(
          context: context,
          tiles: tasks.map((task) {
            final _icon = taskStateData(task.state);
            return ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaskDetailScreen(task.id))),
              leading: UserAvatar(task.user.publicName),
              title: Text(task.name),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.state == TaskState.toDo)
                      Text(
                          'Fällig am ${localDateStringOfIsoDateString(task.periodEnd)} (${relativeDateStringOf(task.periodEnd)})',
                          style: TextStyle(
                              color: task.state == TaskState.toDo && overdue
                                  ? theme.errorColor
                                  : null)),
                    if (task.state != TaskState.toDo) ...[
                      ...task.approvals.map((a) {
                        final _apprStateData =
                            approvalStateData(a.state, context);
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
                      if (task.state == TaskState.approved) ...[
                        Text(''), // spacer
                        Mutation(
                          options: MutationOptions(
                              document: TaskSetDoneTaskMutation().document,
                              update:
                                  (GraphQLDataProxy cache, QueryResult result) {
                                if (result.hasException) {
                                  // TODO
                                } else {
                                  final _query = UsersTodoTasks$Query.fromJson(
                                      cache.readQuery(_request));

                                  _query.todoTasksOfUser.removeWhere(
                                      (element) => element.id == task.id);

                                  cache.writeQuery(_request,
                                      data: _query.toJson());

                                  emitTaskDidChange();
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                          builder:
                              (RunMutation runMutation, QueryResult result) =>
                                  RaisedButton(
                            onPressed: () {
                              runMutation(
                                  TaskSetDoneTaskArguments(
                                          updateInput: TaskInputUpdate(
                                              id: task.id,
                                              state: TaskState.done))
                                      .toJson(),
                                  optimisticResult:
                                      TaskSetDoneTask$Mutation().toJson());
                            },
                            color: Colors.green,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [Icon(Icons.check), Text(' OK')],
                            ),
                          ),
                        ),

                        Text(''), // spa
                      ] // cer
                    ]
                  ]),
              trailing: task.state != TaskState.toDo
                  ? Icon(_icon.item1, color: _icon.item2)
                  : null,
            );
          }))
    ];
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    UsersTodoTasksQuery query = UsersTodoTasksQuery(
        variables: UsersTodoTasksArguments(email: auth.currentUser.email));
    final _queryOptions = QueryOptions(
        documentNode: query.document,
        // this is the query string you just created
        variables: query.getVariablesMap());
    _request = _queryOptions.asRequest;
    return Query(
      options: _queryOptions,
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (_subscription == null) {
          _subscription = subscribeToTaskDidChange(refetch);
        }
        if (result.hasException) {
          return ErrorDialog(result.exception.toString());
        }

        if (result.loading) {
          return Center(child: CircularProgressIndicator());
        }

        UsersTodoTasks$Query queryData = query.parse(result.data);

        // TODO this should be done in the backend
        final dueDaysMap = splitByDueDays(queryData.todoTasksOfUser);

        ThemeData themeData = Theme.of(context);
        if (queryData.todoTasksOfUser.length < 1) {
          return Center(
            child: const Text('Keine aufgaben zu machen 😎'),
          );
        } else {
          return ListView(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            children: [
              ...getListTilesFor(
                  dueDaysMap['overdue'], 'Überfällig', true, themeData),
              ...getListTilesFor(
                  dueDaysMap['today'], 'Heute', false, themeData),
              ...getListTilesFor(
                  dueDaysMap['next7Days'], 'Nächsten 7 Tage', false, themeData),
              ...getListTilesFor(
                  dueDaysMap['later'], 'Später', false, themeData),
            ],
          );
        }
      },
    );
  }
}
