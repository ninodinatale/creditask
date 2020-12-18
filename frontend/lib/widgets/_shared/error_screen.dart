import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  final String error;

  ErrorDialog(this.error);

  @override
  _ErrorDialogState createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  bool _showErrorText = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('Fehler'),
          content: Column(
            children: [
              const Text(
                  'Es ist ein Fehler aufgetreten. Versuch es später erneut oder schliesse und öffne Creditask neu.'),
              if (_showErrorText) Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(constraints: BoxConstraints(),height: 200, child: SingleChildScrollView(child: Text(widget.error))),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () =>
                    setState(() => _showErrorText = !_showErrorText),
                child: Text(
                    _showErrorText ? 'Fehler ausblenden' : 'Fehler anzeigen')),
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Schliessen')),
          ],
        );
      },
    );
  }
}
