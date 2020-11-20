import 'package:creditask/graphql/api.dart';
import 'package:creditask/providers/graphql.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/utils/date_format.dart';
import 'package:creditask/widgets/_shared/assignee_input.dart';
import 'package:creditask/widgets/_shared/credits_calc_input.dart';
import 'package:creditask/widgets/_shared/error_screen.dart';
import 'package:creditask/widgets/_shared/factor_input.dart';
import 'package:creditask/widgets/_shared/fixed_credits_input.dart';
import 'package:creditask/widgets/_shared/loadnig_button_content.dart';
import 'package:creditask/widgets/_shared/period_input.dart';
import 'package:creditask/widgets/_shared/task_name_input.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String _name = '';
  String _userId = '';
  CreditsCalc _creditsCalc = CreditsCalc.fixed;
  String _factor = '1';
  String _fixedCredits = '0';
  DateTimeRange _period;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void _onSave(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      this.setState(() {
        this.isLoading = true;
      });

      await artemisClient
          .execute(SaveTaskMutation(
              variables: SaveTaskArguments(
                  createInput: TaskInputCreate(
                      creditsCalc: _creditsCalc,
                      fixedCredits: int.parse(_fixedCredits).toDouble(),
                      factor: double.parse(_factor),
                      name: _name,
                      userId: _userId,
                      periodStart: dateTimeToIsoDateString(_period.start),
                      periodEnd: dateTimeToIsoDateString(_period.end)))))
          .catchError((error) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ErrorDialog(error.toString()))))
          .then((result) {
        if (result.hasErrors) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ErrorDialog(result.errors.toString())));
        } else {
          Navigator.pop(context);
          emitTaskDidChange();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Aufgabe hinzufügen'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TaskNameInput(onSaved: (value) => _name = value),
            TaskAssigneeInput(onChanged: (value) => _userId = value),
            CreditsCalcInput(
                onChanged: (value) => setState(() => _creditsCalc = value)),
            _creditsCalc == CreditsCalc.fixed
                ? FixedCreditsInput(onSaved: (value) => _fixedCredits = value)
                : FactorInput(onSaved: (value) => _factor = value),
            PeriodInput(
              onSaved: (value) => _period = value,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: RaisedButton(
                onPressed: this.isLoading
                    ? null
                    : () => _onSave(context),
                child: LoadingButtonContent(isLoading, 'HINZUFÜGEN'),
              )
            )
          ],
        ),
      ),
    ));
  }
}
