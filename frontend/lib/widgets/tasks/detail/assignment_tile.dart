import 'package:creditask/enums/editable_task_properties.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/widgets/_shared/assignee_input.dart';
import 'package:creditask/widgets/_shared/loadnig_button_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../graphql/api.dart';

class AssignmentTile extends StatefulWidget {
  final TaskDetail$Query$Task _task;
  final bool _isLoading;
  final void Function(TaskInputUpdate taskInputUpdate) _onSave;

  AssignmentTile(this._task, this._isLoading, this._onSave);

  @override
  _AssignmentTileState createState() => _AssignmentTileState();
}

class _AssignmentTileState extends State<AssignmentTile> {
  bool _isEdit = false;
  String _value;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _AssignmentTileState();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          ListTile(
            leading: Icon(Icons.assignment_ind), // TODO get icon
            title: _isEdit ? null : Text('Zuweisung'),
            subtitle: _isEdit
                ? TaskAssigneeInput(
                    onChanged: (value) => _value = value,
                    initialValue: widget._task.user?.id,
                  )
                : Text(widget._task.user?.publicName ?? 'Keine Zuweisung'),
            trailing: _isEdit ||
                    !canEditTaskProperty(
                        EditableTaskProperties.user, widget._task.state)
                ? null
                : IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => setState(() => _isEdit = true),
                  ),
          ),
          if (_isEdit)
            ButtonBar(
              children: [
                FlatButton(
                    onPressed: () {
                      setState(() {
                        _isEdit = false;
                      });
                    },
                    child: Text('Abbrechen')),
                RaisedButton(
                  onPressed: widget._isLoading
                      ? null
                      : () {
                          print(_formKey.currentState.validate());
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            // Form does not include radio, so check here
                            if (_isEdit) {
                              widget._onSave(TaskInputUpdate(
                                  // TODO change userId: _value ?? '' to just
                                  //  userId: _value if TODO in backend's
                                  //  SaveTask (graphql schema) is resolved
                                  id: widget._task.id,
                                  userId: _value ?? ''));
                            }
                            setState(() {
                              _isEdit = false;
                            });
                          }
                        },
                  child: LoadingButtonContent(widget._isLoading, 'Speichern'),
                )
              ],
            ),
        ]));
  }
}
