import 'package:creditask/widgets/tasks/tasks_container.dart';
import 'package:flutter/material.dart';

class AppContainer extends StatefulWidget {
  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  @override
  Widget build(BuildContext context) {
    return TasksContainer();
  }
}
