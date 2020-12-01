import 'package:creditask/widgets/tasks/detail/task_changes.dart';
import 'package:creditask/widgets/tasks/detail/task_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphql/api.dart';
import '../../_shared/error_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  TaskDetailScreen(this.taskId);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState(this.taskId);
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final String taskId;
  TaskDetailQuery query;

  _TaskDetailScreenState(this.taskId);

  @override
  void initState() {
    super.initState();
    query = TaskDetailQuery(variables: TaskDetailArguments(id: taskId));
  }

  void refreshView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var _queryOptions = QueryOptions(
        document: query.document, variables: query.getVariablesMap());
    return Query(
      options: _queryOptions,
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.hasException) {
          return ErrorDialog(result.exception.toString());
        }

        if (result.loading) {
          return Center(child: CircularProgressIndicator());
        }

        TaskDetail$Query queryData = query.parse(result.data);
        TextStyle textStyle = TextStyle(fontSize: 10);

        return DefaultTabController(
            length: 2,
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(queryData.task.name),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                          child: Text('Details', style: textStyle),
                          icon: Icon(Icons.details)),
                      Tab(
                          child: Text('Änderungen', style: textStyle),
                          icon: Icon(Icons.history)),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    TaskDetail(queryData.task, _queryOptions.asRequest),
                    TaskChanges(taskId),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
