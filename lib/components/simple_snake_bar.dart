import 'package:flutter/material.dart';

class MySnakeBar {
  static createSnackBar(Color clr,String message, BuildContext context) {
    final snackBar = new SnackBar(
        content: new Text(message),
        duration: Duration(seconds: 4),
        backgroundColor: clr);
    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
