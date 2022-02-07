import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static final flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static BuildContext myContext;

  static void initNotification(BuildContext context) {
    myContext = context;
    var initAndroid = AndroidInitializationSettings("jobhee");

    var initSetting = InitializationSettings(android: initAndroid);
    flutterLocalNotificationPlugin.initialize(initSetting,
        onSelectNotification: onSelectNotification);
  }

  static Future onSelectNotification(String route) async {
    if (route != null) {
      print('Get  payload: $route ');
    }
    return Navigator.of(myContext).pushNamed(route);
  }
}
