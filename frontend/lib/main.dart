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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
        runApp(FirebaseMessagingInitializationWrapper());
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
    runApp(FirebaseMessagingInitializationWrapper());
  }
}

class FirebaseMessagingInitializationWrapper extends StatefulWidget {
  _FirebaseMessagingInitializationWrapperState createState() =>
      _FirebaseMessagingInitializationWrapperState();
}

class _FirebaseMessagingInitializationWrapperState
    extends State<FirebaseMessagingInitializationWrapper> {
  bool _initialized = false;
  bool _error = false;

  Future<void> initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return ErrorDialog('FlutterFire failed to initialize');
    }

    if (!_initialized) {
      return Center(
        child: Image(
          image: AssetImage('assets/logo_rounded_512.png'),
          width: 150,
        ),
      );
    }

    return MessagingSetupWrapper();
  }
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print('FCM: onBackgroundMessage');
}

class MessagingSetupWrapper extends StatelessWidget {
  final StreamController<Map<String, dynamic>> _taskNotificationController =
      StreamController<Map<String, dynamic>>.broadcast(sync: true);

  Stream<Map<String, dynamic>> get taskNotificationStream =>
      _taskNotificationController.stream;

  Future<void> init() async {
    await requestPermission();
    await initializeMessageHandlers();
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> initializeMessageHandlers() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        // CAUTION: exclude .png
        AndroidInitializationSettings('ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) async =>
                print('TODO onDidReceiveLocalNotification'));
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async =>
          print('TODO onSelectNotification'),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    print("FCM: initialMessage: ${initialMessage?.sentTime}");
    if (initialMessage != null) {
      _taskNotificationController.add(initialMessage.data);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("FCM: onMessageOpenedApp");
      _taskNotificationController.add(message.data);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FCM: onMessage");
      _taskNotificationController.add(message.data);
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.

      // TODO move auth provider up to have access to currentUser
      if (notification != null && android != null /*&& message.data['current_user_id'] != _authProvider.currentUser.id*/) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO this might be 'assets/logo_rounded_512.png' or
                //  'ic_launcher'
                // icon: '@mipmap/Xic_launcher' // android?.smallIcon,
                // other properties...
              ),
            ));
      }
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CreditaskMessaging(
            child: Creditask(),
            taskNotificationStream: taskNotificationStream,
          );
        } else {
          return Center(
            child: Image(
              image: AssetImage('assets/logo_rounded_512.png'),
              width: 150,
            ),
          );
        }
      },
    );
  }
}

class CreditaskMessaging extends InheritedWidget {
  final Stream<Map<String, dynamic>> taskNotificationStream;

  CreditaskMessaging(
      {@required Widget child,
      @required Stream<Map<String, dynamic>> taskNotificationStream})
      : this.taskNotificationStream = taskNotificationStream,
        super(child: child);

  static CreditaskMessaging of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CreditaskMessaging>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class Creditask extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
                    child: AuthWrapper()))));
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return FutureBuilder<bool>(
        future: auth.isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return snapshot.data
                ? AppContainer(currentUser: auth.currentUser)
                : LoginScreen();
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
