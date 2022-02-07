import 'package:flutter/cupertino.dart';
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

  static Future onSelectNotification(String payload) {
    if(payload != null)
      print('Get  payload: $payload ' );

  }

}
