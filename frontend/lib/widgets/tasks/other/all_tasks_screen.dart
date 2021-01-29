import 'package:creditask/widgets/tasks/other/all_done/all_done.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'all_to_do/all_to_do.dart';

class OtherTasksScreen extends StatefulWidget {
  final Function(State owner) onTaskChangesSeen;

  const OtherTasksScreen({Key key, @required this.onTaskChangesSeen})
      : super(key: key);

  @override
  _OtherTasksScreenState createState() =>
      _OtherTasksScreenState(onTaskChangesSeen);
}

class _OtherTasksScreenState extends State<OtherTasksScreen> {
  final Function(State owner) onTaskChangesSeen;
  final List<String> _dropdownValues = ['Alle offenen', 'Alle gemachten'];
  int _currentIndex = 0;

  _OtherTasksScreenState(this.onTaskChangesSeen);

  @override
  void dispose() {
    onTaskChangesSeen(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
          child: DropdownButton(
              isExpanded: true,
              value: _dropdownValues[_currentIndex],
              onChanged: (value) => setState(() => _currentIndex =
                  _dropdownValues.indexWhere((e) => e == value)),
              items: _dropdownValues.map((e) {
                return DropdownMenuItem(child: Text(e), value: e);
              }).toList()),
        ),
        Expanded(
          child: IndexedStack(index: _currentIndex, children: [
            AllToDo(),
            AllDone(),
          ]),
        )
      ],
    );
  }
}
