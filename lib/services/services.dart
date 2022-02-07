import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobheeseller/screens/complete_profile/complete_profile_screen.dart';

class MyDatabaseService {
  final auth = FirebaseAuth.instance;

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
}
