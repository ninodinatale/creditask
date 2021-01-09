import 'package:creditask/graphql/api.graphql.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SetTaskDoneButton extends StatelessWidget {
  final OnMutationUpdate _onUpdate;
  final String _taskId;

  SetTaskDoneButton(
      {@required String taskId, @required OnMutationUpdate onUpdate})
      : _onUpdate = onUpdate,
        _taskId = taskId;

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
          document: TaskSetDoneTaskMutation().document,
          update: _onUpdate,
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          onError: (OperationException error) {
            // TODO
          }),
      builder: (RunMutation runMutation, QueryResult result) => RaisedButton(
        onPressed: () {
          runMutation(
              TaskSetDoneTaskArguments(
                      updateInput:
                          TaskInputUpdate(id: _taskId, state: TaskState.done))
                  .toJson(),
              optimisticResult: TaskSetDoneTask$Mutation().toJson());
        },
        color: Colors.green,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(Icons.check), Text(' OK')],
        ),
      ),
    );
  }
}
