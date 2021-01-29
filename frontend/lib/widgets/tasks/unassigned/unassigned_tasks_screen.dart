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

class UnassignedTasksScreen extends StatefulWidget {
  final Function(State owner) onTaskChangesSeen;

  const UnassignedTasksScreen({Key key, @required this.onTaskChangesSeen}) : super(key: key);
  @override
  _UnassignedTasksScreenState createState() => _UnassignedTasksScreenState(onTaskChangesSeen);
}

class _UnassignedTasksScreenState extends State<UnassignedTasksScreen> {

  final Function(State owner) onTaskChangesSeen;

  _UnassignedTasksScreenState(this.onTaskChangesSeen);

  @override
  void dispose() {
    onTaskChangesSeen(this);
    super.dispose();
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
          tiles: tasks.map((task) {
            final _icon = taskStateData(task.state);
            return ListTile(
                onTap: () =>
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(task.id))),
                leading: UserAvatar(),
                title: Text(task.name),
                subtitle: Text(
                    'Fällig am ${localDateStringOfIsoDateString(
                        task.periodEnd)} (${relativeDateStringOf(
                        task.periodEnd)})',
                    style: TextStyle(
                        color: task.state == TaskState.toDo && overdue
                            ? theme.errorColor
                            : null)),
                trailing: task.state == TaskState.toApprove
                    ? Icon(_icon.item1, color: _icon.item2)
                    : null,
              );
          }))
    ];
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    UnassignedTasksQuery query = UnassignedTasksQuery();
    return Query(
      options: QueryOptions(
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          documentNode: query.document),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.hasException) {
          return ErrorDialog(result.exception.toString());
        }

        if (result.loading) {
          return Center(child: CircularProgressIndicator());
        }

        UnassignedTasks$Query queryData = query.parse(result.data);

        // TODO this should be done in the backend
        final dueDaysMap = splitByDueDays(queryData.unassignedTasks);

        ThemeData themeData = Theme.of(context);
        if (queryData.unassignedTasks.length < 1) {
          return Center(child: const Text('Keine offenen Aufgaben 😎'),);
        } else {
        return ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          children: [
            ...getListTilesFor(dueDaysMap['overdue'], 'Überfällig', true, themeData),
            ...getListTilesFor(dueDaysMap['today'], 'Heute', false, themeData),
            ...getListTilesFor(dueDaysMap['next7Days'], 'Nächsten 7 Tage', false, themeData),
            ...getListTilesFor(dueDaysMap['later'], 'Später', false, themeData),
          ],
        );
        }
      },
    );
  }
}
