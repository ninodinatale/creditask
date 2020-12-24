import 'package:creditask/graphql/api.graphql.dart';
import 'package:creditask/services/tasks.dart';
import 'package:creditask/widgets/_shared/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApprovalsList extends StatelessWidget {
  final TaskDetail$Query$Task _task;

  const ApprovalsList(this._task);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _task.approvals
                  .map((a) {
                final _apprStateData = approvalStateData(a.state, context);
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Icon(
                        _apprStateData.item1,
                        color: _apprStateData.item2?.withOpacity(0.6),
                        size: 15,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(a.user.publicName),
                          if (a.message?.isNotEmpty)
                            Expanded(
                                child: Text(
                                  ': ${a.message}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w200),
                                )),
                        ],
                      ),
                    ),
                  ],
                );
              })
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
                icon: Icon(Icons.zoom_in),
                onPressed: () {
                  return showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    // false = user must tap button, true = tap outside dialog
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                        content: Container(
                          width: 20,
                          child: ListView.builder(
                            itemCount: _task.approvals.length,
                            itemBuilder: (context, i) {
                              final _apprStateData = approvalStateData(
                                  _task.approvals[i].state, context);
                              return ListTile(
                                  leading: Icon(
                                      _apprStateData.item1,
                                      color: _apprStateData.item2),
                                  title: Text(_task.approvals[i]
                                      .user
                                      .publicName),
                                  subtitle: Text(_task.approvals[i].message));
                            },
                          ),
                        ),
                      );
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
