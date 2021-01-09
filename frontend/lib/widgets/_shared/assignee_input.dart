import 'package:creditask/graphql/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'error_screen.dart';

class TaskAssigneeInput extends StatefulWidget {
  @required
  final void Function(String) onChanged;
  final String initialValue;

  TaskAssigneeInput({this.onChanged, this.initialValue});

  @override
  _TaskAssigneeInputState createState() =>
      _TaskAssigneeInputState(initialValue, onChanged);
}

class _TaskAssigneeInputState extends State<TaskAssigneeInput> {
  String _selectedValue;
  final void Function(String) onChanged;

  _TaskAssigneeInputState(this._selectedValue, this.onChanged);

  @override
  Widget build(BuildContext context) {
    UsersQuery query = UsersQuery();
    ThemeData themeData = Theme.of(context);
    return Query(
        options: QueryOptions(
          documentNode: query.document,
          variables: query.getVariablesMap(),
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return ErrorDialog(result.exception.toString());
          }

          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }

          Users$Query queryData = query.parse(result.data);

          return DropdownButtonFormField(
            decoration: InputDecoration(labelText: 'Zuweisung'),
            value: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
              onChanged(int.parse(value) < 0 ? null : value);
            },
            items: [
              DropdownMenuItem(
                child: Text('Keine Zuweisung'),
                // we cannot set value to null since the input thinks there
                // is no input in the field, fucking up the decorations
                value: '-1',
              ),
              ...queryData.users
                  .map((e) => DropdownMenuItem(
                        child: Text(e.publicName),
                        value: e.id,
                      ))
                  .toList()
            ],
          );
        });
  }
}
