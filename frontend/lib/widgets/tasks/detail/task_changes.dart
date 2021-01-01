import 'package:creditask/utils/date_format.dart';
import 'package:creditask/utils/transformers.dart';
import 'package:creditask/widgets/_shared/error_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphql/api.dart';

class TaskChanges extends StatefulWidget {
  final String taskId;

  TaskChanges(this.taskId);

  @override
  _TaskChangesState createState() => _TaskChangesState(this.taskId);
}

class _TaskChangesState extends State<TaskChanges> {
  final String taskId;

  _TaskChangesState(this.taskId);

  String getChangeSubtitle(TaskChanges$Query$Task$TaskChanges taskChange) {
    var changedProp = 'Änderte {0} von {1} zu {2}';

    switch (taskChange.changedProperty) {
      case TaskChangeChangedProperty.name:
        return changedProp
            .replaceAll('{0}', 'den Namen')
            .replaceAll('{1}', "\"${taskChange.previousValue}\"")
            .replaceAll('{2}', "\"${taskChange.currentValue}\"");
      case TaskChangeChangedProperty.neededTimeSeconds:
        return changedProp
            .replaceAll('{0}', 'die benötigte Zeit')
            .replaceAll('{1}',
                "\"${secondsToElapsedTimeString(int.parse(taskChange.previousValue))}\"")
            .replaceAll('{2}',
                "\"${secondsToElapsedTimeString(int.parse(taskChange.currentValue))}\"");
      case TaskChangeChangedProperty.state:
        return changedProp
            .replaceAll('{0}', 'den Status')
            .replaceAll('{1}',
                "\"${transformTaskStateString(taskChange.previousValue)}\"")
            .replaceAll('{2}',
                "\"${transformTaskStateString(taskChange.currentValue)}\"");
      case TaskChangeChangedProperty.factor:
        return changedProp
            .replaceAll('{0}', 'den Faktor')
            .replaceAll('{1}', "\"${taskChange.previousValue}\"")
            .replaceAll('{2}', "\"${taskChange.currentValue}\"");
      case TaskChangeChangedProperty.userId:
        return changedProp
            .replaceAll('{0}', 'die Zuweisung')
            .replaceAll(
                '{1}', "\"${taskChange.previousValue ?? 'keine Zuweisung'}\"")
            .replaceAll(
                '{2}', "\"${taskChange.currentValue ?? 'keine Zuweisung'}\"");
      case TaskChangeChangedProperty.periodStart:
        return changedProp
            .replaceAll('{0}', 'das Startdatum')
            .replaceAll('{1}',
                "\"${localDateStringOfIsoDateString(taskChange.previousValue)}\"")
            .replaceAll('{2}',
                "\"${localDateStringOfIsoDateString(taskChange.currentValue)}\"");
      case TaskChangeChangedProperty.periodEnd:
        return changedProp
            .replaceAll('{0}', 'das Enddatum')
            .replaceAll('{1}',
                "\"${localDateStringOfIsoDateString(taskChange.previousValue)}\"")
            .replaceAll('{2}',
                "\"${localDateStringOfIsoDateString(taskChange.currentValue)}\"");
      case TaskChangeChangedProperty.approval:
        return changedProp
            .replaceAll('{0}', 'den Bestätigungsstatus')
            .replaceAll('{1}',
                "\"${transformApprovalState(taskChange.previousValue)}\"")
            .replaceAll('{2}',
                "\"${transformApprovalState(taskChange.currentValue)}\"");
      case TaskChangeChangedProperty.creditsCalc:
        return changedProp
            .replaceAll('{0}', 'die Creditsberechnung')
            .replaceAll('{1}', "\"${taskChange.previousValue}\"")
            .replaceAll('{2}', "\"${taskChange.currentValue}\"");
      case TaskChangeChangedProperty.fixedCredits:
        return changedProp
            .replaceAll('{0}', 'die Credits')
            .replaceAll('{1}', "\"${taskChange.previousValue}\"")
            .replaceAll('{2}', "\"${taskChange.currentValue}\"");
      case TaskChangeChangedProperty.createdById:
        return 'Aufgabe erstellt';
        break;
      case TaskChangeChangedProperty.artemisUnknown:
        return 'Unbekannte Änderung...';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    TaskChangesQuery query =
        TaskChangesQuery(variables: TaskChangesArguments(id: taskId));
    return Query(
        options: QueryOptions(
          document: query.document,
          variables: query.getVariablesMap(),
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

          List<TaskChanges$Query$Task$TaskChanges> taskChanges =
              query.parse(result.data).task.taskChanges;

          if (taskChanges.length > 0) {
            return ListView(children: [
              ...ListTile.divideTiles(
                  context: context,
                  tiles: taskChanges.map((taskChange) => ListTile(
                        title: Text(taskChange.user.publicName),
                        subtitle: Text(getChangeSubtitle(taskChange)),
                        trailing: Text(localDateTimeStringOfIsoDateTimeString(
                            taskChange.timestamp)),
                      )))
            ]);
          } else {
            return Center(
                child: Text('Es wurden noch keine Änderungen gemacht'));
          }
        });
  }
}
