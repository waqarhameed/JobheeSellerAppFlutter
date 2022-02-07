import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'body.dart';

class UserRegisterScreen extends StatelessWidget {
  //const UserRegisterScreen({Key? key}) : super(key: key);
  static String routeName = "/user_register";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async => await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit an App'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: new Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                exit(0);
              },
              // SystemNavigator.pop()
              child: new Text('Yes'),
            ),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: Text('User Registration'),
        ),
        body: Body(),
      ),
    );
  }
}
