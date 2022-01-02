import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => await showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit an App'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: new Text('Yes'),
                  ),
                ],
              ),
            ),
        child: Scaffold(body: Body()));
  }
}
