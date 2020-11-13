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
            documentNode: query.document, variables: query.getVariablesMap()),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return ErrorDialog(result.exception.toString());
          }

          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }

          Users$Query queryData = query.parse(result.data);

          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: queryData.users.length+1,
              itemBuilder: (context, index) {
                String title;
                String value;
                if (index == 0) {
                  title = 'Keine Zuweisung';
                  value = null;
                } else {
                  // index 0 is for null assignment, so we need to index-1 to
                  // still get the first user
                  title = queryData.users[index-1].publicName;
                  value = queryData.users[index-1].id;
                }
                  return ListTile(
                    title: Text(title),
                    leading: Radio<String>(
                        activeColor: themeData.accentColor,
                        value: value,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value;
                          });
                          onChanged(value);
                        }),
                  );
              });
        });
  }
}
