import 'dart:async';

import 'package:creditask/providers/auth.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/widgets/_shared/user_avatar.dart';
import 'package:creditask/widgets/tasks/detail/task_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../../graphql/api.dart';
import '../../_shared/error_screen.dart';

class TasksDoneScreen extends StatefulWidget {
  @override
  _TasksDoneScreenState createState() => _TasksDoneScreenState();
}

class _TasksDoneScreenState extends State<TasksDoneScreen> {
  StreamSubscription<void> _subscription;

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  Widget getTrailing(UsersDoneToApproveTasks$Query$DoneTasksOfUser task) {
    if (task.approvals.firstWhere(
            (element) => element.state == ApprovalState.declined,
            orElse: () => null) !=
        null) {
      return IconButton(icon: Icon(Icons.add), onPressed: () => {});
    } else if (task.approvals.firstWhere(
            (element) => element.state == ApprovalState.none,
            orElse: () => null) !=
        null) {
      return SizedBox.shrink();
    } else {
      return IconButton(icon: Icon(Icons.one_k), onPressed: () => {});
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    UsersDoneToApproveTasksQuery query = UsersDoneToApproveTasksQuery(
        variables:
            UsersDoneToApproveTasksArguments(email: auth.currentUser.email));
    return Query(
        options: QueryOptions(
            documentNode: query.document, variables: query.getVariablesMap()),
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

          UsersDoneToApproveTasks$Query queryData = query.parse(result.data);
          var tasks = queryData.doneTasksOfUser;

          ThemeData themeData = Theme.of(context);

          if (tasks.length < 1) {
            return Center(
              child: const Text('Keine Aufgaben noch zu bestätigen'),
            );
          } else {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              children: ListTile.divideTiles(
                  context: context,
                  tiles: tasks.map((task) => ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TaskDetailScreen(task.id))),
                        leading: UserAvatar(task.user.publicName),
                        title: Text(task.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: task.approvals
                              .map((a) => Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Icon(
                                          approvalIconData(a.state),
                                          color:
                                              themeData.textTheme.caption.color,
                                          size: 15,
                                        ),
                                      ),
                                      Text(a.user.publicName),
                                    ],
                                  ))
                              .toList(),
                        ),
                        trailing: getTrailing(task),
                      ))).toList(),
            );
          }
        });
  }
}
