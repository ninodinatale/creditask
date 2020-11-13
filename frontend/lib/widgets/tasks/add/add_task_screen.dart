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
  String name = '';
  String userId = '';
  CreditsCalc creditsCalc = CreditsCalc.fixed;
  String factor = '1';
  String fixedCredits = '0';
  DateTimeRange period;

  // Map of currentStep as key and formKey as value
  Map<int, MapEntry<GlobalKey<FormState>, FocusNode>> _stepInfo = {
    0: MapEntry(GlobalKey<FormState>(), FocusNode()), // Name
    1: MapEntry(GlobalKey<FormState>(), FocusNode()), // Assignment
    2: MapEntry(GlobalKey<FormState>(), FocusNode()), // CreditsCalc
    3: MapEntry(GlobalKey<FormState>(), FocusNode()), // Factor or FixedCredits
    4: MapEntry(GlobalKey<FormState>(), FocusNode()), // Dates
  };
  int _currentStep = 0;

  bool isLoading = false;

  @override
  void dispose() {
    _stepInfo.forEach((key, value) => value.value.dispose());
    super.dispose();
  }

  void focusCurrentInput() {
    _stepInfo[_currentStep].value.requestFocus();
  }

  void onStepContinue() {
    final currentStepFormKey = _stepInfo[_currentStep].key;
    if (currentStepFormKey.currentState.validate()) {
      currentStepFormKey.currentState.save();
      setState(() {
        _currentStep++;
        focusCurrentInput();
      });
    }
  }

  void onStepFinish(BuildContext context) async {
    final currentStepFormKey = _stepInfo[_currentStep].key;
    if (currentStepFormKey.currentState.validate()) {
      currentStepFormKey.currentState.save();

      this.setState(() {
        this.isLoading = true;
      });

      await artemisClient
          .execute(SaveTaskMutation(
              variables: SaveTaskArguments(
                  createInput: TaskInputCreate(
                    creditsCalc: creditsCalc,
                      fixedCredits: int.parse(fixedCredits).toDouble(),
                      factor: double.parse(factor),
                      name: name,
                      userId: userId,
                      periodStart: dateTimeToIsoDateString(period.start),
                      periodEnd: dateTimeToIsoDateString(period.end)))))
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

  void onStepBack() {
    final currentStepFormKey = _stepInfo[_currentStep].key;
    currentStepFormKey.currentState.save();
    setState(() {
      _currentStep--;
      focusCurrentInput();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Aufgabe hinzufügen'),
        ),
        body: Stepper(
          controlsBuilder: (context, {onStepCancel, onStepContinue}) {
            return ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                _currentStep == _stepInfo.length - 1
                    ? RaisedButton(
                        onPressed:
                            this.isLoading ? null : () => onStepFinish(context),
                        child: LoadingButtonContent(isLoading, 'Hinzufügen'))
                    : RaisedButton(
                        child: Text('Weiter'),
                        onPressed: onStepContinue,
                      ),
                _currentStep > 0
                    ? FlatButton(
                        child: Text('Zurück'),
                        onPressed: onStepBack,
                      )
                    : null
              ],
            );
          },
          currentStep: _currentStep,
          onStepContinue: onStepContinue,
          steps: [
            Step(
              title: Text('Name'),
              content: Form(
                key: _stepInfo[0].key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TaskNameInput(
                        onSaved: (value) => name = value,
                        autofocus: true,
                        focusNode: _stepInfo[0].value),
                  ],
                ),
              ),
            ),
            Step(
              title: Text('Zuweisung'),
              content: Form(
                key: _stepInfo[1].key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TaskAssigneeInput(onChanged: (value) => userId = value),
                  ],
                ),
              ),
            ),
            Step(
              title: Text('Credits'),
              content: Form(
                key: _stepInfo[2].key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CreditsCalcInput(
                        onChanged: (value) =>
                            setState(() => creditsCalc = value)),
                  ],
                ),
              ),
            ),
            creditsCalc == CreditsCalc.fixed
                ? Step(
                    title: Text('Pauschale Credits'),
                    content: Form(
                      key: _stepInfo[3].key,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FixedCreditsInput(
                              focusNode: _stepInfo[3].value,
                              onSaved: (value) => fixedCredits = value),
                        ],
                      ),
                    ),
                  )
                : Step(
                    title: Text('Faktor'),
                    content: Form(
                      key: _stepInfo[3].key,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FactorInput(
                              focusNode: _stepInfo[3].value,
                              onSaved: (value) => factor = value),
                        ],
                      ),
                    ),
                  ),
            Step(
              title: Text('Termine'),
              content: Form(
                key: _stepInfo[4].key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    PeriodInput(
                      onSaved: (value) => period = value,
                      focusNode: _stepInfo[4].value,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
