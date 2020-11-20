import 'package:creditask/widgets/shopping_list/shopping_list_container.dart';
import 'package:creditask/widgets/tasks/tasks_container.dart';
import 'package:flutter/material.dart';

class AppContainer extends StatefulWidget {
  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int _currentIndex = 0;

  void onTap(BuildContext context, int tappedIndex) {
    setState(() {
      _currentIndex = tappedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [TasksContainer(), ShoppingListContainer()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: theme.primaryColor,
          selectedItemColor: theme.colorScheme.surface,
          unselectedItemColor: Color.fromRGBO(
              theme.colorScheme.surface.red,
              theme.colorScheme.surface.green,
              theme.colorScheme.surface.blue,
              0.6),
          items: const <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Aufgaben'),
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.business),
              title: Text('Einkaufsliste'),
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) => onTap(context, index),
        ),
      ),
    );
  }
}
