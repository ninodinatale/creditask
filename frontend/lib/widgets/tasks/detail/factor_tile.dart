import 'package:creditask/enums/editable_task_properties.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/widgets/_shared/factor_input.dart';
import 'package:creditask/widgets/_shared/loadnig_button_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../graphql/api.dart';

class FactorTile extends StatefulWidget {
  final TaskDetail$Query$Task _task;
  final bool _isLoading;
  final void Function(TaskInputUpdate taskInputUpdate) _onSave;

  FactorTile(this._task, this._isLoading, this._onSave);

  @override
  _FactorTileState createState() => _FactorTileState();
}

class _FactorTileState extends State<FactorTile> {
  bool _isEdit = false;
  String _value;
  FocusNode _focusNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _FactorTileState();

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
            title: _isEdit ? null : Text('Faktor'),
            subtitle: _isEdit
                ? FactorInput(
                    focusNode: _focusNode,
                    initialValue: widget._task.factor.toString(),
                    onSaved: (value) => _value = value,
                  )
                : Text(widget._task.factor.toString()),

            trailing: _isEdit ||
                    !canEditTaskProperty(
                        EditableTaskProperties.factor, widget._task.state)
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
                                factor: double.parse(_value)));
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
