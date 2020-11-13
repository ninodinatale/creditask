import 'dart:async';

import 'package:creditask/providers/auth.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/utils/date_format.dart';
import 'package:creditask/widgets/_shared/task_state_icon.dart';
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

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  List<Widget> getListTilesFor(List<SimpleTaskMixin> tasks,
      String title, bool overdue, ThemeData theme) {
    return [
      tasks.length > 0
          ? Padding(
              child: Text(title, style: theme.textTheme.caption),
              padding: EdgeInsets.only(top: 20))
          : SizedBox.shrink(),
      ...ListTile.divideTiles(
          context: context,
          tiles: tasks.map((task) => ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task.id))),
                leading: UserAvatar(task.user.publicName),
                title: Text(task.name),
                subtitle: Text(
                    'Fällig am ${localDateStringOfIsoDateString(task.periodEnd)} (${relativeDateStringOf(task.periodEnd)})',
                    style: TextStyle(
                        color: task.state == TaskState.toDo && overdue
                            ? theme.errorColor
                            : null)),
                trailing: task.state == TaskState.toApprove
                    ? TaskStateIcon(task.state)
                    : null,
              )))
    ];
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    UsersTodoTasksQuery query = UsersTodoTasksQuery(
        variables: UsersTodoTasksArguments(email: auth.currentUser.email));
    return Query(
      options: QueryOptions(
          documentNode: query.document,
          // this is the query string you just created
          variables: query.getVariablesMap()),
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
