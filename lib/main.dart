import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobheeseller/handler/firebase_notification_handler.dart';
import 'package:jobheeseller/routes.dart';
import 'package:jobheeseller/screens/home/home_screen.dart';
import 'package:jobheeseller/screens/splash/splash_screen.dart';
import 'package:jobheeseller/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyATqxhwVJGlltWIGxXWECV4BxbLrAABCWE',
          appId: '1:900802440016:android:efb5412b0a26b620a5da55',
          messagingSenderId: '900802440016',
          projectId: 'job-hee'));
  // FirebaseAppCheck appCheck = FirebaseAppCheck.instance;
  // print('AppCheck = ' + appCheck.toString());
  // FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  // await FirebaseAppCheck.instance.activate(
  //   webRecaptchaSiteKey: 'recaptcha-v3-site-keys',
  // );

  // String token = await FirebaseAppCheck.instance.getToken();
  // print('FirebaseAppCheck token =>' + token);
  // String token2 = await FirebaseAppCheck.instance.getToken(true);
  // print('FirebaseAppCheck token2 =>' + token2);
  // FirebaseAppCheck.instance.onTokenChange.listen((token) {
  //   print('FirebaseAppCheck change token =>' + token);
  // });
  // await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  runApp(MyApp());
}

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
          // Loading is done, return the app:

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

  bool isLoading = true;
  FirebaseNotifications firebaseNotifications = FirebaseNotifications();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseNotifications.setupFirebase(context);
    });
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    print('User Current User is ==' + _user.toString());
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return isLoading
        ? Scaffold(
            backgroundColor:
                lightMode ? const Color(0xffe1f5fe) : const Color(0xff042a49),
            body: Center(
              child: lightMode
                  ? Image.asset('assets/images/splash_1.png')
                  : Image.asset('assets/images/splash_3.png'),
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
