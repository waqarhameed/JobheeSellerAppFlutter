import 'package:flutter/material.dart';

class MySnakeBar {
  static createSnackBar(String message, BuildContext context) {
    final snackBar = new SnackBar(
        content: new Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red);
    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
