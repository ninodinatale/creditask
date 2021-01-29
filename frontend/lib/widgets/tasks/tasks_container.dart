import 'dart:async';
import 'dart:convert';

import 'package:creditask/graphql/api.dart';
import 'package:creditask/main.dart';
import 'package:creditask/providers/auth.dart';
import 'package:creditask/utils/transformers.dart';
import 'package:creditask/widgets/_shared/creditask_drawer.dart';
import 'package:creditask/widgets/tasks/credits/credits_screen.dart';
import 'package:creditask/widgets/tasks/to_approve/tasks_to_approve_screen.dart';
import 'package:creditask/widgets/tasks/to_do/tasks_to_do_screen.dart';
import 'package:creditask/widgets/tasks/unassigned/unassigned_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add/add_task_screen.dart';
import 'other/all_tasks_screen.dart';

class TasksContainer extends StatefulWidget {
  @override
  _TasksContainerState createState() => _TasksContainerState();
}

class _TasksContainerState extends State<TasksContainer> {
  int _newToDoTasks = 0;
  int _newToApproveTasks = 0;
  int _newNotAssignedTasks = 0;
  int _newOtherTasks = 0;

  StreamSubscription _sub;

  AuthProvider _authProvider;

  Function(State owner) _onTaskChangesSeen(Function fn) {
    return (State owner) {
      // post frame because changing state of other widget in dispose()
      // or initState() is not allowed, which we do to clear notification
      // badges.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // this if is only because of hot reload issues in development
        // environments.
        if (mounted) {
          setState(fn);
        }
      });
    };
  }

  void onTaskChanges(Map<String, dynamic> data) {
    if (data['current_user_id'] != _authProvider.currentUser.id) {
      Map<String, dynamic> taskMap = json.decode(data['payload']);
      if (taskMap.containsKey('user') && taskMap['user'] != null) {
        if (taskMap['user']['id'] == _authProvider.currentUser.id) {
          if (taskMap['state'] !=
              transformTaskStateString(TaskState.done.toString())) {
            setState(() {
              _newToDoTasks++;
            });
          } else {
            setState(() {
              _newOtherTasks++;
            });
          }
        } else {
          if (taskMap['state'] == TaskState.toApprove) {
            setState(() {
              _newToApproveTasks++;
            });
          } else {
            setState(() {
              _newOtherTasks++;
            });
          }
        }
      } else {
        setState(() {
          _newNotAssignedTasks++;
        });
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    if (_sub == null) {
      _sub = CreditaskMessaging.of(context)
          .taskNotificationStream
          .listen(onTaskChanges);
    }

    final theme = Theme.of(context);
    TextStyle textStyle = const TextStyle(fontSize: 12);
    TextStyle chipTextStyle = TextStyle(
        color: theme.colorScheme.primary,
        fontSize: 18,
        fontWeight: FontWeight.bold);
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Zu machen', style: textStyle),
                      if (_newToDoTasks > 0) Text(' ', style: textStyle),
                      if (_newToDoTasks > 0)
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(0.6),
                          child: Chip(
                            label: Text(_newToDoTasks.toString(),
                                style: chipTextStyle),
                            backgroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Zu bestätigen', style: textStyle),
                      if (_newToApproveTasks > 0) Text(' ', style: textStyle),
                      if (_newToApproveTasks > 0)
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(0.6),
                          child: Chip(
                            label: Text(_newToApproveTasks.toString(),
                                style: chipTextStyle),
                            backgroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Nicht zugewiesen', style: textStyle),
                      if (_newNotAssignedTasks > 0) Text(' ', style: textStyle),
                      if (_newNotAssignedTasks > 0)
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(0.6),
                          child: Chip(
                            label: Text(_newNotAssignedTasks.toString(),
                                style: chipTextStyle),
                            backgroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Andere', style: textStyle),
                      if (_newOtherTasks > 0) Text(' ', style: textStyle),
                      if (_newOtherTasks > 0)
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(0.6),
                          child: Chip(
                            label: Text(_newOtherTasks.toString(),
                                style: chipTextStyle),
                            backgroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                    ],
                  ),
                ),
                Tab(
                  child: Text('Credits', style: textStyle),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TasksToDoScreen(
                onTaskChangesSeen: _onTaskChangesSeen(() {
                  _newToDoTasks = 0;
                }),
              ),
              TasksToApproveScreen(
                onTaskChangesSeen: _onTaskChangesSeen(() {
                  _newToApproveTasks = 0;
                }),
              ),
              UnassignedTasksScreen(
                onTaskChangesSeen: _onTaskChangesSeen(() {
                  _newNotAssignedTasks = 0;
                }),
              ),
              OtherTasksScreen(
                onTaskChangesSeen: _onTaskChangesSeen(() {
                  _newOtherTasks = 0;
                }),
              ),
              CreditsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
