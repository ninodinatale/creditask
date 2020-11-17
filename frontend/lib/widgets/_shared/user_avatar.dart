import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserAvatar extends StatelessWidget {

  final String _publicName;

  UserAvatar([this._publicName]);

  @override
  Widget build(BuildContext context) {
    String textValue = _publicName ?? '???';

    final codeUnits = textValue.substring(0, 3).codeUnits;

    return CircleAvatar(
      child: Text(textValue.substring(0, 2).toUpperCase()),
      backgroundColor: Color.fromRGBO(
          codeUnits[0],
          codeUnits[1],
          codeUnits[2],
          1),
    );
  }
}
