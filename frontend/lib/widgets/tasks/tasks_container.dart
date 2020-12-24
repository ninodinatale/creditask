import 'package:creditask/widgets/_shared/creditask_drawer.dart';
import 'package:creditask/widgets/tasks/all/all_tasks_screen.dart';
import 'package:creditask/widgets/tasks/credits/credits_screen.dart';
import 'package:creditask/widgets/tasks/to_approve/tasks_to_approve_screen.dart';
import 'package:creditask/widgets/tasks/to_do/tasks_to_do_screen.dart';
import 'package:creditask/widgets/tasks/unassigned/unassigned_tasks_screen.dart';
import 'package:flutter/material.dart';

import 'add/add_task_screen.dart';

class TasksContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 12);
    return DefaultTabController(
      length: 5,
      child: SafeArea(
        child: Scaffold(
          drawer: const CreditaskDrawer(),
          appBar: AppBar(
            title: Text('Aufgaben'),
            actions: [
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddTaskScreen())))
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  child: Text('Zu machen', style: textStyle),
                ),
                Tab(
                  child: Text('Zu bestätigen', style: textStyle),
                ),
                Tab(
                  child: Text('Nicht zugewiesen', style: textStyle),
                ),
                Tab(
                  child: Text('Alle offenen', style: textStyle),
                ),
                Tab(
                  child: Text('Credits', style: textStyle),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TasksToDoScreen(),
              TasksToApproveScreen(),
              UnassignedTasksScreen(),
              AllTasksScreen(),
              CreditsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
