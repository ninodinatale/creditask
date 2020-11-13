import 'dart:async';

import 'package:creditask/providers/auth.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/widgets/tasks/to_approve/task_to_approve.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../../graphql/api.dart';
import '../../_shared/error_screen.dart';

class TasksToApproveScreen extends StatefulWidget {
  @override
  _TasksToApproveScreenState createState() => _TasksToApproveScreenState();
}

class _TasksToApproveScreenState extends State<TasksToApproveScreen> {
  StreamSubscription<void> _subscription;

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    ToApproveTasksOfUserQuery query = ToApproveTasksOfUserQuery(
        variables:
            ToApproveTasksOfUserArguments(email: auth.currentUser.email));
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

          ToApproveTasksOfUser$Query queryData = query.parse(result.data);
          var tasks = queryData.toApproveTasksOfUser;

          if (tasks.length < 1) {
            return Center(
              child: const Text('Keine Aufgaben noch zu bestätigen'),
            );
          } else {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              children: ListTile.divideTiles(
                  context: context,
                  tiles: tasks.map((task) => TaskToApprove(task))).toList(),
            );
          }
        });
  }
}
