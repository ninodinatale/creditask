import 'package:creditask/graphql/api.graphql.dart';
import 'package:creditask/providers/graphql.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  ErrorDialog(String error) {
    artemisClient
        .execute(ErrorMutation(variables: ErrorArguments(stackTrace: error)))
        .then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('Fehler'),
          content: const Text(
              'Es ist ein Fehler aufgetreten. Versuch es später erneut oder schliesse und öffne Creditask neu.'),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Schliessen')),
          ],
        );
      },
    );
  }
}
