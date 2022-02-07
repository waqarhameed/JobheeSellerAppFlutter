import 'package:flutter/material.dart';

class CurrentOrder extends StatefulWidget {
 //const CurrentOrder(String route, {Key key}) : super(key: key);

  @override
  _CurrentOrderState createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("No current orders yet"),
      ),
    );
  }
}
