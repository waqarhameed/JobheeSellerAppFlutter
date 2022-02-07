import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_handler.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  BuildContext _context;

  void setupFirebase(BuildContext context) {
    _firebaseMessaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessingListener(context);
    _context = context;
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
    //     .getToken()
    //     .then((token) => print('My Token : $token'))
    //     .onError((error, stackTrace) {
    //   print('MyToken Error :' + error);
    // });

    // _firebaseMessaging
    //     .subscribeToTopic('subscribe to me')
    //     .whenComplete(() => print('subscribed ok'));
    FirebaseMessaging.onMessage.listen((event) {
      print('My Remote Message: $event');
      if (Platform.isAndroid) {
        showNotification(event.data['title'], event.data['body']);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('onMessageOpenedApp : $event');
      showDialog(
          context: _context,
          builder: (context) => CupertinoAlertDialog(
                title: Text(event.notification.title),
                content: Text(event.notification.body),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text('OL'),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  )
                ],
              ));
    });
  }

  static void showNotification(title, body) async {
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
        Random().nextInt(1000), title, body, platform,
        payload: 'my payload');
  }
}
