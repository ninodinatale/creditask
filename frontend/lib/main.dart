import 'package:creditask/providers/auth.dart';
import 'package:creditask/providers/graphql.dart';
import 'package:creditask/widgets/_shared/error_screen.dart';
import 'package:creditask/widgets/app_container.dart';
import 'package:creditask/widgets/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();
    return ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: GraphqlProvider(
            child: MaterialApp(
                title: 'Flutter Demo',
                theme: base.copyWith(
                  buttonTheme: base.buttonTheme.copyWith(
                    buttonColor: base.primaryColor,
                    textTheme: ButtonTextTheme.primary,
                  ),
                ),
                home: AuthContainer())));
  }
}

class AuthContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return FutureBuilder<bool>(
        future: auth.isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return snapshot.data ? AppContainer() : LoginScreen();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return snapshot.hasData
                ? LoginScreen()
                : Center(
                    child: FlutterLogo(
                      size: 100,
                    ),
                  );
          } else if (snapshot.hasError) {
            return ErrorDialog(snapshot.error.toString());
          } else {
            // TODO cover use cases
            return Center(
              child: FlutterLogo(
                size: 100,
              ),
            );
          }
        });
  }
}
