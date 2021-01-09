import 'dart:async';

import 'package:creditask/graphql/api.dart';
import 'package:creditask/providers/auth.dart';
import 'package:creditask/providers/graphql.dart';
import 'package:creditask/widgets/_shared/error_screen.dart';
import 'package:creditask/widgets/app_container.dart';
import 'package:creditask/widgets/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  if (Foundation.kReleaseMode) {
    FlutterError.onError = (FlutterErrorDetails details) {
      artemisClient
          .execute(ErrorMutation(
              variables: ErrorArguments(stackTrace: details.stack.toString())))
          .then((value) => null);
      // Send report
    };
    runZonedGuarded<Future<void>>(
      () async {
        runApp(MyApp());
      },
      (Object error, StackTrace stackTrace) {
        artemisClient
            .execute(ErrorMutation(
                variables: ErrorArguments(stackTrace: stackTrace.toString())))
            .then((value) => null);
      },
    );
  } else {
    // Will be tree-shaked on release builds.
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  static Future<void> onMessageHandler(RemoteMessage message) async {
    print('onMessage: ' + message.sentTime.toString());
  }

  static Future<void> onMessageOpenedAppHandler(RemoteMessage message) async {
    print('onMessageOpenedApp: ' + message.sentTime.toString());
  }

  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    print('onBackgroundMessage: ' + message.sentTime.toString());
  }

  void _setupFirebaseMessaging() {
    FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen(MyApp.onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp
        .listen(MyApp.onMessageOpenedAppHandler);
    FirebaseMessaging.onBackgroundMessage(MyApp.onBackgroundMessageHandler);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            return ErrorDialog(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            _setupFirebaseMessaging();

            final base = ThemeData.light();
            return ChangeNotifierProvider(
                create: (context) => AuthProvider(),
                child: GraphqlProvider(
                    child: MaterialApp(
                        title: 'Creditask',
                        theme: base.copyWith(
                          buttonTheme: base.buttonTheme.copyWith(
                            buttonColor: base.primaryColor,
                            textTheme: ButtonTextTheme.primary,
                          ),
                        ),

                        // adjusting status bar (iOS & Android) and navigation bar
                        // (Android) colors
                        home: AnnotatedRegion<SystemUiOverlayStyle>(
                            value: SystemUiOverlayStyle(
                              statusBarColor: base.primaryColor,
                              systemNavigationBarColor: base.primaryColor,
                            ),
                            child: AuthContainer()))));
          }
          return Center(
            child: Image(
              image: AssetImage('assets/logo_rounded_512.png'),
              width: 150,
            ),
          );
        });
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
            return Center(
              child: Image(
                image: AssetImage('assets/logo_rounded_512.png'),
                width: 150,
              ),
            );
          } else if (snapshot.hasError) {
            return ErrorDialog(snapshot.error.toString());
          } else {
            // TODO cover use cases
            return Center(
              child: Image(
                image: AssetImage('assets/logo_rounded_512.png'),
                width: 150,
              ),
            );
          }
        });
  }
}
