import 'package:creditask/enums/editable_task_properties.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/widgets/_shared/fixed_credits_input.dart';
import 'package:creditask/widgets/_shared/loadnig_button_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../graphql/api.dart';

class FixedCreditsTile extends StatefulWidget {
  final TaskDetail$Query$Task _task;
  final bool _isLoading;
  final void Function(TaskInputUpdate taskInputUpdate) _onSave;

  FixedCreditsTile(this._task, this._isLoading, this._onSave);

  @override
  _FixedCreditsTileState createState() => _FixedCreditsTileState();
}

class _FixedCreditsTileState extends State<FixedCreditsTile> {
  bool _isEdit = false;
  String _value;
  FocusNode _focusNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _FixedCreditsTileState();

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          ListTile(
            leading: Icon(Icons.trending_up), // TODO get icon
            title: _isEdit ? null : Text('Credits'),
            subtitle: _isEdit
                ? FixedCreditsInput(
                    focusNode: _focusNode,
                    initialValue: widget._task.fixedCredits.toString(),
                    onSaved: (value) => _value = value,
                  )
                : Text(widget._task.fixedCredits.toString()),

            trailing: _isEdit ||
                    !canEditTaskProperty(
                        EditableTaskProperties.fixedCredits, widget._task.state)
                ? null
                : IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => setState(() {
                      _isEdit = true;
                      _focusNode.requestFocus();
                    }),
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
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            widget._onSave(TaskInputUpdate(
                                id: widget._task.id,
                                fixedCredits: double.parse(_value)));
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
