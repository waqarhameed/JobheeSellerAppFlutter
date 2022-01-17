import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jobheeseller/handler/firebase_notification_handler.dart';
import 'package:jobheeseller/routes.dart';
import 'package:jobheeseller/screens/home/home_screen.dart';
import 'package:jobheeseller/screens/splash/splash_screen.dart';
import 'package:jobheeseller/theme.dart';

import 'constants.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    enableLights: true,
    enableVibration: true,
    importance: Importance.high,
    playSound: true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId));

  // for background notification
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  // for foreground notification
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );
  String token = await FirebaseAppCheck.instance.getToken();
  print(token);
  FirebaseAppCheck.instance.onTokenChange.listen((token) {
    print(token);
  });
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  runApp(MyApp());
}

bool isLoading = true;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: InitializerWidget());
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'JobHee Seller',
            theme: theme(),
            home: InitializerWidget(),
            // We use routeName so that we don`t need to remember the name
            //initialRoute: SplashScreen.routeName,
            routes: routes,
          );
        }
      },
    );
  }
}

class InitializerWidget extends StatefulWidget {
  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  FirebaseAuth _auth;
  User _user;

 // FirebaseNotifications firebaseNotifications = FirebaseNotifications();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   firebaseNotifications.setupFirebase(context);
    // });
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    print('User Current User is ==' + _user.toString());
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _user == null
            ? SplashScreen()
            : HomeScreen();
  }
}

class Init {
  Init._();

  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(const Duration(seconds: 3));
  }
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handle Background Service : $message');
  dynamic data = message.data['data'];

  FirebaseNotifications.showNotification(data['title'], data['body']);
}
