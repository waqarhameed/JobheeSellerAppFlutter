import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobheeseller/components/no_internet.dart';
import 'package:jobheeseller/components/simple_snake_bar.dart';
import 'package:jobheeseller/handler/firebase_notification_handler.dart';
import 'package:jobheeseller/routes.dart';
import 'package:jobheeseller/screens/splash/splash_screen.dart';
import 'package:jobheeseller/size_config.dart';
import 'package:jobheeseller/theme.dart';

import 'constants.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handle Background Service : ${message.notification.body}');
  dynamic data = message.data['data'];
  FirebaseNotifications.showNotification(data);
}

AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'your channel description',
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


  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // for foreground notification
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseAppCheck.instance.activate();
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
      future: Init.instance.initialize(context),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Center(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Image(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/images/jobhee.png'),
                ),
              ),
            ),
          );
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
 // static String routeName = "/";

  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  FirebaseNotifications firebaseNotifications = FirebaseNotifications();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseNotifications.setupFirebase(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

class Init {
  Init._();

  static final instance = Init._();

  Future initialize(BuildContext context) async {
    SizeConfig().init(context);
    var check = await InternetConnectionChecker().hasConnection;
    if (check == false) {
      MySnakeBar.createSnackBar(Colors.red, 'No Internet Connections', context);
      await Future.delayed(const Duration(seconds: 5));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (c) => NoInternet()));
    }
  }
}
