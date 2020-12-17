import 'package:creditask/providers/auth.dart';
import 'package:creditask/widgets/_shared/creditask_version.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreditaskDrawer extends StatelessWidget {
  const CreditaskDrawer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Provider.of<AuthProvider>(context);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Creditask',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: theme.colorScheme.surface)),
                    Text(' ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: theme.colorScheme.surface)),
                    CreditaskVersion(
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            height: 3,
                            fontSize: 10,
                            color: theme.colorScheme.surface)),
                  ],
                ),
                Text(auth.currentUser.publicName,
                    style: TextStyle(color: theme.colorScheme.surface)),
              ],
            ),
            decoration: BoxDecoration(
              color: theme.primaryColor,
            ),
          ),
          ListTile(
            title: Text('Einstellungen'),
            leading: Icon(Icons.settings),
            onTap: () => {
              // TODO
            },
          ),
          Divider(),
          ListTile(
            title: Text('Ausloggen'),
            leading: Icon(Icons.logout),
            onTap: () async => await auth.logout(),
          ),
        ],
      ),
    );
  }
}
