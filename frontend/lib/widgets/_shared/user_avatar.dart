import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserAvatar extends StatelessWidget {

  final String _publicName;

  UserAvatar([this._publicName]);

  @override
  Widget build(BuildContext context) {
    String textValue = _publicName ?? '???';
    final hex = int.parse('0xff${textValue.hashCode}');

    return CircleAvatar(
      child: Text(textValue.substring(0, 2).toUpperCase()),
      backgroundColor: Color(hex),
    );
  }
}
