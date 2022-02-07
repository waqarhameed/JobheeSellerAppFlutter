import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'notification_handler.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  //BuildContext _context;

  void setupFirebase(BuildContext context) {
    _firebaseMessaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessingListener(context);
   // _context = context;
  }

  void firebaseCloudMessingListener(BuildContext context) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('Settings ${settings.authorizationStatus}');

    // _firebaseMessaging
    //     .subscribeToTopic('subscribe to me')
    //     .whenComplete(() => print('subscribed ok'));

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        String routeFromMessage = message.data["route"];

        if (routeFromMessage.compareTo("currentOrder") != null) {
          Navigator.of(context).pushNamed(routeFromMessage);
        }
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      print('My Remote Message: $message');
      if (message.notification != null) {
        print(message.notification.body);
        print(message.notification.title);
      }
      if (Platform.isAndroid) {
        showNotification(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      String routeFromMessage = message.data["route"];
      if (routeFromMessage.compareTo("currentOrder") != null) {
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   print('onMessageOpenedApp : $event');
    //   showDialog(
    //       context: _context,
    //       builder: (context) => CupertinoAlertDialog(
    //             title: Text(event.notification.title),
    //             content: Text(event.notification.body),
    //             actions: [
    //               CupertinoDialogAction(
    //                 isDefaultAction: true,
    //                 child: Text('OL'),
    //                 onPressed: () {
    //                   Navigator.of(context, rootNavigator: true).pop();
    //                 },
    //               )
    //             ],
    //           ));
    // });
  }

  static void showNotification(RemoteMessage message) async {
    var androidChannel = AndroidNotificationDetails(
        'com.example.jobheeseller', 'My channel',
        autoCancel: false,
        ongoing: true,
        importance: Importance.max,
        priority: Priority.high);
    var platform = NotificationDetails(
      android: androidChannel,
    );
    await NotificationHandler.flutterLocalNotificationPlugin.show(
        Random().nextInt(1000),
        message.notification.title,
        message.notification.body,
        platform,
        payload: "route");
  }

  static Future<bool> sendFcmMessage(
      String title, String message, String fcm, String route) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization": serverKey,
      };
      var request = {
        "notification": {
          "title": title,
          "text": message,
          "sound": "default",
          "color": "#990000",
        },
        'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'type': route},
        "priority": "high",
        "to": fcm,
      };
      // var request2 = {
      //   'notification': {'title': title, 'body': message, "sound": "default"},
      //   'data': {
      //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      //     'type': 'COMMENT'
      //   },
      //   'to': fcm,
      // };
      await http.post(Uri.parse(url),
          headers: header, body: json.encode(request));
      return true;
    } catch (e, s) {
      print(e);
      print(s);
      return false;
    }
  }
}
