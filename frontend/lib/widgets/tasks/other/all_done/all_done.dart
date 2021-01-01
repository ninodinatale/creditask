import 'dart:async';

import 'package:creditask/graphql/api.graphql.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/utils/date_format.dart';
import 'package:creditask/widgets/_shared/error_screen.dart';
import 'package:creditask/widgets/_shared/user_avatar.dart';
import 'package:creditask/widgets/tasks/detail/task_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AllDone extends StatefulWidget {
  @override
  _AllDoneState createState() => _AllDoneState();
}

class _AllDoneState extends State<AllDone> {
  @override
  Widget build(BuildContext context) {
    DoneTasksQuery query = DoneTasksQuery();
    return Query(
      options: QueryOptions(
        documentNode: query.document,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.hasException) {
          return ErrorDialog(result.exception.toString());
        }

        if (result.loading) {
          return Center(child: CircularProgressIndicator());
        }

        DoneTasks$Query queryData = query.parse(result.data);

        if (queryData.done.length < 1) {
          return Center(
            child: const Text('Keine gemachten Aufgaben'),
          );
        } else {
          return ListView(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shrinkWrap: true,
            children: ListTile.divideTiles(
                context: context,
                tiles: queryData.done.map((task) {
                  final _icon = taskStateData(task.state);
                  return ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(task.id))),
                    leading: UserAvatar(task.user?.publicName),
                    title: Text(task.name),
                    subtitle: Text(
                        'Fällig am ${localDateStringOfIsoDateString(task.periodEnd)} (${relativeDateStringOf(task.periodEnd)})'),
                    trailing: task.state == TaskState.toApprove
                        ? Icon(_icon.item1, color: _icon.item2)
                        : null,
                  );
                })).toList(),
          );
        }
      },
    );
  }
}
