import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobheeseller/models/seller_model.dart';
import 'package:jobheeseller/screens/complete_profile/complete_profile_screen.dart';

import '../constants.dart';

class MyDatabaseService {
  final auth = FirebaseAuth.instance;
  static final _firebaseDatabase =
      FirebaseDatabase.instance.ref().child(kJob).child(kSeller);

  createUser(email, password, context) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) =>
              Navigator.pushNamed(context, CompleteProfileScreen.routeName));
    } catch (e) {
      error(context, e);
    }
  }

  loginUser(email, password, context) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {}
              //Navigator.pushNamed(context, .routeName)
              );
    } catch (e) {
      error(context, e);
    }
  }

  error(context, e) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
          );
        });
  }

  static Future<String> getCurrentUser() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return currentUser.uid.toString();
      }
    } catch (e) {
      print('current user error hy+ ' + e);
      return null;
    }
    return null;
  }

   Future<String> getDeviceToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static Future<bool> saveDeviceToken(String token) async {
    var check = await InternetConnectionChecker().hasConnection;
    if (check == true) {
      try {
        var uuid = await getCurrentUser();
        _firebaseDatabase.child(uuid).onValue.listen((event) async {
          final data = new Map<String, dynamic>.from(event.snapshot.value);
          final result = Seller.fromJson(data);
          if (result.fcm != null) {
            int res = token.compareTo(result.fcm);
            if (res != 0) {
              await _firebaseDatabase.child(uuid).update({'fcm': token});
            }
          }
        });
        return true;
      } on Exception catch (e, s) {
        print('Saving token to database failed :' + e.toString());
        return false;
      }
    }
    return false;
  }
}
